#' List common NCEI datasets
#'
#' Returns a curated table of the most commonly used NCEI datasets. No
#' network call is made.
#'
#' The `requires` column records constraints the API enforces: some datasets
#' reject requests that carry no date window, and `global-marine` is
#' organised by area rather than by station, so it requires a bounding box.
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{dataset}{Character. Dataset identifier for use with [noaa_get()].}
#'   \item{description}{Character. Brief description.}
#'   \item{frequency}{Character. Temporal resolution.}
#'   \item{requires}{Character. Arguments the API requires, or `""`.}
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
      "normals-hourly-1991-2020",
      "global-hourly",
      "global-summary-of-the-day",
      "global-marine",
      "local-climatological-data",
      "coop-hourly-precipitation"
    ),
    description = c(
      "Daily weather observations (TMAX, TMIN, PRCP, SNOW, etc.)",
      "Monthly aggregated summaries",
      "Annual aggregated summaries",
      "30-year daily climate normals (1991-2020)",
      "30-year monthly climate normals (1991-2020)",
      "30-year annual and seasonal climate normals (1991-2020)",
      "30-year hourly climate normals (1991-2020)",
      "Hourly weather observations (ISD)",
      "Daily summary of global observations (GSOD)",
      "Marine surface observations",
      "Local climatological data (hourly, daily, monthly)",
      "Cooperative observer hourly precipitation"
    ),
    frequency = c(
      "Daily", "Monthly", "Annual", "Daily", "Monthly", "Annual",
      "Hourly", "Hourly", "Daily", "Variable",
      "Hourly/Daily/Monthly", "Hourly"
    ),
    requires = c(
      "dates", "dates", "dates", "dates", "", "", "dates",
      "dates", "dates", "bbox", "dates", "dates"
    ),
    stringsAsFactors = FALSE
  )
}


#' List available data types for a dataset
#'
#' Reports the element codes a station actually records.
#'
#' For the daily datasets this reads the GHCN-Daily element inventory, which
#' states exactly which elements a station reports and over what years. That
#' inventory file is around 36 MB, downloaded on first use and cached
#' thereafter.
#'
#' For other datasets, where no such inventory exists, a short sample
#' request is made and the columns that came back with data are reported.
#' The sample window is taken from the end of the requested range, or from
#' the recent past when no range is given.
#'
#' A station's element list spans its entire history, and stations routinely
#' stop recording some variables. Supply `start_date` and `end_date` to see
#' only the elements whose record overlaps the period you care about.
#'
#' @param dataset Character. Dataset identifier (e.g. `"daily-summaries"`).
#' @param station Character. A station ID to query.
#' @param start_date,end_date Optional character dates. For the daily
#'   datasets these restrict the result to elements recorded during the
#'   window; for other datasets they bound the sample request.
#' @param cache Logical. Use cached data if available (default `TRUE`).
#'
#' @return A character vector of available data type codes.
#'
#' @family data access
#' @seealso [noaa_coverage()] for the years each element spans.
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' try({
#'   # Everything Central Park has ever recorded
#'   list_datatypes("daily-summaries", "USW00094728")
#'
#'   # Only what it still records
#'   list_datatypes("daily-summaries", "USW00094728", start_date = "2025-01-01")
#' })
#' options(op)
#' }
list_datatypes <- function(dataset, station, start_date = NULL,
                           end_date = NULL, cache = TRUE) {

  # The daily datasets have a published inventory, which is both exact and
  # cheaper than guessing from a sample request.
  if (dataset %in% c("daily-summaries", "global-summary-of-the-month",
                     "global-summary-of-the-year")) {
    cov <- fetch_inventory(cache = cache)
    cov <- cov[cov$station %in% station, , drop = FALSE]

    # A station's element list covers its whole history, so restrict to the
    # elements whose record actually overlaps the window of interest.
    if (nrow(cov) > 0L && (!is.null(start_date) || !is.null(end_date))) {
      from <- if (is.null(start_date)) -Inf else as.integer(format(as.Date(validate_date(start_date, "start_date")), "%Y"))
      to   <- if (is.null(end_date))    Inf else as.integer(format(as.Date(validate_date(end_date, "end_date")), "%Y"))
      cov  <- cov[cov$last_year >= from & cov$first_year <= to, , drop = FALSE]
    }

    if (nrow(cov) > 0L) {
      return(sort(unique(cov$element)))
    }
    cli::cli_warn(c(
      "No inventory entry for station {.val {station}}.",
      "i" = "Falling back to a sample request."
    ))
  }

  if (is.null(end_date)) {
    end_date <- as.character(Sys.Date() - 10)
  } else {
    end_date <- validate_date(end_date, "end_date")
  }
  if (is.null(start_date)) {
    start_date <- as.character(as.Date(end_date) - 30)
  } else {
    start_date <- validate_date(start_date, "start_date")
  }
  validate_date_range(start_date, end_date)

  cli::cli_progress_step("Discovering data types for {dataset}")
  df <- noaa_fetch(
    dataset = dataset,
    stations = station,
    start_date = start_date,
    end_date = end_date,
    cache = cache
  )
  cli::cli_progress_done()

  if (nrow(df) == 0L) {
    cli::cli_warn(c(
      "No data returned for {.val {station}} between {.val {start_date}} and {.val {end_date}}.",
      "i" = "Widen the window with {.arg start_date} and {.arg end_date}."
    ))
    return(character())
  }

  # Report only columns that carried data, not the dataset's whole schema.
  df <- drop_empty_cols(df, keep = character())
  exclude <- c("station", "date", "name", "month", "day", "hour",
               "latitude", "longitude", "elevation")
  types <- setdiff(names(df), exclude)
  types <- types[!grepl("_attributes$", types)]
  sort(toupper(types))
}
