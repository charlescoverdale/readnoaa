# Fetch any NCEI dataset

A generic fetcher for direct access to any NCEI dataset. Use
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md)
to see common dataset identifiers and the arguments each one requires.

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
  drop_empty = is.null(datatypes),
  cache = TRUE,
  refresh = FALSE
)
```

## Arguments

- dataset:

  Character. The dataset identifier (e.g. `"daily-summaries"`,
  `"global-summary-of-the-month"`).

- station:

  Optional character vector of station IDs. Note that station
  identifiers are dataset-specific: the daily datasets use GHCN-Daily
  IDs such as `"USW00094728"`, while `global-hourly` and
  `global-summary-of-the-day` use ISD IDs such as `"72505394728"`.

- start_date:

  Optional start date in `"YYYY-MM-DD"` or `"YYYY-MM"` format.

- end_date:

  Optional end date in the same format.

- datatypes:

  Optional character vector of data type codes.

- bbox:

  Optional numeric vector of length 4 defining a bounding box:
  `c(south_lat, west_lon, north_lat, east_lon)`. Required by
  `global-marine`.

- units:

  Character. `"metric"` (default) or `"standard"`. Ignored by the
  normals datasets, which are published in US customary units.

- include_flags:

  Logical. Include data quality flags from NCEI (default `FALSE`).

- include_location:

  Logical. Include station latitude, longitude, and elevation columns
  (default `FALSE`).

- drop_empty:

  Logical. Drop columns that contain no data at all. Defaults to `TRUE`
  when `datatypes` is `NULL`.

- cache:

  Logical. Use cached data if available (default `TRUE`).

- refresh:

  Logical. Ignore any cached copy and refetch (default `FALSE`).

## Value

A data frame. Columns vary by dataset. The `date` column is a `Date` for
daily, monthly, and annual datasets, and a `POSIXct` in UTC for the
hourly datasets, which publish ISO 8601 timestamps.

## See also

Other data access:
[`cache_info()`](https://charlescoverdale.github.io/readnoaa/reference/cache_info.md),
[`clear_cache()`](https://charlescoverdale.github.io/readnoaa/reference/clear_cache.md),
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md),
[`list_datatypes()`](https://charlescoverdale.github.io/readnoaa/reference/list_datatypes.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
try({
  # Fetch daily data using the generic function
  noaa_get("daily-summaries", station = "USW00094728",
  start_date = "2024-01-01", end_date = "2024-01-31")
})
#> ℹ Fetching daily-summaries data
#> ✔ Fetching daily-summaries data [562ms]
#> 
#>        station                        name       date  adpt   aslp   astp awbt
#> 1  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01  -1.1 1016.6 1011.5  2.8
#> 2  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-02  -6.1 1017.6 1012.5 -0.6
#> 3  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-03  -4.4 1015.9 1010.8  0.6
#> 4  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-04  -6.1 1015.9 1011.2  0.0
#> 5  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-05 -10.0 1024.0 1019.0 -3.3
#> 6  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-06  -3.9 1016.9 1013.5 -0.6
#> 7  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-07  -0.6 1005.4 1000.3  1.7
#> 8  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-08  -5.0 1026.1 1019.6  1.1
#> 9  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-09   2.8 1015.9 1015.2  5.6
#> 10 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-10   1.7  992.9  985.4  6.1
#> 11 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-11  -3.3 1010.5 1004.1  2.8
#> 12 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-12  -0.6 1017.6 1011.5  3.9
#> 13 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-13   2.2  995.3  990.2  6.7
#> 14 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-14 -11.1 1012.5 1007.5 -2.2
#> 15 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-15 -14.4 1023.0 1017.6 -6.1
#> 16 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-16  -6.1 1011.2 1006.4 -3.3
#> 17 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-17 -16.1 1015.2 1010.2 -8.3
#> 18 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-18 -13.3 1019.6 1014.9 -5.0
#> 19 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-19  -7.8 1010.5 1004.1 -3.3
#> 20 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-20 -15.0 1014.9 1009.8 -8.3
#> 21 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-21 -13.9 1026.8 1020.0 -6.7
#> 22 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-22 -10.6 1032.8 1027.8 -3.9
#> 23 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-23  -4.4 1032.2 1027.1  0.6
#> 24 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-24   3.3 1030.1 1024.7  5.0
#> 25 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-25   9.4 1020.7 1015.6 10.6
#> 26 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-26   4.4 1017.9 1013.2  5.6
#> 27 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-27   3.3 1022.0 1016.9  5.6
#> 28 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-28   2.2 1009.5 1005.4  3.3
#> 29 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-29  -1.1 1010.8 1004.7  1.7
#> 30 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-30  -3.9 1022.0 1016.6  0.0
#> 31 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-31  -1.7 1019.6 1014.9  1.1
#>    awnd prcp rhav rhmn rhmx snow snwd tmax tmin wdf2 wdf5 wsf2 wsf5 wt01 wt06
#> 1   1.5  0.8   63   54   82    0    0  8.3  1.7  270  220  4.0  7.2   NA   NA
#> 2   1.8  0.0   54   41   69    0    0  5.6 -1.6  300  320  4.5  7.2   NA   NA
#> 3   2.2  0.0   57   49   67    0    0  6.1  1.1  300  320  4.5  6.7   NA   NA
#> 4   3.4  0.0   50   38   65    0    0  7.2 -2.1  310  300  8.9 13.4   NA   NA
#> 5   3.2  0.0   48   39   55    0    0  2.8 -3.2  300  290  7.2 10.7   NA   NA
#> 6   3.1 10.4   69   54   89    5    0  3.3 -0.5   70   60 10.3 15.7    1   NA
#> 7   3.4  6.1   82   64   93    0    0  3.3  1.1   50   70  6.7 10.7    1   NA
#> 8   2.3  0.0   52   41   65    0    0  7.2  2.2  300   20  8.1 13.4   NA   NA
#> 9   2.9 43.9   76   57   93    0    0 13.9  2.2  150  130 10.3 19.2    1   NA
#> 10  3.8  5.6   57   41   93    0    0 13.9  6.7  240  230  9.8 16.1    1   NA
#> 11  3.1  0.0   49   44   54    0    0  8.3  5.0  240  240  6.7 10.3   NA   NA
#> 12  3.1  2.0   59   39   86    0    0 10.0  4.4   80   20  7.2 14.3    1   NA
#> 13  4.3 20.6   64   37   93    0    0 15.6  1.7  270  280  9.4 17.4    1   NA
#> 14  3.7  0.0   41   21   56    0    0  6.7 -3.2  270  280 11.2 16.5   NA   NA
#> 15  2.3  1.0   44   28   85   10    0 -1.6 -4.9  280   30  5.8 10.7    1   NA
#> 16  4.1  7.1   78   55   89   33   30  0.0 -5.5   40   30  9.4 16.1    1    1
#> 17  3.7  0.0   46   30   62    0   30 -4.3 -8.2  240   10  8.1 12.5   NA   NA
#> 18  2.7  0.0   43   35   58    0   30  1.1 -5.5  230  240  7.2 11.6   NA   NA
#> 19  3.3  1.0   64   41   78   10   30  0.0 -3.2   40   30  9.8 16.5   NA   NA
#> 20  4.8  0.0   50   42   59    0   30 -3.2 -7.7  340   10  9.4 16.1   NA   NA
#> 21  4.1  0.0   45   38   59    0   30 -0.5 -6.6  310  360  9.4 15.7   NA   NA
#> 22  3.2  0.0   47   33   60    0   30  3.3 -3.8  230   20  6.7  9.8   NA   NA
#> 23  2.2  1.3   61   39   76    0   30  4.4  1.1  340   30  7.2 12.5   NA   NA
#> 24   NA  1.3   84   67   90    0    0  8.9  3.3   90   30  5.4 16.5    1   NA
#> 25  1.9  6.1   85   77   93    0    0 15.0  7.8   90   30  5.8 10.3    1   NA
#> 26  2.5  4.8   88   85   93    0    0  7.8  5.6   50   40  5.8 13.4    1   NA
#> 27   NA  0.0   75   63   93    0    0  9.4  6.1   10   30  4.9 16.5    1   NA
#> 28  4.2 20.8   88   76   89    0    0  6.7  2.8   60   50 11.6 19.7    1   NA
#> 29  3.4  1.3   73   65   89    0    0  4.4  2.2   30   40  7.6 15.7    1   NA
#> 30  2.1  0.0   66   57   85    0    0  3.3  1.7   70   70  6.3 11.6    1   NA
#> 31  1.6  0.0   71   65   85    0    0  4.4  1.1   80   80  4.5  8.9    1   NA
#>    wt08 station_info station_name
#> 1    NA                          
#> 2    NA                          
#> 3    NA                          
#> 4    NA                          
#> 5    NA                          
#> 6     1                          
#> 7    NA                          
#> 8     1                          
#> 9    NA                          
#> 10   NA                          
#> 11   NA                          
#> 12   NA                          
#> 13   NA                          
#> 14   NA                          
#> 15   NA                          
#> 16    1                          
#> 17   NA                          
#> 18    1                          
#> 19    1                          
#> 20   NA                          
#> 21   NA                          
#> 22   NA                          
#> 23    1                          
#> 24    1                          
#> 25    1                          
#> 26   NA                          
#> 27   NA                          
#> 28   NA                          
#> 29   NA                          
#> 30    1                          
#> 31    1                          
options(op)
# }
```
