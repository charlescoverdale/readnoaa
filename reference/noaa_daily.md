# Daily weather observations

Returns daily weather data from the NCEI Daily Summaries dataset
(GHCN-Daily). Common data types include TMAX (maximum temperature), TMIN
(minimum temperature), PRCP (precipitation), SNOW (snowfall), and SNWD
(snow depth).

## Usage

``` r
noaa_daily(
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

  Character. One or more station IDs (e.g. `"USW00094728"` for Central
  Park, NYC).

- start_date:

  Character. Start date in `"YYYY-MM-DD"` or `"YYYY-MM"` format.

- end_date:

  Character. End date in the same format.

- datatypes:

  Optional character vector of data type codes to retrieve (e.g.
  `c("TMAX", "TMIN")`). If `NULL`, all available types are returned.

- units:

  Character. `"metric"` (default, Celsius/mm) or `"standard"`
  (Fahrenheit/inches).

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

  Date. Observation date.

- name:

  Character. Station name.

- ...:

  Numeric. Data columns vary by station and request (e.g. `tmax`,
  `tmin`, `prcp`).

## Details

Requests spanning more than one year are automatically split into yearly
chunks to avoid API timeouts.

## See also

Other weather data:
[`noaa_annual()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_annual.md),
[`noaa_monthly()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_monthly.md),
[`noaa_normals()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_normals.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
# Daily temperatures for Central Park, NYC
noaa_daily("USW00094728", "2024-01-01", "2024-01-31",
           datatypes = c("TMAX", "TMIN"))
#> ℹ Fetching daily summaries
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■                       
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Fetching daily summaries
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Fetching daily summaries
#> Error in noaa_fetch(dataset = "daily-summaries", stations = station, start_date = ch[1],     end_date = ch[2], datatypes = datatypes, units = units, include_flags = include_flags,     include_location = include_location, cache = cache): NCEI returned an error page instead of data.
#> ℹ Check that `dataset` ("daily-summaries") and station IDs are valid.
#> ✖ Fetching daily summaries [3m 11.4s]
#> 
options(op)
# }
```
