#' Fetch any NCEI dataset
#'
#' A generic fetcher for direct access to any NCEI dataset. Use
#' [list_datasets()] to see common dataset identifiers.
#'
#' @param dataset Character. The dataset identifier (e.g.
#'   `"daily-summaries"`, `"global-summary-of-the-month"`).
#' @param station Optional character vector of station IDs.
#' @param start_date Optional start date in `"YYYY-MM-DD"` or
#'   `"YYYY-MM"` format.
#' @param end_date Optional end date in the same format.
#' @param datatypes Optional character vector of data type codes.
#' @param bbox Optional numeric vector of length 4 defining a bounding box:
#'   `c(south_lat, west_lon, north_lat, east_lon)`.
#' @param units Character. `"metric"` (default) or `"standard"`.
#' @param cache Logical. Use cached data if available (default `TRUE`).
#'
#' @return A data frame. Columns vary by dataset.
#'
#' @family data access
#' @export
#' @examples
#' \donttest{
#' # Fetch daily data using the generic function
#' noaa_get("daily-summaries", station = "USW00094728",
#'          start_date = "2024-01-01", end_date = "2024-01-31")
#' }
noaa_get <- function(dataset, station = NULL, start_date = NULL,
                     end_date = NULL, datatypes = NULL, bbox = NULL,
                     units = "metric", cache = TRUE) {
  if (!is.null(start_date)) start_date <- validate_date(start_date, "start_date")
  if (!is.null(end_date))   end_date   <- validate_date(end_date, "end_date")

  cli::cli_progress_step("Fetching {dataset} data")
  df <- noaa_fetch(
    dataset = dataset,
    stations = station,
    start_date = start_date,
    end_date = end_date,
    datatypes = datatypes,
    units = units,
    bbox = bbox,
    cache = cache
  )
  cli::cli_progress_done()

  df
}
