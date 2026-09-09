# Internal HTTP helpers for readnoaa

noaa_data_url      <- "https://www.ncei.noaa.gov/access/services/data/v1"
noaa_stations_url  <- "https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt"
noaa_inventory_url <- "https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt"

#' @noRd
noaa_cache_dir <- function() {
  getOption("readnoaa.cache_dir", default = tools::R_user_dir("readnoaa", "cache"))
}


# ---- cache keys ------------------------------------------------------------

#' MD5 digest of a character string
#'
#' Uses `tools::md5sum()` on a temporary file so that no hashing dependency
#' is required.
#'
#' @param x Character. Value to digest.
#' @return Character. A 32-character hex digest.
#' @noRd
str_md5 <- function(x) {
  tf <- tempfile("readnoaa_key_")
  on.exit(unlink(tf), add = TRUE)
  con <- file(tf, open = "wb")
  on.exit(close(con), add = TRUE, after = FALSE)
  writeBin(charToRaw(x), con)
  close(con)
  on.exit(unlink(tf), add = FALSE)
  unname(tools::md5sum(tf))
}


#' Build a bounded-length cache filename for a data request
#'
#' The filename keeps a readable prefix for debugging, then appends a digest
#' of the full request so that distinct requests never collide and the name
#' stays well inside the 255-character filesystem limit regardless of how
#' many stations were requested.
#'
#' @return Character. A cache filename.
#' @noRd
noaa_cache_key <- function(dataset, stations = NULL, start_date = NULL,
                           end_date = NULL, datatypes = NULL, bbox = NULL,
                           units = "metric", include_flags = FALSE,
                           include_location = FALSE) {
  canonical <- paste(
    dataset,
    paste(stations, collapse = ","),
    start_date,
    end_date,
    paste(datatypes, collapse = ","),
    paste(bbox, collapse = ","),
    units,
    include_flags,
    include_location,
    sep = "|"
  )

  prefix <- dataset
  if (!is.null(stations)) {
    extra  <- if (length(stations) > 1L) paste0("+", length(stations) - 1L) else ""
    prefix <- paste0(prefix, "_", stations[1], extra)
  }
  if (!is.null(start_date)) prefix <- paste0(prefix, "_", start_date)
  if (!is.null(end_date))   prefix <- paste0(prefix, "_", end_date)
  prefix <- gsub("[^A-Za-z0-9._+-]", "_", prefix)
  prefix <- substr(prefix, 1L, 80L)

  paste0(prefix, "_", substr(str_md5(canonical), 1L, 12L), ".csv")
}


# ---- cache freshness -------------------------------------------------------

#' Maximum age, in days, before a cached response is refetched
#'
#' NCEI publishes daily observations with a few days' lag and continues to
#' revise recent records, so any request whose window reaches into the last
#' five weeks is treated as provisional and expires quickly. Requests that
#' end well in the past are treated as settled.
#'
#' @param end_date Character or `NULL`. End of the requested window.
#' @return Numeric. Age in days.
#' @noRd
cache_max_age <- function(end_date) {
  settled <- getOption("readnoaa.cache_days", 30)
  recent  <- getOption("readnoaa.cache_days_recent", 1)

  if (is.null(end_date)) return(settled)
  e <- suppressWarnings(as.Date(end_date))
  if (is.na(e)) return(settled)

  if (as.numeric(Sys.Date() - e) < 35) recent else settled
}


#' Is a cached file present and still within its maximum age?
#' @noRd
cache_is_fresh <- function(path, end_date) {
  if (!file.exists(path)) return(FALSE)
  mtime <- file.info(path)$mtime
  if (is.na(mtime)) return(FALSE)
  age <- as.numeric(difftime(Sys.time(), mtime, units = "days"))
  age <= cache_max_age(end_date)
}


#' Read a cached response as UTF-8 text
#' @noRd
read_cache <- function(path) {
  n   <- file.size(path)
  raw <- readBin(path, "raw", n = n)
  txt <- rawToChar(raw)
  Encoding(txt) <- "UTF-8"
  txt
}


#' Write a response to the cache atomically
#'
#' Writes to a temporary file in the cache directory and renames it into
#' place, so an interrupted download can never leave a truncated file that
#' would be served as valid data on the next call.
#'
#' @return Invisible logical. `TRUE` on success.
#' @noRd
write_cache <- function(csv_text, cache_file) {
  dir.create(dirname(cache_file), recursive = TRUE, showWarnings = FALSE)
  tmp <- paste0(cache_file, ".tmp", Sys.getpid())

  # The connection must be closed before the rename, not on function exit.
  # on.exit() registers against write_cache()'s frame rather than the
  # tryCatch block, so the handle was still open when file.rename() ran.
  # Unix renames an open file happily; Windows refuses, so the rename
  # returned FALSE and the cache write silently failed on that platform
  # alone.
  con <- NULL
  ok <- tryCatch({
    con <- file(tmp, open = "wb")
    writeBin(charToRaw(csv_text), con)
    close(con)
    con <- NULL
    TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)

  # Close a handle left open by a failed write, so the unlink below can
  # remove the temporary file on Windows too.
  if (!is.null(con)) try(close(con), silent = TRUE)

  if (!ok) {
    unlink(tmp)
    return(invisible(FALSE))
  }
  if (!file.rename(tmp, cache_file)) {
    unlink(tmp)
    return(invisible(FALSE))
  }
  invisible(TRUE)
}


# ---- error reporting -------------------------------------------------------

#' Extract human-readable detail from an NCEI JSON error body
#'
#' NCEI returns errors as JSON with `field` and `message` entries. Those are
#' far more useful than the bare status code, so they are surfaced to the
#' user. Parsed with regular expressions to avoid a JSON dependency.
#'
#' @param body Character. Raw response body.
#' @return Character vector of detail lines, possibly empty.
#' @noRd
ncei_error_detail <- function(body) {
  if (!length(body) || !nzchar(body)) return(character())

  pull <- function(key) {
    m <- regmatches(body, gregexpr(paste0('"', key, '"\\s*:\\s*"[^"]*"'), body))[[1]]
    if (!length(m)) return(character())
    m <- sub(paste0('^"', key, '"\\s*:\\s*"'), "", m)
    sub('"$', "", m)
  }

  msgs <- pull("message")
  if (!length(msgs)) {
    top <- pull("errorMessage")
    return(if (length(top)) top else character())
  }

  flds <- pull("field")
  if (length(flds) == length(msgs)) paste0(flds, ": ", msgs) else msgs
}


# ---- data fetching ---------------------------------------------------------

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
#' @param refresh Logical. Ignore any cached copy and refetch.
#' @return A data frame parsed from the CSV response.
#' @noRd
noaa_fetch <- function(dataset, stations = NULL, start_date = NULL,
                       end_date = NULL, datatypes = NULL, units = "metric",
                       bbox = NULL, include_flags = FALSE,
                       include_location = FALSE, cache = TRUE,
                       refresh = FALSE) {

  cache_dir  <- noaa_cache_dir()
  cache_file <- file.path(cache_dir, noaa_cache_key(
    dataset, stations, start_date, end_date, datatypes, bbox,
    units, include_flags, include_location
  ))

  if (cache && !refresh && cache_is_fresh(cache_file, end_date)) {
    return(parse_noaa_csv(read_cache(cache_file)))
  }

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
      httr2::resp_status(resp) %in% c(429L, 500L, 502L, 503L, 504L)
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
  ct     <- httr2::resp_content_type(resp)
  body   <- tryCatch(httr2::resp_body_string(resp), error = function(e) "")

  if (status >= 400L || grepl("json", ct, fixed = TRUE)) {
    detail <- ncei_error_detail(body)
    msg <- c("NCEI API returned HTTP {status} for dataset {.val {dataset}}.")
    if (length(detail)) {
      names(detail) <- rep("x", length(detail))
      msg <- c(msg, detail)
    }
    msg <- c(msg, "i" = "See {.url https://www.ncei.noaa.gov/support/access-data-service-api-user-documentation}.")
    cli::cli_abort(msg)
  }

  if (grepl("text/html", ct, fixed = TRUE)) {
    cli::cli_abort(c(
      "NCEI returned an error page instead of data.",
      "i" = "Check that {.arg dataset} ({.val {dataset}}) and station IDs are valid."
    ))
  }

  if (nchar(trimws(body)) == 0L) {
    cli::cli_abort(c(
      "No data returned for this query.",
      "i" = "Check the station ID, date range, and dataset are correct."
    ))
  }

  df <- parse_noaa_csv(body)

  # Only cache responses that actually carry observations. A header-only or
  # partial response usually means the window runs past what NCEI has
  # published yet; caching it would freeze that gap in place permanently.
  if (cache && nrow(df) > 0L) {
    write_cache(body, cache_file)
  }

  df
}


# ---- station metadata ------------------------------------------------------

#' Download a GHCN-Daily fixed-width metadata file
#'
#' @param url Character. Source URL.
#' @param label Character. Human-readable name, used in messages.
#' @return Character vector of lines.
#' @noRd
fetch_ghcnd_file <- function(url, label) {
  req <- httr2::request(url)
  req <- httr2::req_retry(req, max_tries = 3L, backoff = ~ 5)
  req <- httr2::req_user_agent(req, "readnoaa R package (https://github.com/charlescoverdale/readnoaa)")

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      cli::cli_abort(c(
        "Failed to download the GHCN-Daily {label}.",
        "i" = "Check your internet connection or try again later.",
        "i" = "Original error: {conditionMessage(e)}"
      ))
    }
  )

  if (httr2::resp_status(resp) >= 400L) {
    cli::cli_abort("NCEI returned HTTP {httr2::resp_status(resp)} for the GHCN-Daily {label}.")
  }

  txt <- httr2::resp_body_string(resp)
  strsplit(txt, "\n", fixed = TRUE)[[1]]
}


#' Fetch the GHCND station inventory
#'
#' Downloads and caches the GHCND stations file from NCEI. This is a
#' fixed-width text file listing all ~130,000 GHCN-Daily stations with
#' their coordinates, names, and network flags.
#'
#' @param cache Logical. Cache the parsed result locally.
#' @param refresh Logical. Ignore any cached copy and refetch.
#' @return A data frame with columns: station, name, latitude, longitude,
#'   elevation, state, gsn_flag, hcn_crn_flag, wmo_id.
#' @noRd
fetch_station_list <- function(cache = TRUE, refresh = FALSE) {

  cache_dir  <- noaa_cache_dir()
  cache_file <- file.path(cache_dir, "ghcnd_stations.rds")

  if (cache && !refresh && cache_is_fresh(cache_file, NULL)) {
    got <- tryCatch(readRDS(cache_file), error = function(e) NULL)
    if (!is.null(got)) return(got)
  }

  lines <- fetch_ghcnd_file(noaa_stations_url, "station list")
  lines <- lines[nchar(lines) >= 41L]

  # Fixed-width layout documented in the GHCN-Daily readme:
  # 1-11 ID, 13-20 LAT, 22-30 LON, 32-37 ELEV, 39-40 STATE, 42-71 NAME,
  # 73-75 GSN FLAG, 77-79 HCN/CRN FLAG, 81-85 WMO ID.
  blank_to_na <- function(x) {
    x <- trimws(x)
    x[!nzchar(x)] <- NA_character_
    x
  }

  elevation <- as.numeric(substr(lines, 32, 37))
  # -999.9 is the GHCN-Daily sentinel for a missing elevation.
  elevation[!is.na(elevation) & elevation == -999.9] <- NA_real_

  df <- data.frame(
    station      = trimws(substr(lines, 1, 11)),
    latitude     = as.numeric(substr(lines, 13, 20)),
    longitude    = as.numeric(substr(lines, 22, 30)),
    elevation    = elevation,
    state        = blank_to_na(substr(lines, 39, 40)),
    name         = trimws(substr(lines, 42, 71)),
    gsn_flag     = blank_to_na(substr(lines, 73, 75)),
    hcn_crn_flag = blank_to_na(substr(lines, 77, 79)),
    wmo_id       = blank_to_na(substr(lines, 81, 85)),
    stringsAsFactors = FALSE
  )

  if (cache) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    tmp <- paste0(cache_file, ".tmp", Sys.getpid())
    saveRDS(df, tmp)
    if (!file.rename(tmp, cache_file)) unlink(tmp)
  }

  df
}


#' Fetch the GHCND element inventory
#'
#' Downloads and caches `ghcnd-inventory.txt`, which records the first and
#' last year of data for every station and element combination. This is the
#' authoritative source for which variables a station actually reports and
#' how current its record is.
#'
#' The file is around 36 MB, so it is only downloaded when a coverage-aware
#' function needs it.
#'
#' @param cache Logical. Cache the parsed result locally.
#' @param refresh Logical. Ignore any cached copy and refetch.
#' @return A data frame with columns: station, latitude, longitude, element,
#'   first_year, last_year.
#' @noRd
fetch_inventory <- function(cache = TRUE, refresh = FALSE) {

  cache_dir  <- noaa_cache_dir()
  cache_file <- file.path(cache_dir, "ghcnd_inventory.rds")

  if (cache && !refresh && cache_is_fresh(cache_file, NULL)) {
    got <- tryCatch(readRDS(cache_file), error = function(e) NULL)
    if (!is.null(got)) return(got)
  }

  cli::cli_alert_info("Downloading the GHCN-Daily element inventory (~36 MB, cached after first use).")
  lines <- fetch_ghcnd_file(noaa_inventory_url, "element inventory")
  lines <- lines[nchar(lines) >= 45L]

  # Fixed-width layout: 1-11 ID, 13-20 LAT, 22-30 LON, 32-35 ELEMENT,
  # 37-40 FIRSTYEAR, 42-45 LASTYEAR.
  df <- data.frame(
    station    = trimws(substr(lines, 1, 11)),
    latitude   = as.numeric(substr(lines, 13, 20)),
    longitude  = as.numeric(substr(lines, 22, 30)),
    element    = trimws(substr(lines, 32, 35)),
    first_year = as.integer(substr(lines, 37, 40)),
    last_year  = as.integer(substr(lines, 42, 45)),
    stringsAsFactors = FALSE
  )

  if (cache) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    tmp <- paste0(cache_file, ".tmp", Sys.getpid())
    saveRDS(df, tmp)
    if (!file.rename(tmp, cache_file)) unlink(tmp)
  }

  df
}
