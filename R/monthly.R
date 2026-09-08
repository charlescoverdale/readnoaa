#' Monthly weather summaries
#'
#' Returns monthly summary data from the NCEI Global Summary of the Month
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
#' @param drop_empty Logical. Drop columns that contain no data at all.
#'   Defaults to `TRUE` when `datatypes` is `NULL`.
#' @param cache Logical. Use cached data if available (default `TRUE`).
#' @param refresh Logical. Ignore any cached copy and refetch (default
#'   `FALSE`).
#'
#' @return A data frame with columns including:
#' \describe{
#'   \item{station}{Character. Station identifier.}
#'   \item{date}{Date. First day of the month.}
#'   \item{name}{Character. Station name.}
#'   \item{...}{Numeric. Data columns vary by station and request.}
#' }
#'
#' @family weather data
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' try({
#'   noaa_monthly("USW00094728", "2024-01", "2024-12")
#' })
#' options(op)
#' }
noaa_monthly <- function(station, start_date, end_date, datatypes = NULL,
                         units = "metric", include_flags = FALSE,
                         include_location = FALSE,
                         drop_empty = is.null(datatypes),
                         cache = TRUE, refresh = FALSE) {
  start_date <- validate_date(start_date, "start_date")
  end_date   <- validate_date(end_date, "end_date")
  validate_date_range(start_date, end_date)

  cli::cli_progress_step("Fetching monthly summaries")
  df <- noaa_fetch(
    dataset = "global-summary-of-the-month",
    stations = station,
    start_date = start_date,
    end_date = end_date,
    datatypes = datatypes,
    units = units,
    include_flags = include_flags,
    include_location = include_location,
    cache = cache,
    refresh = refresh
  )
  cli::cli_progress_done()

  if (drop_empty) df <- drop_empty_cols(df)
  order_by_station_date(df)
}
