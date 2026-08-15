# Find stations near a location

Searches for weather stations within a given radius of a point, sorted
by distance. Uses the GHCN-Daily station inventory.

## Usage

``` r
noaa_nearby(
  lat,
  lon,
  radius_km = 50,
  element = NULL,
  active_since = NULL,
  limit = 25L,
  cache = TRUE,
  refresh = FALSE
)
```

## Arguments

- lat:

  Numeric. Latitude of the target location.

- lon:

  Numeric. Longitude of the target location.

- radius_km:

  Numeric. Search radius in kilometres (default 50).

- element:

  Optional character vector of element codes (e.g. `"TMAX"`). Only
  stations reporting all of them are returned.

- active_since:

  Optional integer year. Only stations whose record extends to that year
  or later are returned.

- limit:

  Integer. Maximum number of results (default 25). Use `Inf` for no
  limit.

- cache:

  Logical. Use cached station list if available (default `TRUE`).

- refresh:

  Logical. Ignore any cached copy and refetch (default `FALSE`).

## Value

A data frame with the same columns as
[`noaa_stations()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_stations.md)
plus:

- distance_km:

  Numeric. Distance from the target point in kilometres.

## See also

Other station discovery:
[`noaa_coverage()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_coverage.md),
[`noaa_stations()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_stations.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
# Stations within 25 km of central London
noaa_nearby(51.5, -0.1, radius_km = 25)
#> ℹ Searching for nearby stations
#> ✔ Searching for nearby stations [2.4s]
#> 
#>       station latitude longitude elevation state      name gsn_flag
#> 1 UKE00105915  51.5608    0.1789       137  <NA> HAMPSTEAD     <NA>
#>   hcn_crn_flag wmo_id distance_km
#> 1         <NA>   <NA>    20.44295

# Only those still reporting maximum temperature recently
noaa_nearby(51.5, -0.1, radius_km = 25,
            element = "TMAX", active_since = 2024)
#> ℹ Searching for nearby stations
#> ✔ Searching for nearby stations [242ms]
#> 
#>  [1] station      latitude     longitude    elevation    state       
#>  [6] name         gsn_flag     hcn_crn_flag wmo_id       distance_km 
#> <0 rows> (or 0-length row.names)
options(op)
# }
```
