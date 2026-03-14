#' List common NCEI datasets
#'
#' Returns a curated table of the most commonly used NCEI datasets. No
#' network call is made.
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{dataset}{Character. Dataset identifier for use with [noaa_get()].}
#'   \item{description}{Character. Brief description.}
#'   \item{frequency}{Character. Temporal resolution.}
#' }
#'
#' @family data access
#' @export
#' @examples
#' list_datasets()
list_datasets <- function() {
  data.frame(
    dataset = c(
      "daily-summaries",
      "global-summary-of-the-month",
      "global-summary-of-the-year",
      "normals-daily-1991-2020",
      "normals-monthly-1991-2020",
      "normals-annualseasonal-1991-2020",
      "global-hourly",
      "global-marine",
      "local-climatological-data",
      "precipitation-15",
      "precipitation-hourly"
    ),
    description = c(
      "Daily weather observations (TMAX, TMIN, PRCP, SNOW, etc.)",
      "Monthly aggregated summaries",
      "Annual aggregated summaries",
      "30-year daily climate normals (1991-2020)",
      "30-year monthly climate normals (1991-2020)",
      "30-year annual/seasonal climate normals (1991-2020)",
      "Hourly weather observations",
      "Marine surface observations",
      "Local climatological data (hourly, daily, monthly)",
      "15-minute precipitation",
      "Hourly precipitation"
    ),
    frequency = c(
      "Daily", "Monthly", "Annual", "Daily", "Monthly", "Annual",
      "Hourly", "Variable", "Hourly/Daily/Monthly",
      "15-minute", "Hourly"
    ),
    stringsAsFactors = FALSE
  )
}


#' List available data types for a dataset
#'
#' Queries the NCEI API to discover what data types (variables) are
#' available for a given dataset and station. This makes a short data
#' request to identify available columns.
#'
#' @param dataset Character. Dataset identifier (e.g. `"daily-summaries"`).
#' @param station Character. A station ID to query.
#' @param cache Logical. Use cached data if available (default `TRUE`).
#'
#' @return A character vector of available data type codes.
#'
#' @family data access
#' @export
#' @examples
#' \donttest{
#' list_datatypes("daily-summaries", "USW00094728")
#' }
list_datatypes <- function(dataset, station, cache = TRUE) {
  cli::cli_progress_step("Discovering data types for {dataset}")

  # Fetch a small sample to see what columns come back
  df <- noaa_fetch(
    dataset = dataset,
    stations = station,
    start_date = "2024-01-01",
    end_date = "2024-01-07",
    cache = cache
  )
  cli::cli_progress_done()

  # Exclude metadata columns
  exclude <- c("station", "date", "name", "latitude", "longitude", "elevation")
  types <- setdiff(names(df), exclude)
  toupper(types)
}
