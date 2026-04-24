# List common NCEI datasets

Returns a curated table of the most commonly used NCEI datasets. No
network call is made.

## Usage

``` r
list_datasets()
```

## Value

A data frame with columns:

- dataset:

  Character. Dataset identifier for use with
  [`noaa_get()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_get.md).

- description:

  Character. Brief description.

- frequency:

  Character. Temporal resolution.

## See also

Other data access:
[`clear_cache()`](https://charlescoverdale.github.io/readnoaa/reference/clear_cache.md),
[`list_datatypes()`](https://charlescoverdale.github.io/readnoaa/reference/list_datatypes.md),
[`noaa_get()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_get.md)

## Examples

``` r
list_datasets()
#>                             dataset
#> 1                   daily-summaries
#> 2       global-summary-of-the-month
#> 3        global-summary-of-the-year
#> 4           normals-daily-1991-2020
#> 5         normals-monthly-1991-2020
#> 6  normals-annualseasonal-1991-2020
#> 7          normals-hourly-1991-2020
#> 8                     global-hourly
#> 9         global-summary-of-the-day
#> 10                    global-marine
#> 11        local-climatological-data
#> 12        coop-hourly-precipitation
#> 13  noaa-global-surface-temperature
#>                                                  description
#> 1  Daily weather observations (TMAX, TMIN, PRCP, SNOW, etc.)
#> 2                               Monthly aggregated summaries
#> 3                                Annual aggregated summaries
#> 4                  30-year daily climate normals (1991-2020)
#> 5                30-year monthly climate normals (1991-2020)
#> 6        30-year annual/seasonal climate normals (1991-2020)
#> 7                 30-year hourly climate normals (1991-2020)
#> 8                          Hourly weather observations (ISD)
#> 9                Daily summary of global observations (GSOD)
#> 10                               Marine surface observations
#> 11        Local climatological data (hourly, daily, monthly)
#> 12                 Cooperative observer hourly precipitation
#> 13     Global surface temperature anomalies (NOAAGlobalTemp)
#>               frequency
#> 1                 Daily
#> 2               Monthly
#> 3                Annual
#> 4                 Daily
#> 5               Monthly
#> 6                Annual
#> 7                Hourly
#> 8                Hourly
#> 9                 Daily
#> 10             Variable
#> 11 Hourly/Daily/Monthly
#> 12               Hourly
#> 13              Monthly
```
