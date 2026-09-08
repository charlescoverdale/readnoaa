# Search for weather stations

Searches the GHCN-Daily station inventory by bounding box or text query.
The station list (~130,000 stations worldwide) is downloaded once and
cached locally.

## Usage

``` r
noaa_stations(
  bbox = NULL,
  text = NULL,
  element = NULL,
  active_since = NULL,
  regex = FALSE,
  limit = 25L,
  cache = TRUE,
  refresh = FALSE
)
```

## Arguments

- bbox:

  Optional numeric vector of length 4 defining a bounding box:
  `c(south_lat, west_lon, north_lat, east_lon)`.

- text:

  Optional character string to search station names (case-insensitive).
  Matched literally unless `regex = TRUE`.

- element:

  Optional character vector of element codes (e.g. `"TMAX"`). Only
  stations reporting all of them are returned.

- active_since:

  Optional integer year. Only stations whose record extends to that year
  or later are returned. When `element` is also given, the test applies
  to those elements.

- regex:

  Logical. Treat `text` as a regular expression rather than a literal
  string (default `FALSE`).

- limit:

  Integer. Maximum number of results (default 25). Use `Inf` for no
  limit.

- cache:

  Logical. Use cached station list if available (default `TRUE`).

- refresh:

  Logical. Ignore any cached copy and refetch (default `FALSE`).

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

  Numeric. Elevation in metres, or `NA` where GHCN-Daily records none.

- state:

  Character. US state or Canadian province, where applicable.

- gsn_flag:

  Character. `"GSN"` for GCOS Surface Network stations.

- hcn_crn_flag:

  Character. `"HCN"` or `"CRN"` for US Historical Climatology Network
  and Climate Reference Network stations.

- wmo_id:

  Character. Five-digit WMO identifier, where assigned.

## Details

Set `element` or `active_since` to restrict results to stations that
actually report a given variable, or that were still reporting recently.
Both draw on the GHCN-Daily element inventory, an additional file of
around 36 MB that is downloaded on first use and cached thereafter.

## See also

[`noaa_coverage()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_coverage.md)
for the full element record of a station.

Other station discovery:
[`noaa_coverage()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_coverage.md),
[`noaa_nearby()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_nearby.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
try({
  # Search for stations in the London area
  noaa_stations(bbox = c(51.3, -0.5, 51.7, 0.3))

  # Search by name
  noaa_stations(text = "Heathrow")
})
#> ℹ Searching for stations
#> ✔ Searching for stations [177ms]
#> 
#> ℹ Searching for stations
#> ✔ Searching for stations [228ms]
#> 
#>       station latitude longitude elevation state     name gsn_flag hcn_crn_flag
#> 1 UKE00107650  51.4789    0.4489      25.0  <NA> HEATHROW     <NA>         <NA>
#> 2 UKM00003772  51.4780   -0.4610      25.3  <NA> HEATHROW     <NA>         <NA>
#>   wmo_id
#> 1   <NA>
#> 2  03772
options(op)
# }
```
