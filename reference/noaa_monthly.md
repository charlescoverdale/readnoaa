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
  cache = TRUE
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

- cache:

  Logical. Use cached data if available (default `TRUE`).

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
#> ✔ Fetching monthly summaries [163ms]
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
#>    awnd  cdsd  cldd dp01 dp05 dp10 dp1x dsnd dsnw dt00 dt32 dx32 dx70 dx90 dyfg
#> 1   3.0   0.0   0.0   16   NA    9    1    8    1    0   13    6    0    0   16
#> 2   2.6   0.0   0.0    8   NA    5    0    3    2    0   14    0    0    0    7
#> 3   2.9   0.0   0.0   12   NA    7    4    0    0    0    4    0    2    0   10
#> 4   2.6  10.0  10.0   14   NA    6    1    0    0    0    0    0    8    0   10
#> 5   1.8  57.5  47.5   13   NA   10    0    0    0    0    0    0   21    0   19
#> 6   1.6 224.8 167.3    7   NA    5    0    0    0    0    0    0   30    6   10
#> 7   1.4 477.1 252.3   12   NA    6    2    0    0    0    0    0   31    9   15
#> 8   1.7 651.1 174.0   12   NA   10    2    0    0    0    0    0   31    6   13
#> 9   2.0 720.4  69.3    6   NA    4    0    0    0    0    0    0   24    0    8
#> 10  1.7 735.7  15.3    1   NA    0    0    0    0    0    0    0   13    0    1
#> 11  2.4 741.3   5.6    7   NA    5    1    0    0    0    1    0    4    0    7
#> 12  2.5 741.3   0.0   17   NA   11    0    7    2    0   18    2    0    0    5
#>    dyhf     dynt     dysd     dysn dyts     dyxp     dyxt  emnt emsd emsn emxp
#> 1    NA 20240117 20240123 20240116   NA 20240109 20240113  -8.2   30   33 43.9
#> 2     1 20240225 20240217 20240213   NA 20240213 20240228  -4.9   50   81 19.6
#> 3     1 20240322 20240331 20240311   NA 20240323 20240314  -1.6    0    0 93.0
#> 4    NA 20240404 20240430 20240430    2 20240403 20240429   2.8    0    0 39.4
#> 5     2 20240511 20240531 20240531    3 20240527 20240524   8.3    0    0 24.4
#> 6     2 20240611 20240630 20240630    6 20240606 20240621  15.0    0    0 19.6
#> 7     4 20240701 20240731 20240731    6 20240713 20240708  17.8    0    0 52.3
#> 8     3 20240821 20240831 20240831    6 20240818 20240801  13.9    0    0 58.2
#> 9    NA 20240909 20240930 20240930   NA 20240929 20240919  12.8    0    0 19.8
#> 10   NA 20241017 20241031 20241031   NA 20241029 20241031   6.1    0    0  0.3
#> 11   NA 20241130 20241130 20241130   NA 20241121 20241106  -1.0    0    0 39.9
#> 12   NA 20241223 20241221 20241221   NA 20241216 20241229 -10.5   50   46 23.1
#>    emxt evap   hdsd hn01 hn02 hn03 hn04 hn05 hn06 hn07 hn08 hn09 hn10 hn11 hn12
#> 1  15.6   NA 1262.2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2  16.7   NA 1663.5   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3  23.3   NA 1953.6   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4  30.6   NA 2119.9   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5  28.9   NA 2168.1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6  34.4   NA 2168.1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7  35.0   NA    0.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8  35.0   NA    0.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9  28.9   NA    5.8   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10 27.2   NA   91.2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11 26.7   NA  323.1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12 15.6   NA  782.9   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    hn13 hn14 hn15  htdd hx01 hx02 hx03 hx04 hx05 hx06 hx07 hx08 hx09 hx10 hx11
#> 1    NA   NA   NA 481.8   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2    NA   NA   NA 401.3   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3    NA   NA   NA 290.1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4    NA   NA   NA 166.3   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5    NA   NA   NA  48.2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 6    NA   NA   NA   0.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 7    NA   NA   NA   0.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 8    NA   NA   NA   0.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 9    NA   NA   NA   5.8   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 10   NA   NA   NA  85.4   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 11   NA   NA   NA 231.9   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 12   NA   NA   NA 459.8   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>    hx12 hx13 hx14 hx15 ln01 ln02 ln03 ln04 ln05 ln06 ln07 ln08 ln09 ln10 ln11
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
#>    ln12 ln13 ln14 ln15 lx01 lx02 lx03 lx04 lx05 lx06 lx07 lx08 lx09 lx10 lx11
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
#>    lx12 lx13 lx14 lx15 mn01 mn02 mn03 mn04 mn05 mn06 mn07 mn08 mn09 mn10 mn11
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
#>    mn12 mn13 mn14 mn15 mnpn mx01 mx02 mx03 mx04 mx05 mx06 mx07 mx08 mx09 mx10
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
#>    mx11 mx12 mx13 mx14 mx15 mxpn  prcp psun rhav rhmn rhmx snow tavg time tmax
#> 1    NA   NA   NA   NA   NA   NA 134.1   NA   62   49   78   58  2.8   NA  5.5
#> 2    NA   NA   NA   NA   NA   NA  52.1   NA   55   40   72  132  4.5   NA  7.9
#> 3    NA   NA   NA   NA   NA   NA 230.3   NA   55   38   73    0  9.0   NA 13.2
#> 4    NA   NA   NA   NA   NA   NA  88.3   NA   56   38   74    0 13.1   NA 17.7
#> 5    NA   NA   NA   NA   NA   NA 104.4   NA   68   50   88    0 18.3   NA 22.5
#> 6    NA   NA   NA   NA   NA   NA  43.4   NA   62   44   82    0 23.9   NA 28.3
#> 7    NA   NA   NA   NA   NA   NA 106.7   NA   64   47   82    0 26.5   NA 30.7
#> 8    NA   NA   NA   NA   NA   NA 178.2   NA   67   49   83    0 23.9   NA 28.1
#> 9    NA   NA   NA   NA   NA   NA  40.1   NA   65   46   81    0 20.4   NA 24.3
#> 10   NA   NA   NA   NA   NA   NA   0.3   NA   53   36   72    0 16.1   NA 20.4
#> 11   NA   NA   NA   NA   NA   NA  85.0   NA   52   36   68    0 10.8   NA 14.6
#> 12   NA   NA   NA   NA   NA   NA 115.1   NA   59   44   74   71  3.5   NA  6.4
#>    tmin tsun wdf1 wdf2 wdf5 wdfg wdfm wdmv wsf1 wsf2 wsf5 wsfg wsfm
#> 1   0.1   NA   NA   60   50   NA   NA   NA   NA 11.6 19.7   NA   NA
#> 2   1.1   NA   NA  280  290   NA   NA   NA   NA 12.5 21.9   NA   NA
#> 3   4.8   NA   NA  310  290   NA   NA   NA   NA 11.6 23.7   NA   NA
#> 4   8.6   NA   NA   60   40   NA   NA   NA   NA 14.8 26.4   NA   NA
#> 5  14.1   NA   NA   60   70   NA   NA   NA   NA  8.1 14.8   NA   NA
#> 6  19.5   NA   NA  290  290   NA   NA   NA   NA  9.4 20.6   NA   NA
#> 7  22.3   NA   NA  300  200   NA   NA   NA   NA  6.7 13.0   NA   NA
#> 8  19.8   NA   NA   60  200   NA   NA   NA   NA  7.2 14.3   NA   NA
#> 9  16.6   NA   NA   60   60   NA   NA   NA   NA  7.6 11.6   NA   NA
#> 10 11.7   NA   NA  280  280   NA   NA   NA   NA  8.1 15.7   NA   NA
#> 11  7.0   NA   NA  290  280   NA   NA   NA   NA  9.4 17.4   NA   NA
#> 12  0.6   NA   NA  240  280   NA   NA   NA   NA 10.3 19.7   NA   NA
options(op)
# }
```
