# Find stations near a location

Searches for weather stations within a given radius of a point, sorted
by distance. Uses the GHCN-Daily station inventory.

## Usage

``` r
noaa_nearby(lat, lon, radius_km = 50, limit = 25L)
```

## Arguments

- lat:

  Numeric. Latitude of the target location.

- lon:

  Numeric. Longitude of the target location.

- radius_km:

  Numeric. Search radius in kilometres (default 50).

- limit:

  Integer. Maximum number of results (default 25).

## Value

A data frame with the same columns as
[`noaa_stations()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_stations.md)
plus:

- distance_km:

  Numeric. Distance from the target point in kilometres.

## See also

Other station discovery:
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
#>       station latitude longitude elevation      name distance_km
#> 1 UKE00105915  51.5608    0.1789       137 HAMPSTEAD    20.44295
options(op)
# }
```
