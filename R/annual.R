#' Annual weather summaries
#'
#' Returns annual summary data from the NCEI Global Summary of the Year
#' dataset.
#'
#' @param station Character. One or more station IDs.
#' @param start_date Character. Start date in `"YYYY-MM-DD"` or
#'   `"YYYY-MM"` format.
#' @param end_date Character. End date in the same format.
#' @param datatypes Optional character vector of data type codes.
#' @param units Character. `"metric"` (default) or `"standard"`.
#' @param include_flags Logical. Include data quality flags from NCEI
#'   (default `FALSE`).
#' @param include_location Logical. Include station latitude, longitude,
#'   and elevation columns (default `FALSE`).
#' @param cache Logical. Use cached data if available (default `TRUE`).
#'
#' @return A data frame with columns including:
#' \describe{
#'   \item{station}{Character. Station identifier.}
#'   \item{date}{Date. First day of the year.}
#'   \item{name}{Character. Station name.}
#'   \item{...}{Numeric. Data columns vary by station and request.}
#' }
#'
#' @family weather data
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' noaa_annual("USW00094728", "2020-01-01", "2024-01-01")
#' options(op)
#' }
noaa_annual <- function(station, start_date, end_date, datatypes = NULL,
                        units = "metric", include_flags = FALSE,
                        include_location = FALSE, cache = TRUE) {
  start_date <- validate_date(start_date, "start_date")
  end_date   <- validate_date(end_date, "end_date")
  validate_date_range(start_date, end_date)

  cli::cli_progress_step("Fetching annual summaries")
  df <- noaa_fetch(
    dataset = "global-summary-of-the-year",
    stations = station,
    start_date = start_date,
    end_date = end_date,
    datatypes = datatypes,
    units = units,
    include_flags = include_flags,
    include_location = include_location,
    cache = cache
  )
  cli::cli_progress_done()

  df <- df[order(df$station, df$date), ]
  rownames(df) <- NULL
  df
}
