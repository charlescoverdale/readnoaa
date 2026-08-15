# Climate normals (1991-2020)

Returns 30-year climate normals from the NCEI Normals dataset. Normals
represent the average climate conditions over the 1991-2020 period.

## Usage

``` r
noaa_normals(
  station,
  period = "monthly",
  datatypes = NULL,
  include_flags = FALSE,
  include_location = FALSE,
  cache = TRUE
)
```

## Arguments

- station:

  Character. One or more station IDs.

- period:

  Character. One of `"monthly"`, `"daily"`, or `"annual"`.

- datatypes:

  Optional character vector of data type codes.

- include_flags:

  Logical. Include data quality flags from NCEI (default `FALSE`).

- include_location:

  Logical. Include station latitude, longitude, and elevation columns
  (default `FALSE`).

- cache:

  Logical. Use cached data if available (default `TRUE`).

## Value

A data frame. Columns vary by period but typically include station, date
or month, and normal values for temperature, precipitation, and other
variables.

## See also

Other weather data:
[`noaa_annual()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_annual.md),
[`noaa_daily()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_daily.md),
[`noaa_monthly()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_monthly.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
noaa_normals("USW00094728", "monthly")
#> ℹ Fetching monthly climate normals
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Fetching monthly climate normals
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■                       
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Fetching monthly climate normals
#> Error in noaa_fetch(dataset = dataset, stations = station, datatypes = datatypes,     include_flags = include_flags, include_location = include_location,     cache = cache): NCEI returned an error page instead of data.
#> ℹ Check that `dataset` ("normals-monthly-1991-2020") and station IDs are valid.
#> ✖ Fetching monthly climate normals [1m 40.4s]
#> 
options(op)
# }
```
