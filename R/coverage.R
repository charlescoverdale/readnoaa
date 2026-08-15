#' Check what a station records, and for how long
#'
#' Returns the first and last year of data for each element a station
#' reports, taken from the GHCN-Daily element inventory. This is the
#' authoritative answer to two questions the data functions cannot answer on
#' their own: which variables a station actually measures, and how current
#' its record is.
#'
#' Currency varies widely. United States stations are typically complete to
#' within a few days, while many international stations lag by months, and
#' others stopped reporting years ago while remaining in the station list.
#' Checking coverage first avoids requesting a window a station never
#' covered and receiving an empty result.
#'
#' The inventory file is around 36 MB. It is downloaded on first use and
#' cached locally thereafter.
#'
#' @param station Character. One or more station IDs.
#' @param element Optional character vector of element codes (e.g.
#'   `c("TMAX", "PRCP")`) to restrict the result to.
#' @param cache Logical. Use the cached inventory if available
#'   (default `TRUE`).
#' @param refresh Logical. Ignore any cached copy and refetch (default
#'   `FALSE`).
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{station}{Character. Station identifier.}
#'   \item{element}{Character. Element code, e.g. `"TMAX"`.}
#'   \item{first_year}{Integer. First year with data.}
#'   \item{last_year}{Integer. Most recent year with data.}
#'   \item{years}{Integer. Length of the record in years.}
#' }
#'
#' @family station discovery
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' # What does Central Park record, and through when?
#' noaa_coverage("USW00094728", element = c("TMAX", "TMIN", "PRCP"))
#' options(op)
#' }
noaa_coverage <- function(station, element = NULL, cache = TRUE,
                          refresh = FALSE) {
  if (missing(station) || !length(station)) {
    cli::cli_abort("{.arg station} must name at least one station.")
  }

  inv <- fetch_inventory(cache = cache, refresh = refresh)
  out <- inv[inv$station %in% station, , drop = FALSE]

  if (!is.null(element)) {
    out <- out[out$element %in% toupper(element), , drop = FALSE]
  }

  missing_ids <- setdiff(station, unique(inv$station))
  if (length(missing_ids)) {
    cli::cli_warn(c(
      "No inventory entry for {length(missing_ids)} station{?s}: {.val {missing_ids}}.",
      "i" = "The GHCN-Daily inventory covers daily datasets only; hourly and marine station IDs will not appear."
    ))
  }

  out <- out[, c("station", "element", "first_year", "last_year"), drop = FALSE]
  if (nrow(out) > 0L) {
    out$years <- out$last_year - out$first_year + 1L
    out <- out[order(out$station, out$element), , drop = FALSE]
  } else {
    out$years <- integer()
  }
  rownames(out) <- NULL
  out
}
