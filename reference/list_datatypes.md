# List available data types for a dataset

Queries the NCEI API to discover what data types (variables) are
available for a given dataset and station. This makes a short data
request to identify available columns.

## Usage

``` r
list_datatypes(dataset, station, cache = TRUE)
```

## Arguments

- dataset:

  Character. Dataset identifier (e.g. `"daily-summaries"`).

- station:

  Character. A station ID to query.

- cache:

  Logical. Use cached data if available (default `TRUE`).

## Value

A character vector of available data type codes.

## See also

Other data access:
[`clear_cache()`](https://charlescoverdale.github.io/readnoaa/reference/clear_cache.md),
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md),
[`noaa_get()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_get.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
list_datatypes("daily-summaries", "USW00094728")
#> ℹ Discovering data types for daily-summaries
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■                       
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Discovering data types for daily-summaries
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Discovering data types for daily-summaries
#> Error in noaa_fetch(dataset = dataset, stations = station, start_date = "2024-01-01",     end_date = "2024-01-07", cache = cache): NCEI returned an error page instead of data.
#> ℹ Check that `dataset` ("daily-summaries") and station IDs are valid.
#> ✖ Discovering data types for daily-summaries [1m 40.4s]
#> 
options(op)
# }
```
