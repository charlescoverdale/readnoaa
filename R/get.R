#' Fetch any NCEI dataset
#'
#' A generic fetcher for direct access to any NCEI dataset. Use
#' [list_datasets()] to see common dataset identifiers and the arguments
#' each one requires.
#'
#' @param dataset Character. The dataset identifier (e.g.
#'   `"daily-summaries"`, `"global-summary-of-the-month"`).
#' @param station Optional character vector of station IDs. Note that
#'   station identifiers are dataset-specific: the daily datasets use
#'   GHCN-Daily IDs such as `"USW00094728"`, while `global-hourly` and
#'   `global-summary-of-the-day` use ISD IDs such as `"72505394728"`.
#' @param start_date Optional start date in `"YYYY-MM-DD"` or
#'   `"YYYY-MM"` format.
#' @param end_date Optional end date in the same format.
#' @param datatypes Optional character vector of data type codes.
#' @param bbox Optional numeric vector of length 4 defining a bounding box:
#'   `c(south_lat, west_lon, north_lat, east_lon)`. Required by
#'   `global-marine`.
#' @param units Character. `"metric"` (default) or `"standard"`. Ignored by
#'   the normals datasets, which are published in US customary units.
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
#' @return A data frame. Columns vary by dataset. The `date` column is a
#'   `Date` for daily, monthly, and annual datasets, and a `POSIXct` in UTC
#'   for the hourly datasets, which publish ISO 8601 timestamps.
#'
#' @family data access
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' # Fetch daily data using the generic function
#' noaa_get("daily-summaries", station = "USW00094728",
#'          start_date = "2024-01-01", end_date = "2024-01-31")
#' options(op)
#' }
noaa_get <- function(dataset, station = NULL, start_date = NULL,
                     end_date = NULL, datatypes = NULL, bbox = NULL,
                     units = "metric", include_flags = FALSE,
                     include_location = FALSE,
                     drop_empty = is.null(datatypes),
                     cache = TRUE, refresh = FALSE) {
  if (!is.null(start_date)) start_date <- validate_date(start_date, "start_date")
  if (!is.null(end_date))   end_date   <- validate_date(end_date, "end_date")
  validate_date_range(start_date, end_date)

  cli::cli_progress_step("Fetching {dataset} data")
  df <- noaa_fetch(
    dataset = dataset,
    stations = station,
    start_date = start_date,
    end_date = end_date,
    datatypes = datatypes,
    units = units,
    bbox = bbox,
    include_flags = include_flags,
    include_location = include_location,
    cache = cache,
    refresh = refresh
  )
  cli::cli_progress_done()

  if (drop_empty) df <- drop_empty_cols(df)
  df
}
