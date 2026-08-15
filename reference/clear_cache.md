# Clear the readnoaa cache

Deletes all locally cached NOAA data files. The next call to any data
function will re-download from the NCEI API.

## Usage

``` r
clear_cache()
```

## Value

Invisible `NULL`.

## See also

[`cache_info()`](https://charlescoverdale.github.io/readnoaa/reference/cache_info.md)
to inspect the cache before clearing it.

Other data access:
[`cache_info()`](https://charlescoverdale.github.io/readnoaa/reference/cache_info.md),
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md),
[`list_datatypes()`](https://charlescoverdale.github.io/readnoaa/reference/list_datatypes.md),
[`noaa_get()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_get.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
clear_cache()
#> ✔ Cache cleared.
options(op)
# }
```
