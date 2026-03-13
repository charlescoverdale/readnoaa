#' Daily weather observations
#'
#' Returns daily weather data from the NCEI Daily Summaries dataset.
#' Common data types include TMAX (maximum temperature), TMIN (minimum
#' temperature), PRCP (precipitation), SNOW (snowfall), and SNWD (snow
#' depth).
#'
#' @param station Character. One or more station IDs (e.g.
#'   `"USW00094728"` for Central Park, NYC).
#' @param start_date Character. Start date in `"YYYY-MM-DD"` or
#'   `"YYYY-MM"` format.
#' @param end_date Character. End date in the same format.
#' @param datatypes Optional character vector of data type codes to retrieve
#'   (e.g. `c("TMAX", "TMIN")`). If `NULL`, all available types are returned.
#' @param units Character. `"metric"` (default, Celsius/mm) or `"standard"`
#'   (Fahrenheit/inches).
#' @param cache Logical. Use cached data if available (default `TRUE`).
#'
#' @return A data frame with columns including:
#' \describe{
#'   \item{station}{Character. Station identifier.}
#'   \item{date}{Date. Observation date.}
#'   \item{name}{Character. Station name.}
#'   \item{...}{Numeric. Data columns vary by station and request (e.g.
#'     `tmax`, `tmin`, `prcp`).}
#' }
#'
#' @export
#' @examples
#' \donttest{
#' # Daily temperatures for Central Park, NYC
#' noaa_daily("USW00094728", "2024-01-01", "2024-01-31",
#'            datatypes = c("TMAX", "TMIN"))
#' }
noaa_daily <- function(station, start_date, end_date, datatypes = NULL,
                       units = "metric", cache = TRUE) {
  start_date <- validate_date(start_date, "start_date")
  end_date   <- validate_date(end_date, "end_date")

  cli::cli_progress_step("Fetching daily summaries")
  df <- noaa_fetch(
    dataset = "daily-summaries",
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
