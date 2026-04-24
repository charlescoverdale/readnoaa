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
#> ✔ Fetching daily summaries [333ms]
#> 
#>        station                        name       date tmax tmin
#> 1  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01  8.3  1.7
#> 2  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-02  5.6 -1.6
#> 3  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-03  6.1  1.1
#> 4  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-04  7.2 -2.1
#> 5  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-05  2.8 -3.2
#> 6  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-06  3.3 -0.5
#> 7  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-07  3.3  1.1
#> 8  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-08  7.2  2.2
#> 9  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-09 13.9  2.2
#> 10 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-10 13.9  6.7
#> 11 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-11  8.3  5.0
#> 12 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-12 10.0  4.4
#> 13 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-13 15.6  1.7
#> 14 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-14  6.7 -3.2
#> 15 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-15 -1.6 -4.9
#> 16 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-16  0.0 -5.5
#> 17 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-17 -4.3 -8.2
#> 18 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-18  1.1 -5.5
#> 19 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-19  0.0 -3.2
#> 20 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-20 -3.2 -7.7
#> 21 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-21 -0.5 -6.6
#> 22 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-22  3.3 -3.8
#> 23 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-23  4.4  1.1
#> 24 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-24  8.9  3.3
#> 25 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-25 15.0  7.8
#> 26 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-26  7.8  5.6
#> 27 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-27  9.4  6.1
#> 28 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-28  6.7  2.8
#> 29 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-29  4.4  2.2
#> 30 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-30  3.3  1.7
#> 31 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-31  4.4  1.1
options(op)
# }
```
