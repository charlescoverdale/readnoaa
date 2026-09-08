#' Search for weather stations
#'
#' Searches the GHCN-Daily station inventory by bounding box or text
#' query. The station list (~130,000 stations worldwide) is downloaded
#' once and cached locally.
#'
#' Set `element` or `active_since` to restrict results to stations that
#' actually report a given variable, or that were still reporting recently.
#' Both draw on the GHCN-Daily element inventory, an additional file of
#' around 36 MB that is downloaded on first use and cached thereafter.
#'
#' @param bbox Optional numeric vector of length 4 defining a bounding box:
#'   `c(south_lat, west_lon, north_lat, east_lon)`.
#' @param text Optional character string to search station names
#'   (case-insensitive). Matched literally unless `regex = TRUE`.
#' @param element Optional character vector of element codes (e.g.
#'   `"TMAX"`). Only stations reporting all of them are returned.
#' @param active_since Optional integer year. Only stations whose record
#'   extends to that year or later are returned. When `element` is also
#'   given, the test applies to those elements.
#' @param regex Logical. Treat `text` as a regular expression rather than a
#'   literal string (default `FALSE`).
#' @param limit Integer. Maximum number of results (default 25). Use `Inf`
#'   for no limit.
#' @param cache Logical. Use cached station list if available
#'   (default `TRUE`).
#' @param refresh Logical. Ignore any cached copy and refetch (default
#'   `FALSE`).
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{station}{Character. Station identifier.}
#'   \item{name}{Character. Station name.}
#'   \item{latitude}{Numeric. Latitude in decimal degrees.}
#'   \item{longitude}{Numeric. Longitude in decimal degrees.}
#'   \item{elevation}{Numeric. Elevation in metres, or `NA` where GHCN-Daily
#'     records none.}
#'   \item{state}{Character. US state or Canadian province, where applicable.}
#'   \item{gsn_flag}{Character. `"GSN"` for GCOS Surface Network stations.}
#'   \item{hcn_crn_flag}{Character. `"HCN"` or `"CRN"` for US Historical
#'     Climatology Network and Climate Reference Network stations.}
#'   \item{wmo_id}{Character. Five-digit WMO identifier, where assigned.}
#' }
#'
#' @family station discovery
#' @seealso [noaa_coverage()] for the full element record of a station.
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' try({
#'   # Search for stations in the London area
#'   noaa_stations(bbox = c(51.3, -0.5, 51.7, 0.3))
#'
#'   # Search by name
#'   noaa_stations(text = "Heathrow")
#' })
#' options(op)
#' }
noaa_stations <- function(bbox = NULL, text = NULL, element = NULL,
                          active_since = NULL, regex = FALSE, limit = 25L,
                          cache = TRUE, refresh = FALSE) {
  cli::cli_progress_step("Searching for stations")
  df <- fetch_station_list(cache = cache, refresh = refresh)

  if (!is.null(bbox)) {
    df <- filter_bbox(df, bbox)
  }

  if (!is.null(text)) {
    df <- df[match_name(df$name, text, regex), , drop = FALSE]
  }
  cli::cli_progress_done()

  if (!is.null(element) || !is.null(active_since)) {
    df <- filter_coverage(df, element, active_since, cache = cache)
  }

  if (is.finite(limit) && nrow(df) > limit) {
    df <- df[seq_len(limit), , drop = FALSE]
  }
  rownames(df) <- NULL
  df
}


#' Find stations near a location
#'
#' Searches for weather stations within a given radius of a point,
#' sorted by distance. Uses the GHCN-Daily station inventory.
#'
#' @param lat Numeric. Latitude of the target location.
#' @param lon Numeric. Longitude of the target location.
#' @param radius_km Numeric. Search radius in kilometres (default 50).
#' @param element Optional character vector of element codes (e.g.
#'   `"TMAX"`). Only stations reporting all of them are returned.
#' @param active_since Optional integer year. Only stations whose record
#'   extends to that year or later are returned.
#' @param limit Integer. Maximum number of results (default 25). Use `Inf`
#'   for no limit.
#' @param cache Logical. Use cached station list if available
#'   (default `TRUE`).
#' @param refresh Logical. Ignore any cached copy and refetch (default
#'   `FALSE`).
#'
#' @return A data frame with the same columns as [noaa_stations()] plus:
#' \describe{
#'   \item{distance_km}{Numeric. Distance from the target point in
#'     kilometres.}
#' }
#'
#' @family station discovery
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' try({
#'   # Stations within 25 km of central London
#'   noaa_nearby(51.5, -0.1, radius_km = 25)
#'
#'   # Only those still reporting maximum temperature recently
#'   noaa_nearby(51.5, -0.1, radius_km = 25,
#'   element = "TMAX", active_since = 2024)
#' })
#' options(op)
#' }
noaa_nearby <- function(lat, lon, radius_km = 50, element = NULL,
                        active_since = NULL, limit = 25L, cache = TRUE,
                        refresh = FALSE) {
  cli::cli_progress_step("Searching for nearby stations")
  df <- fetch_station_list(cache = cache, refresh = refresh)

  # Pre-filter with a generous bounding box, then compute exact distances.
  lat_offset <- radius_km / 111
  cos_lat    <- cos(lat * pi / 180)
  lon_offset <- if (abs(cos_lat) < 1e-6) 180 else min(180, radius_km / (111 * abs(cos_lat)))

  df <- df[!is.na(df$latitude) & !is.na(df$longitude) &
           df$latitude  >= lat - lat_offset & df$latitude  <= lat + lat_offset &
           df$longitude >= lon - lon_offset & df$longitude <= lon + lon_offset, ,
           drop = FALSE]
  cli::cli_progress_done()

  if (nrow(df) == 0L) {
    df$distance_km <- numeric()
    rownames(df) <- NULL
    return(df)
  }

  df$distance_km <- haversine(lat, lon, df$latitude, df$longitude)
  df <- df[df$distance_km <= radius_km, , drop = FALSE]
  df <- df[order(df$distance_km), , drop = FALSE]

  if (!is.null(element) || !is.null(active_since)) {
    df <- filter_coverage(df, element, active_since, cache = cache)
  }

  if (is.finite(limit) && nrow(df) > limit) {
    df <- df[seq_len(limit), , drop = FALSE]
  }
  rownames(df) <- NULL
  df
}


#' Match station names literally or by regex
#'
#' `grepl()` ignores `ignore.case` when `fixed = TRUE`, so literal matching
#' is made case-insensitive by folding both sides instead.
#'
#' @noRd
match_name <- function(names_vec, text, regex) {
  if (isTRUE(regex)) {
    grepl(text, names_vec, ignore.case = TRUE)
  } else {
    grepl(toupper(text), toupper(names_vec), fixed = TRUE)
  }
}


#' Filter a station data frame by bounding box
#' @noRd
filter_bbox <- function(df, bbox) {
  if (length(bbox) != 4L || anyNA(bbox)) {
    cli::cli_abort(
      "{.arg bbox} must be a numeric vector of length 4: {.code c(south, west, north, east)}."
    )
  }
  df[!is.na(df$latitude) & !is.na(df$longitude) &
     df$latitude  >= bbox[1] & df$latitude  <= bbox[3] &
     df$longitude >= bbox[2] & df$longitude <= bbox[4], , drop = FALSE]
}


#' Restrict stations to those reporting given elements or still active
#' @noRd
filter_coverage <- function(df, element, active_since, cache = TRUE) {
  if (nrow(df) == 0L) return(df)

  inv <- fetch_inventory(cache = cache)
  inv <- inv[inv$station %in% df$station, , drop = FALSE]

  if (!is.null(element)) {
    element <- toupper(element)
    inv <- inv[inv$element %in% element, , drop = FALSE]
  }
  if (!is.null(active_since)) {
    inv <- inv[inv$last_year >= as.integer(active_since), , drop = FALSE]
  }

  if (!is.null(element)) {
    # Require every requested element, not merely one of them.
    counts <- tapply(inv$element, inv$station, function(x) length(unique(x)))
    keep <- names(counts)[counts >= length(unique(element))]
  } else {
    keep <- unique(inv$station)
  }

  df[df$station %in% keep, , drop = FALSE]
}
