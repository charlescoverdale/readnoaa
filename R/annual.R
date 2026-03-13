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
#' @export
#' @examples
#' \donttest{
#' noaa_annual("USW00094728", "2020-01-01", "2024-01-01")
#' }
noaa_annual <- function(station, start_date, end_date, datatypes = NULL,
                        units = "metric", cache = TRUE) {
  start_date <- validate_date(start_date, "start_date")
  end_date   <- validate_date(end_date, "end_date")

  cli::cli_progress_step("Fetching annual summaries")
  df <- noaa_fetch(
    dataset = "global-summary-of-the-year",
    stations = station,
    start_date = start_date,
    end_date = end_date,
    datatypes = datatypes,
    units = units,
    cache = cache
  )
  cli::cli_progress_done()

  df <- df[order(df$station, df$date), ]
  rownames(df) <- NULL
  df
}
