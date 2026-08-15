# Monthly weather summaries

Returns monthly summary data from the NCEI Global Summary of the Month
dataset.

## Usage

``` r
noaa_monthly(
  station,
  start_date,
  end_date,
  datatypes = NULL,
  units = "metric",
  include_flags = FALSE,
  include_location = FALSE,
  cache = TRUE
)
```

## Arguments

- station:

  Character. One or more station IDs.

- start_date:

  Character. Start date in `"YYYY-MM-DD"` or `"YYYY-MM"` format.

- end_date:

  Character. End date in the same format.

- datatypes:

  Optional character vector of data type codes.

- units:

  Character. `"metric"` (default) or `"standard"`.

- include_flags:

  Logical. Include data quality flags from NCEI (default `FALSE`).

- include_location:

  Logical. Include station latitude, longitude, and elevation columns
  (default `FALSE`).

- cache:

  Logical. Use cached data if available (default `TRUE`).

## Value

A data frame with columns including:

- station:

  Character. Station identifier.

- date:

  Date. First day of the month.

- name:

  Character. Station name.

- ...:

  Numeric. Data columns vary by station and request.

## See also

Other weather data:
[`noaa_annual()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_annual.md),
[`noaa_daily()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_daily.md),
[`noaa_normals()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_normals.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
noaa_monthly("USW00094728", "2024-01", "2024-12")
#> ℹ Fetching monthly summaries
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Fetching monthly summaries
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■                       
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Fetching monthly summaries
#> Error in noaa_fetch(dataset = "global-summary-of-the-month", stations = station,     start_date = start_date, end_date = end_date, datatypes = datatypes,     units = units, include_flags = include_flags, include_location = include_location,     cache = cache): NCEI returned an error page instead of data.
#> ℹ Check that `dataset` ("global-summary-of-the-month") and station IDs are
#>   valid.
#> ✖ Fetching monthly summaries [1m 40.3s]
#> 
options(op)
# }
```
