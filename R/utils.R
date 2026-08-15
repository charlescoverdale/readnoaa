# Internal helpers for readnoaa

#' Validate and normalise a date string
#'
#' Accepts `"YYYY-MM-DD"` or `"YYYY-MM"` and returns `"YYYY-MM-DD"`.
#' Appends `"-01"` to month-only dates.
#'
#' @param x Character. A date string.
#' @param arg_name Character. Name of the argument (for error messages).
#' @return Character. A date in `"YYYY-MM-DD"` format.
#' @noRd
validate_date <- function(x, arg_name = "date") {
  if (is.null(x)) return(NULL)
  x <- as.character(x)
  if (grepl("^\\d{4}-\\d{2}-\\d{2}$", x)) {
    d <- as.Date(x, format = "%Y-%m-%d")
    if (is.na(d)) {
      cli::cli_abort("{.arg {arg_name}} is not a valid date: {.val {x}}.")
    }
    return(x)
  }
  if (grepl("^\\d{4}-\\d{2}$", x)) {
    d <- as.Date(paste0(x, "-01"), format = "%Y-%m-%d")
    if (is.na(d)) {
      cli::cli_abort("{.arg {arg_name}} is not a valid date: {.val {x}}.")
    }
    return(paste0(x, "-01"))
  }
  cli::cli_abort(
    "{.arg {arg_name}} must be in {.val YYYY-MM-DD} or {.val YYYY-MM} format, not {.val {x}}."
  )
}


#' Validate that start_date is before end_date
#'
#' @param start_date Character. Start date in YYYY-MM-DD format.
#' @param end_date Character. End date in YYYY-MM-DD format.
#' @noRd
validate_date_range <- function(start_date, end_date) {
  if (is.null(start_date) || is.null(end_date)) return(invisible(NULL))
  s <- as.Date(start_date)
  e <- as.Date(end_date)
  if (s > e) {
    cli::cli_abort(
      "{.arg start_date} ({.val {start_date}}) must be before {.arg end_date} ({.val {end_date}})."
    )
  }
  invisible(NULL)
}


#' Split a date range into yearly chunks
#'
#' Returns a list of 2-element character vectors, each covering at most
#' one year. Used to avoid API timeouts on large daily requests.
#'
#' @param start_date Character. Start date in YYYY-MM-DD format.
#' @param end_date Character. End date in YYYY-MM-DD format.
#' @return A list of `c(start, end)` character vectors.
#' @noRd
chunk_date_range <- function(start_date, end_date) {
  s <- as.Date(start_date)
  e <- as.Date(end_date)

  if (as.numeric(difftime(e, s, units = "days")) <= 365) {
    return(list(c(start_date, end_date)))
  }

  chunks <- list()
  current <- s
  while (current <= e) {
    chunk_end <- min(
      as.Date(paste0(format(current, "%Y"), "-12-31")),
      e
    )
    chunks <- c(chunks, list(c(
      format(current, "%Y-%m-%d"),
      format(chunk_end, "%Y-%m-%d")
    )))
    current <- chunk_end + 1L
  }
  chunks
}


#' Haversine distance between two points
#'
#' @param lat1,lon1 Numeric. Coordinates of point 1.
#' @param lat2,lon2 Numeric. Coordinates of point 2.
#' @return Numeric. Distance in kilometres.
#' @noRd
haversine <- function(lat1, lon1, lat2, lon2) {
  to_rad <- pi / 180
  dlat <- (lat2 - lat1) * to_rad
  dlon <- (lon2 - lon1) * to_rad
  a <- sin(dlat / 2)^2 +
    cos(lat1 * to_rad) * cos(lat2 * to_rad) * sin(dlon / 2)^2
  6371 * 2 * atan2(sqrt(a), sqrt(1 - a))
}


#' Columns that must never be coerced to numeric
#'
#' Station identifiers are digit strings in several NCEI datasets (ISD and
#' GSOD ids such as `"03772099999"` carry leading zeros), so they are held
#' as character throughout.
#'
#' @noRd
noaa_char_cols <- c(
  "station", "name", "date", "station_name", "station_info",
  "report_type", "source", "call_sign", "quality_control", "remarks",
  "backupname", "backupelements", "wban", "state"
)


#' Normalise NCEI column names to lowercase snake_case
#'
#' `read.csv()` turns the hyphens in normals codes such as
#' `MLY-PRCP-NORMAL` into dots, which then no longer resemble the code the
#' caller passed to `datatypes`. Underscores are used instead, so the column
#' name is the code lowercased.
#'
#' @param x Character vector of raw column names.
#' @return Character vector of cleaned names.
#' @noRd
clean_names <- function(x) {
  x <- tolower(x)
  x <- gsub("[^a-z0-9]+", "_", x)
  x <- gsub("_+", "_", x)
  sub("_$", "", x)
}


#' Parse NOAA CSV response into a data frame
#'
#' Every column is read as character so that the API's own types are never
#' guessed at, then numeric columns are coerced explicitly. Column names are
#' lowercased and the date column is converted to whatever type the dataset
#' actually warrants.
#'
#' @param csv_text Character. Raw CSV text from the NCEI API.
#' @return A data frame.
#' @noRd
parse_noaa_csv <- function(csv_text) {
  df <- tryCatch(
    utils::read.csv(text = csv_text, colClasses = "character",
                    check.names = TRUE),
    error = function(e) NULL
  )

  if (is.null(df)) return(data.frame())

  names(df) <- clean_names(names(df))

  # Lowercasing has to happen even for an empty result, otherwise callers
  # that sort on `station` or `date` see NULL and fail.
  if (nrow(df) == 0L) return(df)

  if ("date" %in% names(df)) {
    df <- convert_date_column(df)
  }

  attr_cols <- grep("_attributes$", names(df), value = TRUE)
  skip <- unique(c(noaa_char_cols, attr_cols, "month", "day", "hour"))

  for (col in setdiff(names(df), skip)) {
    if (!is.character(df[[col]])) next
    vals <- trimws(df[[col]])
    vals[!nzchar(vals)] <- NA_character_
    nums <- suppressWarnings(as.numeric(vals))
    non_na_orig <- !is.na(vals)
    # Only convert when at least one real value parses cleanly, so text
    # columns are never silently blanked to NA.
    if (any(non_na_orig) && !all(is.na(nums[non_na_orig]))) {
      df[[col]] <- nums
    } else {
      df[[col]] <- vals
    }
  }

  df
}


#' Convert the date column and add any derived calendar parts
#'
#' NCEI uses several shapes in a single `DATE` field:
#' calendar dates (`2024-01-31`), month or year stamps (`2024-01`, `2024`),
#' ISO 8601 timestamps for hourly datasets (`2024-01-31T00:51:00`), and
#' climatological pseudo-dates for the normals datasets (`01-31` for daily
#' normals, `01` for monthly normals). Only the first four are real points
#' in time; the normals pseudo-dates are kept verbatim and supplemented with
#' integer `month`, `day`, and `hour` columns.
#'
#' @param df A data frame with a character `date` column.
#' @return The data frame with `date` converted.
#' @noRd
convert_date_column <- function(df) {
  x <- trimws(as.character(df$date))
  x[!nzchar(x)] <- NA_character_
  present <- x[!is.na(x)]

  if (!length(present)) {
    df$date <- as.Date(rep(NA, length(x)))
    return(df)
  }

  all_match <- function(pat) all(grepl(pat, present))

  # Hourly observations: ISO 8601 timestamps. Kept as POSIXct in UTC, which
  # is the timescale NCEI publishes these datasets on.
  if (all_match("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}(:\\d{2})?$")) {
    df$date <- as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC")
    return(df)
  }

  if (all_match("^\\d{4}-\\d{2}-\\d{2}$")) {
    df$date <- as.Date(x, format = "%Y-%m-%d")
    return(df)
  }

  if (all_match("^\\d{4}-\\d{2}$")) {
    df$date <- as.Date(paste0(x, "-01"), format = "%Y-%m-%d")
    return(df)
  }

  if (all_match("^\\d{4}$")) {
    df$date <- as.Date(paste0(x, "-01-01"), format = "%Y-%m-%d")
    return(df)
  }

  # Hourly normals: MM-DDTHH:MM:SS
  if (all_match("^\\d{2}-\\d{2}T\\d{2}:\\d{2}(:\\d{2})?$")) {
    df$date <- x
    df <- insert_after_date(df, list(
      month = as.integer(substr(x, 1, 2)),
      day   = as.integer(substr(x, 4, 5)),
      hour  = as.integer(substr(x, 7, 8))
    ))
    return(df)
  }

  # Daily normals: MM-DD
  if (all_match("^\\d{2}-\\d{2}$")) {
    df$date <- x
    df <- insert_after_date(df, list(
      month = as.integer(substr(x, 1, 2)),
      day   = as.integer(substr(x, 4, 5))
    ))
    return(df)
  }

  # Monthly normals: MM
  if (all_match("^\\d{1,2}$")) {
    df$date <- x
    df <- insert_after_date(df, list(month = as.integer(x)))
    return(df)
  }

  # Anything unrecognised is left exactly as the API sent it rather than
  # being silently turned into NA.
  df$date <- x
  df
}


#' Insert derived columns immediately after `date`
#' @noRd
insert_after_date <- function(df, new_cols) {
  pos   <- match("date", names(df))
  left  <- df[, seq_len(pos), drop = FALSE]
  right <- if (pos < ncol(df)) df[, seq(pos + 1L, ncol(df)), drop = FALSE] else NULL

  add <- as.data.frame(new_cols, stringsAsFactors = FALSE)
  out <- if (is.null(right)) cbind(left, add) else cbind(left, add, right)
  out
}


#' Row-bind fetched chunks, tolerating differing column sets
#'
#' Chunks are fetched a year at a time and a station's reported elements can
#' change between years, so the column sets are unioned rather than assumed
#' identical.
#'
#' @param dfs A list of data frames.
#' @return A single data frame.
#' @noRd
rbind_chunks <- function(dfs) {
  dfs <- Filter(function(d) !is.null(d) && ncol(d) > 0L, dfs)
  if (!length(dfs)) return(data.frame())

  dfs <- Filter(function(d) nrow(d) > 0L, dfs)
  if (!length(dfs)) return(data.frame())
  if (length(dfs) == 1L) return(dfs[[1]])

  all_names <- unique(unlist(lapply(dfs, names)))
  dfs <- lapply(dfs, function(d) {
    missing <- setdiff(all_names, names(d))
    for (m in missing) d[[m]] <- NA
    d[, all_names, drop = FALSE]
  })

  do.call(rbind, dfs)
}


#' Order a data frame by station then date, if those columns exist
#' @noRd
order_by_station_date <- function(df) {
  if (nrow(df) == 0L) return(df)
  keys <- list()
  if ("station" %in% names(df)) keys <- c(keys, list(df$station))
  if ("date"    %in% names(df)) keys <- c(keys, list(df$date))
  if (!length(keys)) return(df)

  df <- df[do.call(order, keys), , drop = FALSE]
  rownames(df) <- NULL
  df
}


#' Drop columns that are entirely missing
#'
#' A bare `daily-summaries` request returns the full GHCN-Daily element set
#' as columns, the large majority of which no individual station reports.
#'
#' @param df A data frame.
#' @param keep Character vector of columns to retain regardless.
#' @return The data frame without all-NA columns.
#' @noRd
drop_empty_cols <- function(df, keep = c("station", "name", "date",
                                         "month", "day", "hour")) {
  if (nrow(df) == 0L) return(df)
  has_data <- vapply(df, function(x) any(!is.na(x)), logical(1))
  has_data[names(df) %in% keep] <- TRUE
  df[, has_data, drop = FALSE]
}
