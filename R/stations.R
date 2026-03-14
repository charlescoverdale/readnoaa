#' Search for weather stations
#'
#' Searches the GHCN-Daily station inventory by bounding box or text
#' query. The station list (~120,000 stations worldwide) is downloaded
#' once and cached locally.
#'
#' @param bbox Optional numeric vector of length 4 defining a bounding box:
#'   `c(south_lat, west_lon, north_lat, east_lon)`.
#' @param text Optional character string to search station names
#'   (case-insensitive).
#' @param limit Integer. Maximum number of results (default 25).
#' @param cache Logical. Use cached station list if available
#'   (default `TRUE`).
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{station}{Character. Station identifier.}
#'   \item{name}{Character. Station name.}
#'   \item{latitude}{Numeric. Latitude in decimal degrees.}
#'   \item{longitude}{Numeric. Longitude in decimal degrees.}
#'   \item{elevation}{Numeric. Elevation in metres.}
#' }
#'
#' @family station discovery
#' @export
#' @examples
#' \donttest{
#' # Search for stations in London area
#' noaa_stations(bbox = c(51.3, -0.5, 51.7, 0.3))
#'
#' # Search by name
#' noaa_stations(text = "Heathrow")
#' }
noaa_stations <- function(bbox = NULL, text = NULL, limit = 25L,
                          cache = TRUE) {
  cli::cli_progress_step("Searching for stations")
  df <- fetch_station_list(cache = cache)

  if (!is.null(bbox)) {
    df <- df[df$latitude  >= bbox[1] & df$latitude  <= bbox[3] &
             df$longitude >= bbox[2] & df$longitude <= bbox[4], ]
  }

  if (!is.null(text)) {
    df <- df[grepl(text, df$name, ignore.case = TRUE), ]
  }

  cli::cli_progress_done()

  if (nrow(df) > limit) {
    df <- df[seq_len(limit), ]
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
#' @param limit Integer. Maximum number of results (default 25).
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
#' # Stations within 25 km of central London
#' noaa_nearby(51.5, -0.1, radius_km = 25)
#' }
noaa_nearby <- function(lat, lon, radius_km = 50, limit = 25L) {
  # Use bounding box to pre-filter, then compute exact distances
  lat_offset <- radius_km / 111
  lon_offset <- radius_km / (111 * cos(lat * pi / 180))

  bbox <- c(
    lat - lat_offset,
    lon - lon_offset,
    lat + lat_offset,
    lon + lon_offset
  )

  cli::cli_progress_step("Searching for nearby stations")
  df <- fetch_station_list(cache = TRUE)

  # Pre-filter with bounding box
  df <- df[df$latitude  >= bbox[1] & df$latitude  <= bbox[3] &
           df$longitude >= bbox[2] & df$longitude <= bbox[4], ]
  cli::cli_progress_done()

  if (nrow(df) == 0L) {
    df$distance_km <- numeric()
    return(df)
  }

  # Compute exact haversine distance and filter
  df$distance_km <- haversine(lat, lon, df$latitude, df$longitude)
  df <- df[df$distance_km <= radius_km, ]
  df <- df[order(df$distance_km), ]

  if (nrow(df) > limit) {
    df <- df[seq_len(limit), ]
  }
  rownames(df) <- NULL
  df
}
