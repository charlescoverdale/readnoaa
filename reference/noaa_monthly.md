# Monthly weather summaries

Returns monthly summary data from the NCEI Global Summary of the Month
dataset.

## Usage

``` r
noaa_monthly(
  station,
  start_date,
  end_date,
  datatypes = NULL,
  units = "metric",
  include_flags = FALSE,
  include_location = FALSE,
  drop_empty = is.null(datatypes),
  cache = TRUE,
  refresh = FALSE
)
```

## Arguments

- station:

  Character. One or more station IDs.

- start_date:

  Character. Start date in `"YYYY-MM-DD"` or `"YYYY-MM"` format.

- end_date:

  Character. End date in the same format.

- datatypes:

  Optional character vector of data type codes.

- units:

  Character. `"metric"` (default) or `"standard"`.

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

A data frame with columns including:

- station:

  Character. Station identifier.

- date:

  Date. First day of the month.

- name:

  Character. Station name.

- ...:

  Numeric. Data columns vary by station and request.

## See also

Other weather data:
[`noaa_annual()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_annual.md),
[`noaa_daily()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_daily.md),
[`noaa_normals()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_normals.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
noaa_monthly("USW00094728", "2024-01", "2024-12")
#> ℹ Fetching monthly summaries
#> ✔ Fetching monthly summaries [263ms]
#> 
#>        station                        name       date adpt   aslp   astp awbt
#> 1  USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01 -4.2 1016.8 1011.7  0.0
#> 2  USW00094728 NY CITY CENTRAL PARK, NY US 2024-02-01 -4.4 1015.4 1010.4  0.1
#> 3  USW00094728 NY CITY CENTRAL PARK, NY US 2024-03-01 -0.9 1015.0 1010.0  0.5
#> 4  USW00094728 NY CITY CENTRAL PARK, NY US 2024-04-01  2.8 1014.6 1009.7  0.8
#> 5  USW00094728 NY CITY CENTRAL PARK, NY US 2024-05-01 11.3 1013.2 1008.4  1.4
#> 6  USW00094728 NY CITY CENTRAL PARK, NY US 2024-06-01 15.4 1013.8 1009.0  1.9
#> 7  USW00094728 NY CITY CENTRAL PARK, NY US 2024-07-01 18.4 1015.6 1010.8  2.1
#> 8  USW00094728 NY CITY CENTRAL PARK, NY US 2024-08-01 16.6 1016.3 1011.4  1.9
#> 9  USW00094728 NY CITY CENTRAL PARK, NY US 2024-09-01 12.9 1019.4 1014.6  1.6
#> 10 USW00094728 NY CITY CENTRAL PARK, NY US 2024-10-01  5.9 1019.4 1014.5  1.1
#> 11 USW00094728 NY CITY CENTRAL PARK, NY US 2024-11-01  0.7 1015.1 1010.0  0.7
#> 12 USW00094728 NY CITY CENTRAL PARK, NY US 2024-12-01 -4.6 1022.0 1016.7  0.0
#>    awnd  cdsd  cldd dp01 dp10 dp1x dsnd dsnw dt00 dt32 dx32 dx70 dx90 dyfg dyhf
#> 1   3.0   0.0   0.0   16    9    1    8    1    0   13    6    0    0   16   NA
#> 2   2.6   0.0   0.0    8    5    0    3    2    0   14    0    0    0    7    1
#> 3   2.9   0.0   0.0   12    7    4    0    0    0    4    0    2    0   10    1
#> 4   2.6  10.0  10.0   14    6    1    0    0    0    0    0    8    0   10   NA
#> 5   1.8  57.5  47.5   13   10    0    0    0    0    0    0   21    0   19    2
#> 6   1.6 224.8 167.3    7    5    0    0    0    0    0    0   30    6   10    2
#> 7   1.4 477.1 252.3   12    6    2    0    0    0    0    0   31    9   15    4
#> 8   1.7 651.1 174.0   12   10    2    0    0    0    0    0   31    6   13    3
#> 9   2.0 720.4  69.3    6    4    0    0    0    0    0    0   24    0    8   NA
#> 10  1.7 735.7  15.3    1    0    0    0    0    0    0    0   13    0    1   NA
#> 11  2.4 741.3   5.6    7    5    1    0    0    0    1    0    4    0    7   NA
#> 12  2.5 741.3   0.0   17   11    0    7    2    0   18    2    0    0   14    2
#>        dynt     dysd     dysn dyts     dyxp     dyxt  emnt emsd emsn emxp emxt
#> 1  20240117 20240123 20240116   NA 20240109 20240113  -8.2   30   33 43.9 15.6
#> 2  20240225 20240217 20240213   NA 20240213 20240228  -4.9   50   81 19.6 16.7
#> 3  20240322 20240331 20240311   NA 20240323 20240314  -1.6    0    0 93.0 23.3
#> 4  20240404 20240430 20240430    2 20240403 20240429   2.8    0    0 39.4 30.6
#> 5  20240511 20240531 20240531    3 20240527 20240524   8.3    0    0 24.4 28.9
#> 6  20240611 20240630 20240630    6 20240606 20240621  15.0    0    0 19.6 34.4
#> 7  20240701 20240731 20240731    6 20240713 20240708  17.8    0    0 52.3 35.0
#> 8  20240821 20240831 20240831    6 20240818 20240801  13.9    0    0 58.2 35.0
#> 9  20240909 20240930 20240930   NA 20240929 20240919  12.8    0    0 19.8 28.9
#> 10 20241017 20241031 20241031   NA 20241029 20241031   6.1    0    0  0.3 27.2
#> 11 20241130 20241130 20241130   NA 20241121 20241106  -1.0    0    0 39.9 26.7
#> 12 20241223 20241221 20241221    1 20241216 20241229 -10.5   50   46 23.1 15.6
#>      hdsd  htdd  prcp rhav rhmn rhmx snow tavg tmax tmin wdf2 wdf5 wsf2 wsf5
#> 1  1262.2 481.8 134.1   62   49   78   58  2.8  5.5  0.1   60   50 11.6 19.7
#> 2  1663.5 401.3  52.1   55   40   72  132  4.5  7.9  1.1  280  290 12.5 21.9
#> 3  1953.6 290.1 230.3   55   38   73    0  9.0 13.2  4.8  310  290 11.6 23.7
#> 4  2119.9 166.3  88.3   56   38   74    0 13.1 17.7  8.6   60   40 14.8 26.4
#> 5  2168.1  48.2 104.4   68   50   88    0 18.3 22.5 14.1   60   70  8.1 14.8
#> 6  2168.1   0.0  43.4   62   44   82    0 23.9 28.3 19.5  290  290  9.4 20.6
#> 7     0.0   0.0 106.7   64   47   82    0 26.5 30.7 22.3  300  200  6.7 13.0
#> 8     0.0   0.0 178.2   67   49   83    0 23.9 28.1 19.8   60  200  7.2 14.3
#> 9     5.8   5.8  40.1   65   46   81    0 20.4 24.3 16.6   60   60  7.6 11.6
#> 10   91.2  85.4   0.3   53   36   72    0 16.1 20.4 11.7  280  280  8.1 15.7
#> 11  323.1 231.9  85.0   52   36   68    0 10.8 14.6  7.0  290  280  9.4 17.4
#> 12  782.9 459.8 115.1   59   44   74   71  3.5  6.4  0.6  240  280 10.3 19.7
options(op)
# }
```
