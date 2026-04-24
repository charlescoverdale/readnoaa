# Search for weather stations

Searches the GHCN-Daily station inventory by bounding box or text query.
The station list (~120,000 stations worldwide) is downloaded once and
cached locally.

## Usage

``` r
noaa_stations(bbox = NULL, text = NULL, limit = 25L, cache = TRUE)
```

## Arguments

- bbox:

  Optional numeric vector of length 4 defining a bounding box:
  `c(south_lat, west_lon, north_lat, east_lon)`.

- text:

  Optional character string to search station names (case-insensitive).

- limit:

  Integer. Maximum number of results (default 25).

- cache:

  Logical. Use cached station list if available (default `TRUE`).

## Value

A data frame with columns:

- station:

  Character. Station identifier.

- name:

  Character. Station name.

- latitude:

  Numeric. Latitude in decimal degrees.

- longitude:

  Numeric. Longitude in decimal degrees.

- elevation:

  Numeric. Elevation in metres.

## See also

Other station discovery:
[`noaa_nearby()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_nearby.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
# Search for stations in London area
noaa_stations(bbox = c(51.3, -0.5, 51.7, 0.3))
#> ℹ Searching for stations
#> ✔ Searching for stations [175ms]
#> 
#>       station latitude longitude elevation      name
#> 1 UKE00105915  51.5608    0.1789     137.0 HAMPSTEAD
#> 2 UKM00003772  51.4780   -0.4610      25.3  HEATHROW

# Search by name
noaa_stations(text = "Heathrow")
#> ℹ Searching for stations
#> ✔ Searching for stations [263ms]
#> 
#>       station latitude longitude elevation     name
#> 1 UKE00107650  51.4789    0.4489      25.0 HEATHROW
#> 2 UKM00003772  51.4780   -0.4610      25.3 HEATHROW
options(op)
# }
```
