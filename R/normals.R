#' Climate normals (1991-2020)
#'
#' Returns 30-year climate normals from the NCEI Normals datasets. Normals
#' are the average conditions over the 1991-2020 reference period, and are
#' used as the baseline against which current weather is compared.
#'
#' Four periods are available, each backed by a different NCEI dataset:
#'
#' \describe{
#'   \item{`"monthly"`}{`normals-monthly-1991-2020`. Twelve rows per station.}
#'   \item{`"daily"`}{`normals-daily-1991-2020`. One row per day of the year.}
#'   \item{`"hourly"`}{`normals-hourly-1991-2020`. One row per hour of the year.}
#'   \item{`"annual"`}{`normals-annualseasonal-1991-2020`. One row per station,
#'     covering annual and seasonal statistics.}
#' }
#'
#' The daily and hourly datasets require a date window, which is supplied
#' automatically as a full calendar year unless you narrow it with
#' `start_date` and `end_date`. Because normals are climatological rather
#' than tied to a particular year, only the month and day of those arguments
#' are meaningful.
#'
#' Normals carry a climatological pseudo-date rather than a calendar date:
#' `"01"` for a month, `"01-31"` for a day of the year. These are returned
#' verbatim in `date`, with integer `month`, `day`, and `hour` columns added
#' alongside for filtering and joining. The annual and seasonal dataset has
#' no date column at all.
#'
#' @section Units:
#' The NCEI normals datasets are published in United States customary units
#' (degrees Fahrenheit, inches) and ignore the API's `units` parameter, so
#' unlike the observational functions there is no metric option. Convert
#' after the fact if you need Celsius or millimetres.
#'
#' @param station Character. One or more station IDs.
#' @param period Character. One of `"monthly"`, `"daily"`, `"hourly"`, or
#'   `"annual"`.
#' @param datatypes Optional character vector of data type codes.
#' @param start_date,end_date Optional character dates bounding the window
#'   for the `"daily"` and `"hourly"` periods. Ignored for `"monthly"` and
#'   `"annual"`, which cover the whole year by construction.
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
#' @return A data frame. Columns vary by period, but typically include
#'   `station`, a climatological `date` with derived `month`/`day`/`hour`
#'   columns, and normal values for temperature, precipitation, and other
#'   variables.
#'
#' @family weather data
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' try({
#'   # Monthly normals: twelve rows, values in Fahrenheit and inches
#'   noaa_normals("USW00094728", "monthly")
#'
#'   # Daily normals for January only
#'   noaa_normals("USW00094728", "daily",
#'   start_date = "2020-01-01", end_date = "2020-01-31")
#' })
#' options(op)
#' }
noaa_normals <- function(station, period = "monthly", datatypes = NULL,
                         start_date = NULL, end_date = NULL,
                         include_flags = FALSE, include_location = FALSE,
                         drop_empty = is.null(datatypes),
                         cache = TRUE, refresh = FALSE) {
  period <- match.arg(period, c("monthly", "daily", "hourly", "annual"))

  # The annual normals live under the "annualseasonal" identifier, not
  # "annual", and the daily and hourly datasets reject requests that carry
  # no date window.
  dataset <- switch(
    period,
    monthly = "normals-monthly-1991-2020",
    daily   = "normals-daily-1991-2020",
    hourly  = "normals-hourly-1991-2020",
    annual  = "normals-annualseasonal-1991-2020"
  )

  needs_window <- period %in% c("daily", "hourly")

  if (needs_window) {
    # 2020 is a leap year, so the default window includes 29 February.
    start_date <- if (is.null(start_date)) "2020-01-01" else validate_date(start_date, "start_date")
    end_date   <- if (is.null(end_date))   "2020-12-31" else validate_date(end_date, "end_date")
    validate_date_range(start_date, end_date)
  } else {
    if (!is.null(start_date) || !is.null(end_date)) {
      cli::cli_warn(c(
        "{.arg start_date} and {.arg end_date} are ignored for {.val {period}} normals.",
        "i" = "The {.val {period}} dataset covers the full year in one response."
      ))
    }
    start_date <- NULL
    end_date   <- NULL
  }

  cli::cli_progress_step("Fetching {period} climate normals")
  df <- noaa_fetch(
    dataset = dataset,
    stations = station,
    start_date = start_date,
    end_date = end_date,
    datatypes = datatypes,
    include_flags = include_flags,
    include_location = include_location,
    cache = cache,
    refresh = refresh
  )
  cli::cli_progress_done()

  if (drop_empty) df <- drop_empty_cols(df)

  if (nrow(df) > 0L && "station" %in% names(df)) {
    df <- df[order(df$station), , drop = FALSE]
    rownames(df) <- NULL
  }
  df
}
