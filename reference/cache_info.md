# Inspect the readnoaa cache

Lists the cached responses currently on disk, with their size and age.
Useful for checking whether a result is being served from a stale copy.

## Usage

``` r
cache_info()
```

## Value

A data frame with columns `file`, `size_kb`, and `age_days`, returned
invisibly if the cache is empty.

## Details

Cached responses expire automatically. Requests whose window ends within
the last five weeks are treated as provisional and expire after one day,
because NCEI publishes recent observations with a lag and continues to
revise them. Older windows are treated as settled and expire after 30
days. Both thresholds are configurable through the options
`readnoaa.cache_days_recent` and `readnoaa.cache_days`, and any single
call can bypass the cache entirely with `refresh = TRUE`.

## See also

Other data access:
[`clear_cache()`](https://charlescoverdale.github.io/readnoaa/reference/clear_cache.md),
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md),
[`list_datatypes()`](https://charlescoverdale.github.io/readnoaa/reference/list_datatypes.md),
[`noaa_get()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_get.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
cache_info()
#>                                     file size_kb age_days
#> 1 bslib-e9b2b13fa612f50d23e4850d93d60d01       4        0
#> 2                                downlit       4        0
options(op)
# }
```
