# Fetch any NCEI dataset

A generic fetcher for direct access to any NCEI dataset. Use
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md)
to see common dataset identifiers.

## Usage

``` r
noaa_get(
  dataset,
  station = NULL,
  start_date = NULL,
  end_date = NULL,
  datatypes = NULL,
  bbox = NULL,
  units = "metric",
  include_flags = FALSE,
  include_location = FALSE,
  cache = TRUE
)
```

## Arguments

- dataset:

  Character. The dataset identifier (e.g. `"daily-summaries"`,
  `"global-summary-of-the-month"`).

- station:

  Optional character vector of station IDs.

- start_date:

  Optional start date in `"YYYY-MM-DD"` or `"YYYY-MM"` format.

- end_date:

  Optional end date in the same format.

- datatypes:

  Optional character vector of data type codes.

- bbox:

  Optional numeric vector of length 4 defining a bounding box:
  `c(south_lat, west_lon, north_lat, east_lon)`.

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

A data frame. Columns vary by dataset.

## See also

Other data access:
[`clear_cache()`](https://charlescoverdale.github.io/readnoaa/reference/clear_cache.md),
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md),
[`list_datatypes()`](https://charlescoverdale.github.io/readnoaa/reference/list_datatypes.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
# Fetch daily data using the generic function
noaa_get("daily-summaries", station = "USW00094728",
         start_date = "2024-01-01", end_date = "2024-01-31")
#> ℹ Fetching daily-summaries data
#> Waiting 5s for retry backoff ■■■■■■                          
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ℹ Fetching daily-summaries data
#> Error in noaa_fetch(dataset = dataset, stations = station, start_date = start_date,     end_date = end_date, datatypes = datatypes, units = units,     bbox = bbox, include_flags = include_flags, include_location = include_location,     cache = cache): NCEI returned an error page instead of data.
#> ℹ Check that `dataset` ("daily-summaries") and station IDs are valid.
#> ✖ Fetching daily-summaries data [4m 43.2s]
#> 
options(op)
# }
```
