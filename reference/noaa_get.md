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
#> ✔ Fetching daily-summaries data [337ms]
#> 
#>        station                        name       date acmc acmh acsc acsh  adpt
#> 1  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01   NA   NA   NA   NA  -1.1
#> 2  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-02   NA   NA   NA   NA  -6.1
#> 3  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-03   NA   NA   NA   NA  -4.4
#> 4  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-04   NA   NA   NA   NA  -6.1
#> 5  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-05   NA   NA   NA   NA -10.0
#> 6  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-06   NA   NA   NA   NA  -3.9
#> 7  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-07   NA   NA   NA   NA  -0.6
#> 8  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-08   NA   NA   NA   NA  -5.0
#> 9  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-09   NA   NA   NA   NA   2.8
#> 10 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-10   NA   NA   NA   NA   1.7
#> 11 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-11   NA   NA   NA   NA  -3.3
#> 12 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-12   NA   NA   NA   NA  -0.6
#> 13 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-13   NA   NA   NA   NA   2.2
#> 14 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-14   NA   NA   NA   NA -11.1
#> 15 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-15   NA   NA   NA   NA -14.4
#> 16 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-16   NA   NA   NA   NA  -6.1
#> 17 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-17   NA   NA   NA   NA -16.1
#> 18 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-18   NA   NA   NA   NA -13.3
#> 19 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-19   NA   NA   NA   NA  -7.8
#> 20 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-20   NA   NA   NA   NA -15.0
#> 21 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-21   NA   NA   NA   NA -13.9
#> 22 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-22   NA   NA   NA   NA -10.6
#> 23 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-23   NA   NA   NA   NA  -4.4
#> 24 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-24   NA   NA   NA   NA   3.3
#> 25 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-25   NA   NA   NA   NA   9.4
#> 26 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-26   NA   NA   NA   NA   4.4
#> 27 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-27   NA   NA   NA   NA   3.3
#> 28 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-28   NA   NA   NA   NA   2.2
#> 29 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-29   NA   NA   NA   NA  -1.1
#> 30 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-30   NA   NA   NA   NA  -3.9
#> 31 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-31   NA   NA   NA   NA  -1.7
#>      aslp   astp awbt awdr awnd daev dapr dasf datn datx dawm dwpr evap fmtm
#> 1  1016.6 1011.5  2.8   NA  1.5   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2  1017.6 1012.5 -0.6   NA  1.8   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3  1015.9 1010.8  0.6   NA  2.2   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4  1015.9 1011.2  0.0   NA  3.4   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5  1024.0 1019.0 -3.3   NA  3.2   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6  1016.9 1013.5 -0.6   NA  3.1   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7  1005.4 1000.3  1.7   NA  3.4   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8  1026.1 1019.6  1.1   NA  2.3   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9  1015.9 1015.2  5.6   NA  2.9   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10  992.9  985.4  6.1   NA  3.8   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11 1010.5 1004.1  2.8   NA  3.1   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12 1017.6 1011.5  3.9   NA  3.1   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 13  995.3  990.2  6.7   NA  4.3   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 14 1012.5 1007.5 -2.2   NA  3.7   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 15 1023.0 1017.6 -6.1   NA  2.3   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 16 1011.2 1006.4 -3.3   NA  4.1   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 17 1015.2 1010.2 -8.3   NA  3.7   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 18 1019.6 1014.9 -5.0   NA  2.7   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 19 1010.5 1004.1 -3.3   NA  3.3   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 20 1014.9 1009.8 -8.3   NA  4.8   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 21 1026.8 1020.0 -6.7   NA  4.1   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 22 1032.8 1027.8 -3.9   NA  3.2   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 23 1032.2 1027.1  0.6   NA  2.2   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 24 1030.1 1024.7  5.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 25 1020.7 1015.6 10.6   NA  1.9   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 26 1017.9 1013.2  5.6   NA  2.5   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 27 1022.0 1016.9  5.6   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 28 1009.5 1005.4  3.3   NA  4.2   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 29 1010.8 1004.7  1.7   NA  3.4   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 30 1022.0 1016.6  0.0   NA  2.1   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 31 1019.6 1014.9  1.1   NA  1.6   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    frgb frgt frth gaht mdev mdpr mdsf mdtn mdtx mdwm mnpn mxpn pgtm prcp psun
#> 1    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.8   NA
#> 2    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 3    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 4    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 5    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 6    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 10.4   NA
#> 7    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  6.1   NA
#> 8    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 9    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 43.9   NA
#> 10   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  5.6   NA
#> 11   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 12   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  2.0   NA
#> 13   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 20.6   NA
#> 14   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 15   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  1.0   NA
#> 16   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  7.1   NA
#> 17   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 18   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 19   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  1.0   NA
#> 20   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 21   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 22   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 23   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  1.3   NA
#> 24   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  1.3   NA
#> 25   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  6.1   NA
#> 26   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  4.8   NA
#> 27   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 28   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 20.8   NA
#> 29   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  1.3   NA
#> 30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#> 31   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA  0.0   NA
#>    rhav rhmn rhmx sn01 sn02 sn03 sn11 sn12 sn13 sn14 sn21 sn22 sn23 sn31 sn32
#> 1    63   54   82   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2    54   41   69   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3    57   49   67   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4    50   38   65   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5    48   39   55   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6    69   54   89   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7    82   64   93   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8    52   41   65   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9    76   57   93   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10   57   41   93   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11   49   44   54   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12   59   39   86   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 13   64   37   93   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 14   41   21   56   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 15   44   28   85   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 16   78   55   89   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 17   46   30   62   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 18   43   35   58   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 19   64   41   78   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 20   50   42   59   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 21   45   38   59   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 22   47   33   60   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 23   61   39   76   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 24   84   67   90   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 25   85   77   93   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 26   88   85   93   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 27   75   63   93   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 28   88   76   89   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 29   73   65   89   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 30   66   57   85   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 31   71   65   85   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    sn33 sn34 sn35 sn36 sn51 sn52 sn53 sn54 sn55 sn56 sn57 sn61 sn72 sn81 sn82
#> 1    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 13   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 14   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 15   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 16   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 17   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 18   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 19   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 20   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 21   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 22   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 23   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 24   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 25   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 26   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 27   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 28   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 29   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 31   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    sn83 snow snwd sx01 sx02 sx03 sx11 sx12 sx13 sx14 sx15 sx17 sx21 sx22 sx23
#> 1    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6    NA    5    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9    NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 13   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 14   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 15   NA   10    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 16   NA   33   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 17   NA    0   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 18   NA    0   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 19   NA   10   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 20   NA    0   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 21   NA    0   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 22   NA    0   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 23   NA    0   30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 24   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 25   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 26   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 27   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 28   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 29   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 30   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 31   NA    0    0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    sx31 sx32 sx33 sx34 sx35 sx36 sx51 sx52 sx53 sx54 sx55 sx56 sx57 sx61 sx72
#> 1    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 13   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 14   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 15   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 16   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 17   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 18   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 19   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 20   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 21   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 22   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 23   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 24   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 25   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 26   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 27   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 28   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 29   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 30   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 31   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    sx81 sx82 sx83 tavg taxn thic tmax tmin tobs tsun wdf1 wdf2 wdf5 wdfg wdfi
#> 1    NA   NA   NA   NA   NA   NA  8.3  1.7   NA   NA   NA  270  220   NA   NA
#> 2    NA   NA   NA   NA   NA   NA  5.6 -1.6   NA   NA   NA  300  320   NA   NA
#> 3    NA   NA   NA   NA   NA   NA  6.1  1.1   NA   NA   NA  300  320   NA   NA
#> 4    NA   NA   NA   NA   NA   NA  7.2 -2.1   NA   NA   NA  310  300   NA   NA
#> 5    NA   NA   NA   NA   NA   NA  2.8 -3.2   NA   NA   NA  300  290   NA   NA
#> 6    NA   NA   NA   NA   NA   NA  3.3 -0.5   NA   NA   NA   70   60   NA   NA
#> 7    NA   NA   NA   NA   NA   NA  3.3  1.1   NA   NA   NA   50   70   NA   NA
#> 8    NA   NA   NA   NA   NA   NA  7.2  2.2   NA   NA   NA  300   20   NA   NA
#> 9    NA   NA   NA   NA   NA   NA 13.9  2.2   NA   NA   NA  150  130   NA   NA
#> 10   NA   NA   NA   NA   NA   NA 13.9  6.7   NA   NA   NA  240  230   NA   NA
#> 11   NA   NA   NA   NA   NA   NA  8.3  5.0   NA   NA   NA  240  240   NA   NA
#> 12   NA   NA   NA   NA   NA   NA 10.0  4.4   NA   NA   NA   80   20   NA   NA
#> 13   NA   NA   NA   NA   NA   NA 15.6  1.7   NA   NA   NA  270  280   NA   NA
#> 14   NA   NA   NA   NA   NA   NA  6.7 -3.2   NA   NA   NA  270  280   NA   NA
#> 15   NA   NA   NA   NA   NA   NA -1.6 -4.9   NA   NA   NA  280   30   NA   NA
#> 16   NA   NA   NA   NA   NA   NA  0.0 -5.5   NA   NA   NA   40   30   NA   NA
#> 17   NA   NA   NA   NA   NA   NA -4.3 -8.2   NA   NA   NA  240   10   NA   NA
#> 18   NA   NA   NA   NA   NA   NA  1.1 -5.5   NA   NA   NA  230  240   NA   NA
#> 19   NA   NA   NA   NA   NA   NA  0.0 -3.2   NA   NA   NA   40   30   NA   NA
#> 20   NA   NA   NA   NA   NA   NA -3.2 -7.7   NA   NA   NA  340   10   NA   NA
#> 21   NA   NA   NA   NA   NA   NA -0.5 -6.6   NA   NA   NA  310  360   NA   NA
#> 22   NA   NA   NA   NA   NA   NA  3.3 -3.8   NA   NA   NA  230   20   NA   NA
#> 23   NA   NA   NA   NA   NA   NA  4.4  1.1   NA   NA   NA  340   30   NA   NA
#> 24   NA   NA   NA   NA   NA   NA  8.9  3.3   NA   NA   NA   90   30   NA   NA
#> 25   NA   NA   NA   NA   NA   NA 15.0  7.8   NA   NA   NA   90   30   NA   NA
#> 26   NA   NA   NA   NA   NA   NA  7.8  5.6   NA   NA   NA   50   40   NA   NA
#> 27   NA   NA   NA   NA   NA   NA  9.4  6.1   NA   NA   NA   10   30   NA   NA
#> 28   NA   NA   NA   NA   NA   NA  6.7  2.8   NA   NA   NA   60   50   NA   NA
#> 29   NA   NA   NA   NA   NA   NA  4.4  2.2   NA   NA   NA   30   40   NA   NA
#> 30   NA   NA   NA   NA   NA   NA  3.3  1.7   NA   NA   NA   70   70   NA   NA
#> 31   NA   NA   NA   NA   NA   NA  4.4  1.1   NA   NA   NA   80   80   NA   NA
#>    wdfm wdmv wesd wesf wsf1 wsf2 wsf5 wsfg wsfi wsfm wt01 wt02 wt03 wt04 wt05
#> 1    NA   NA   NA   NA   NA  4.0  7.2   NA   NA   NA   NA   NA   NA   NA   NA
#> 2    NA   NA   NA   NA   NA  4.5  7.2   NA   NA   NA   NA   NA   NA   NA   NA
#> 3    NA   NA   NA   NA   NA  4.5  6.7   NA   NA   NA   NA   NA   NA   NA   NA
#> 4    NA   NA   NA   NA   NA  8.9 13.4   NA   NA   NA   NA   NA   NA   NA   NA
#> 5    NA   NA   NA   NA   NA  7.2 10.7   NA   NA   NA   NA   NA   NA   NA   NA
#> 6    NA   NA   NA   NA   NA 10.3 15.7   NA   NA   NA    1   NA   NA   NA   NA
#> 7    NA   NA   NA   NA   NA  6.7 10.7   NA   NA   NA    1   NA   NA   NA   NA
#> 8    NA   NA   NA   NA   NA  8.1 13.4   NA   NA   NA   NA   NA   NA   NA   NA
#> 9    NA   NA   NA   NA   NA 10.3 19.2   NA   NA   NA    1   NA   NA   NA   NA
#> 10   NA   NA   NA   NA   NA  9.8 16.1   NA   NA   NA    1   NA   NA   NA   NA
#> 11   NA   NA   NA   NA   NA  6.7 10.3   NA   NA   NA   NA   NA   NA   NA   NA
#> 12   NA   NA   NA   NA   NA  7.2 14.3   NA   NA   NA    1   NA   NA   NA   NA
#> 13   NA   NA   NA   NA   NA  9.4 17.4   NA   NA   NA    1   NA   NA   NA   NA
#> 14   NA   NA   NA   NA   NA 11.2 16.5   NA   NA   NA   NA   NA   NA   NA   NA
#> 15   NA   NA   NA   NA   NA  5.8 10.7   NA   NA   NA    1   NA   NA   NA   NA
#> 16   NA   NA   NA   NA   NA  9.4 16.1   NA   NA   NA    1   NA   NA   NA   NA
#> 17   NA   NA   NA   NA   NA  8.1 12.5   NA   NA   NA   NA   NA   NA   NA   NA
#> 18   NA   NA   NA   NA   NA  7.2 11.6   NA   NA   NA   NA   NA   NA   NA   NA
#> 19   NA   NA   NA   NA   NA  9.8 16.5   NA   NA   NA   NA   NA   NA   NA   NA
#> 20   NA   NA   NA   NA   NA  9.4 16.1   NA   NA   NA   NA   NA   NA   NA   NA
#> 21   NA   NA   NA   NA   NA  9.4 15.7   NA   NA   NA   NA   NA   NA   NA   NA
#> 22   NA   NA   NA   NA   NA  6.7  9.8   NA   NA   NA   NA   NA   NA   NA   NA
#> 23   NA   NA   NA   NA   NA  7.2 12.5   NA   NA   NA   NA   NA   NA   NA   NA
#> 24   NA   NA   NA   NA   NA  5.4 16.5   NA   NA   NA    1   NA   NA   NA   NA
#> 25   NA   NA   NA   NA   NA  5.8 10.3   NA   NA   NA    1   NA   NA   NA   NA
#> 26   NA   NA   NA   NA   NA  5.8 13.4   NA   NA   NA    1   NA   NA   NA   NA
#> 27   NA   NA   NA   NA   NA  4.9 16.5   NA   NA   NA    1   NA   NA   NA   NA
#> 28   NA   NA   NA   NA   NA 11.6 19.7   NA   NA   NA    1   NA   NA   NA   NA
#> 29   NA   NA   NA   NA   NA  7.6 15.7   NA   NA   NA    1   NA   NA   NA   NA
#> 30   NA   NA   NA   NA   NA  6.3 11.6   NA   NA   NA    1   NA   NA   NA   NA
#> 31   NA   NA   NA   NA   NA  4.5  8.9   NA   NA   NA    1   NA   NA   NA   NA
#>    wt06 wt07 wt08 wt09 wt10 wt11 wt12 wt13 wt14 wt15 wt16 wt17 wt18 wt19 wt21
#> 1    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6    NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8    NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9    NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 13   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 14   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 15   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 16    1   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 17   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 18   NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 19   NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 20   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 21   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 22   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 23   NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 24   NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 25   NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 26   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 27   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 28   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 29   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 30   NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 31   NA   NA    1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    wt22 wv01 wv03 wv07 wv18 wv20 alt station_info station_name time
#> 1    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 2    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 3    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 4    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 5    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 6    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 7    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 8    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 9    NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 10   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 11   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 12   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 13   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 14   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 15   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 16   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 17   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 18   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 19   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 20   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 21   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 22   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 23   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 24   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 25   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 26   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 27   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 28   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 29   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 30   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
#> 31   NA   NA   NA   NA   NA   NA  NA           NA           NA   NA
options(op)
# }
```
