# List available data types for a dataset

Reports the element codes a station actually records.

## Usage

``` r
list_datatypes(
  dataset,
  station,
  start_date = NULL,
  end_date = NULL,
  cache = TRUE
)
```

## Arguments

- dataset:

  Character. Dataset identifier (e.g. `"daily-summaries"`).

- station:

  Character. A station ID to query.

- start_date, end_date:

  Optional character dates. For the daily datasets these restrict the
  result to elements recorded during the window; for other datasets they
  bound the sample request.

- cache:

  Logical. Use cached data if available (default `TRUE`).

## Value

A character vector of available data type codes.

## Details

For the daily datasets this reads the GHCN-Daily element inventory,
which states exactly which elements a station reports and over what
years. That inventory file is around 36 MB, downloaded on first use and
cached thereafter.

For other datasets, where no such inventory exists, a short sample
request is made and the columns that came back with data are reported.
The sample window is taken from the end of the requested range, or from
the recent past when no range is given.

A station's element list spans its entire history, and stations
routinely stop recording some variables. Supply `start_date` and
`end_date` to see only the elements whose record overlaps the period you
care about.

## See also

[`noaa_coverage()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_coverage.md)
for the years each element spans.

Other data access:
[`cache_info()`](https://charlescoverdale.github.io/readnoaa/reference/cache_info.md),
[`clear_cache()`](https://charlescoverdale.github.io/readnoaa/reference/clear_cache.md),
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md),
[`noaa_get()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_get.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
try({
  # Everything Central Park has ever recorded
  list_datatypes("daily-summaries", "USW00094728")

  # Only what it still records
  list_datatypes("daily-summaries", "USW00094728", start_date = "2025-01-01")
})
#> ℹ Downloading the GHCN-Daily element inventory (~36 MB, cached after first use).
#>  [1] "AWND" "PGTM" "PRCP" "SNOW" "SNWD" "TMAX" "TMIN" "WDF2" "WDF5" "WSF2"
#> [11] "WSF5" "WT01" "WT02" "WT03" "WT04" "WT06" "WT08" "WT09"
options(op)
# }
```
