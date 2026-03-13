#' Climate normals (1991-2020)
#'
#' Returns 30-year climate normals from the NCEI Normals dataset. Normals
#' represent the average climate conditions over the 1991-2020 period.
#'
#' @param station Character. One or more station IDs.
#' @param period Character. One of `"monthly"`, `"daily"`, or `"annual"`.
#' @param datatypes Optional character vector of data type codes.
#' @param cache Logical. Use cached data if available (default `TRUE`).
#'
#' @return A data frame. Columns vary by period but typically include
#'   station, date or month, and normal values for temperature,
#'   precipitation, and other variables.
#'
#' @export
#' @examples
#' \donttest{
#' noaa_normals("USW00094728", "monthly")
#' }
noaa_normals <- function(station, period = "monthly", datatypes = NULL,
                         cache = TRUE) {
  period <- match.arg(period, c("monthly", "daily", "annual"))
  dataset <- paste0("normals-", period, "-1991-2020")

  cli::cli_progress_step("Fetching {period} climate normals")
  df <- noaa_fetch(
    dataset = dataset,
    stations = station,
    datatypes = datatypes,
    cache = cache
  )
  cli::cli_progress_done()

  if ("station" %in% names(df)) {
    df <- df[order(df$station), ]
  }
  rownames(df) <- NULL
  df
}
