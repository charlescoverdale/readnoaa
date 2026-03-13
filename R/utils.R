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


#' Parse NOAA CSV response into a data frame
#'
#' Converts DATE to Date, keeps STATION/NAME as character, and coerces
#' data columns to numeric. Renames columns to lowercase.
#'
#' @param csv_text Character. Raw CSV text from the NCEI API.
#' @return A data frame.
#' @noRd
parse_noaa_csv <- function(csv_text) {
  df <- utils::read.csv(text = csv_text, stringsAsFactors = FALSE)

  if (nrow(df) == 0L) return(df)

  names(df) <- tolower(names(df))

  # Convert date column - handles YYYY-MM-DD, YYYY-MM, and YYYY formats
  if ("date" %in% names(df)) {
    df$date <- parse_noaa_date(df$date)
  }

  # Character columns to leave as-is
  char_cols <- c("station", "name")

  # Coerce remaining columns to numeric where appropriate
  for (col in setdiff(names(df), c("date", char_cols))) {
    if (is.character(df[[col]])) {
      nums <- suppressWarnings(as.numeric(df[[col]]))
      if (!all(is.na(nums) & !is.na(df[[col]]))) {
        df[[col]] <- nums
      }
    }
  }

  df
}


#' Parse NOAA date strings to Date
#'
#' Handles `YYYY-MM-DD`, `YYYY-MM`, and `YYYY` formats.
#' Monthly dates are set to the first of the month; annual to January 1.
#'
#' @param x Character vector of date strings.
#' @return A Date vector.
#' @noRd
parse_noaa_date <- function(x) {
  x <- as.character(x)
  out <- rep(as.Date(NA), length(x))

  # Daily: YYYY-MM-DD
  daily <- grepl("^\\d{4}-\\d{2}-\\d{2}$", x)
  if (any(daily)) {
    out[daily] <- as.Date(x[daily])
  }

  # Monthly: YYYY-MM
  monthly <- grepl("^\\d{4}-\\d{2}$", x) & !daily
  if (any(monthly)) {
    out[monthly] <- as.Date(paste0(x[monthly], "-01"))
  }

  # Annual: YYYY
  annual <- grepl("^\\d{4}$", x)
  if (any(annual)) {
    out[annual] <- as.Date(paste0(x[annual], "-01-01"))
  }

  out
}
