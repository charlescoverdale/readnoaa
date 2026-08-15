# Check what a station records, and for how long

Returns the first and last year of data for each element a station
reports, taken from the GHCN-Daily element inventory. This is the
authoritative answer to two questions the data functions cannot answer
on their own: which variables a station actually measures, and how
current its record is.

## Usage

``` r
noaa_coverage(station, element = NULL, cache = TRUE, refresh = FALSE)
```

## Arguments

- station:

  Character. One or more station IDs.

- element:

  Optional character vector of element codes (e.g. `c("TMAX", "PRCP")`)
  to restrict the result to.

- cache:

  Logical. Use the cached inventory if available (default `TRUE`).

- refresh:

  Logical. Ignore any cached copy and refetch (default `FALSE`).

## Value

A data frame with columns:

- station:

  Character. Station identifier.

- element:

  Character. Element code, e.g. `"TMAX"`.

- first_year:

  Integer. First year with data.

- last_year:

  Integer. Most recent year with data.

- years:

  Integer. Length of the record in years.

## Details

Currency varies widely. United States stations are typically complete to
within a few days, while many international stations lag by months, and
others stopped reporting years ago while remaining in the station list.
Checking coverage first avoids requesting a window a station never
covered and receiving an empty result.

The inventory file is around 36 MB. It is downloaded on first use and
cached locally thereafter.

## See also

Other station discovery:
[`noaa_nearby()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_nearby.md),
[`noaa_stations()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_stations.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
# What does Central Park record, and through when?
noaa_coverage("USW00094728", element = c("TMAX", "TMIN", "PRCP"))
#>       station element first_year last_year years
#> 1 USW00094728    PRCP       1869      2026   158
#> 2 USW00094728    TMAX       1869      2026   158
#> 3 USW00094728    TMIN       1869      2026   158
options(op)
# }
```
