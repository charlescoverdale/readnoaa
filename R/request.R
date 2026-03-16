# Internal HTTP helpers for readnoaa

noaa_data_url <- "https://www.ncei.noaa.gov/access/services/data/v1"
noaa_stations_url <- "https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt"

#' @noRd
noaa_cache_dir <- function() {
  getOption("readnoaa.cache_dir", default = tools::R_user_dir("readnoaa", "cache"))
}


#' Fetch data from the NCEI Data Service API
#'
#' @param dataset Character. The dataset identifier (e.g. "daily-summaries").
#' @param stations Character. One or more station IDs.
#' @param start_date Character. Start date in YYYY-MM-DD format.
#' @param end_date Character. End date in YYYY-MM-DD format.
#' @param datatypes Optional character vector of data type codes.
#' @param units Character. `"metric"` or `"standard"`.
#' @param bbox Optional numeric vector of length 4: c(south, west, north, east).
#' @param include_flags Logical. Include data quality flags (default `FALSE`).
#' @param include_location Logical. Include station lat/lon/elevation
#'   (default `FALSE`).
#' @param cache Logical. Cache the result locally.
#' @return A data frame parsed from the CSV response.
#' @noRd
noaa_fetch <- function(dataset, stations = NULL, start_date = NULL,
                       end_date = NULL, datatypes = NULL, units = "metric",
                       bbox = NULL, include_flags = FALSE,
                       include_location = FALSE, cache = TRUE) {
  # Build cache key

  cache_dir <- noaa_cache_dir()
  cache_parts <- dataset
  if (!is.null(stations)) {
    cache_parts <- paste0(cache_parts, "_", paste(stations, collapse = "-"))
  }
  if (!is.null(start_date)) {
    cache_parts <- paste0(cache_parts, "_", start_date)
  }
  if (!is.null(end_date)) {
    cache_parts <- paste0(cache_parts, "_", end_date)
  }
  if (!is.null(datatypes)) {
    cache_parts <- paste0(cache_parts, "_", paste(datatypes, collapse = "-"))
  }
  if (!is.null(bbox)) {
    cache_parts <- paste0(cache_parts, "_bbox_", paste(bbox, collapse = "_"))
  }
  cache_parts <- paste0(cache_parts, "_", units)
  if (include_flags) cache_parts <- paste0(cache_parts, "_flags")
  if (include_location) cache_parts <- paste0(cache_parts, "_loc")
  cache_file <- file.path(cache_dir, paste0(cache_parts, ".csv"))

  if (cache && file.exists(cache_file)) {
    csv_text <- paste(readLines(cache_file, warn = FALSE), collapse = "\n")
    return(parse_noaa_csv(csv_text))
  }

  # Build query params
  params <- list(dataset = dataset, format = "csv", units = units,
                 includeStationName = "true")

  if (include_flags) {
    params$includeAttributes <- "true"
  }
  if (include_location) {
    params$includeStationLocation <- "true"
  }

  if (!is.null(stations)) {
    params$stations <- paste(stations, collapse = ",")
  }
  if (!is.null(start_date)) {
    params$startDate <- start_date
  }
  if (!is.null(end_date)) {
    params$endDate <- end_date
  }
  if (!is.null(datatypes)) {
    params$dataTypes <- paste(datatypes, collapse = ",")
  }
  if (!is.null(bbox)) {
    params$boundingBox <- paste(bbox, collapse = ",")
  }

  req <- httr2::request(noaa_data_url)
  req <- httr2::req_url_query(req, !!!params)
  req <- httr2::req_throttle(req, rate = 3 / 10)
  req <- httr2::req_retry(
    req, max_tries = 3L, backoff = ~ 5,
    is_transient = function(resp) {
      httr2::resp_status(resp) %in% c(429L, 503L)
    }
  )
  req <- httr2::req_user_agent(req, "readnoaa R package (https://github.com/charlescoverdale/readnoaa)")
  req <- httr2::req_error(req, is_error = function(resp) FALSE)

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      cli::cli_abort(c(
        "Failed to connect to the NCEI Data Service API.",
        "i" = "Check your internet connection or try again later.",
        "i" = "Original error: {conditionMessage(e)}"
      ))
    }
  )

  status <- httr2::resp_status(resp)
  ct <- httr2::resp_content_type(resp)

  if (grepl("text/html", ct, fixed = TRUE)) {
    cli::cli_abort(c(
      "NCEI returned an error page instead of data.",
      "i" = "Check that {.arg dataset} ({.val {dataset}}) and station IDs are valid."
    ))
  }

  if (status >= 400L) {
    cli::cli_abort("NCEI API returned HTTP {status}.")
  }

  csv_text <- httr2::resp_body_string(resp)

  if (nchar(trimws(csv_text)) == 0L) {
    cli::cli_abort(c(
      "No data returned for this query.",
      "i" = "Check the station ID, date range, and dataset are correct."
    ))
  }

  if (cache) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    writeLines(csv_text, cache_file)
  }

  parse_noaa_csv(csv_text)
}


#' Fetch the GHCND station inventory
#'
#' Downloads and caches the GHCND stations file from NCEI. This is a
#' fixed-width text file listing all ~120,000 GHCN-Daily stations with
#' their coordinates and names.
#'
#' @param cache Logical. Cache the parsed result locally.
#' @return A data frame with columns: station, name, latitude, longitude,
#'   elevation.
#' @noRd
fetch_station_list <- function(cache = TRUE) {

  cache_dir  <- noaa_cache_dir()
  cache_file <- file.path(cache_dir, "ghcnd_stations.rds")

  if (cache && file.exists(cache_file)) {
    return(readRDS(cache_file))
  }

  req <- httr2::request(noaa_stations_url)
  req <- httr2::req_retry(req, max_tries = 3L, backoff = ~ 5)
  req <- httr2::req_user_agent(req, "readnoaa R package (https://github.com/charlescoverdale/readnoaa)")

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      cli::cli_abort(c(
        "Failed to download the GHCND station list.",
        "i" = "Check your internet connection or try again later.",
        "i" = "Original error: {conditionMessage(e)}"
      ))
    }
  )

  txt <- httr2::resp_body_string(resp)
  lines <- strsplit(txt, "\n", fixed = TRUE)[[1]]
  lines <- lines[nchar(lines) >= 41L]

  # Fixed-width format:
  # 1-11: station ID, 13-20: latitude, 22-30: longitude,
  # 32-37: elevation, 42-71: name
  df <- data.frame(
    station   = trimws(substr(lines, 1, 11)),
    latitude  = as.numeric(substr(lines, 13, 20)),
    longitude = as.numeric(substr(lines, 22, 30)),
    elevation = as.numeric(substr(lines, 32, 37)),
    name      = trimws(substr(lines, 42, 71)),
    stringsAsFactors = FALSE
  )

  if (cache) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    saveRDS(df, cache_file)
  }

  df
}
