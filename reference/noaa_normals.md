# Climate normals (1991-2020)

Returns 30-year climate normals from the NCEI Normals dataset. Normals
represent the average climate conditions over the 1991-2020 period.

## Usage

``` r
noaa_normals(
  station,
  period = "monthly",
  datatypes = NULL,
  include_flags = FALSE,
  include_location = FALSE,
  cache = TRUE
)
```

## Arguments

- station:

  Character. One or more station IDs.

- period:

  Character. One of `"monthly"`, `"daily"`, or `"annual"`.

- datatypes:

  Optional character vector of data type codes.

- include_flags:

  Logical. Include data quality flags from NCEI (default `FALSE`).

- include_location:

  Logical. Include station latitude, longitude, and elevation columns
  (default `FALSE`).

- cache:

  Logical. Use cached data if available (default `TRUE`).

## Value

A data frame. Columns vary by period but typically include station, date
or month, and normal values for temperature, precipitation, and other
variables.

## See also

Other weather data:
[`noaa_annual()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_annual.md),
[`noaa_daily()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_daily.md),
[`noaa_monthly()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_monthly.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
noaa_normals("USW00094728", "monthly")
#> ℹ Fetching monthly climate normals
#> ✔ Fetching monthly climate normals [138ms]
#> 
#>        station                         name date mly.cldd.base40
#> 1  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>             7.7
#> 2  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>            11.8
#> 3  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>            69.8
#> 4  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           211.4
#> 5  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           381.8
#> 6  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           516.3
#> 7  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           627.9
#> 8  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           603.9
#> 9  USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           469.7
#> 10 USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           291.4
#> 11 USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>           127.7
#> 12 USW00094728 NEW YORK CNTRL PK TWR, NY US <NA>            35.2
#>    mly.cldd.base45 mly.cldd.base50 mly.cldd.base55 mly.cldd.base57
#> 1              8.9             2.4             0.5             0.2
#> 2             11.5             3.5             0.7             0.4
#> 3             43.6            18.9             7.2             4.6
#> 4            153.3            89.8            45.0            32.9
#> 5            313.5           227.9           146.8           117.7
#> 6            450.9           367.4           284.2           251.1
#> 7            559.7           473.5           387.4           353.0
#> 8            535.6           449.4           363.3           328.9
#> 9            404.1           320.8           238.1           205.6
#> 10           224.6           146.1            80.9            60.5
#> 11            83.7            40.2            14.9             9.2
#> 12            23.1             8.4             2.5             1.4
#>    mly.cldd.base60 mly.cldd.base70 mly.cldd.base72 mly.cldd.normal
#> 1              0.0             0.0             0.0           -17.8
#> 2              0.1             0.0             0.0           -17.8
#> 3              2.1             0.1             0.1           -17.1
#> 4             19.8             2.6             1.7           -10.2
#> 5             80.3            13.7             8.4            19.0
#> 6            202.1            62.5            43.2           107.9
#> 7            301.3           131.4           100.3           197.5
#> 8            277.2           109.9            80.4           173.8
#> 9            158.2            38.0            24.1            70.7
#> 10            36.2             2.7             1.2            -5.8
#> 11             4.0             0.0             0.0           -17.3
#> 12             0.5             0.0             0.0           -17.8
#>    mly.dutr.normal mly.dutr.stddev mly.grdd.base40 mly.grdd.base45
#> 1            -11.4           -17.0            25.5             8.9
#> 2            -10.7           -16.8            29.7            11.5
#> 3             -9.9           -16.9            87.7            43.6
#> 4             -8.7           -17.1           229.3           153.3
#> 5             -8.7           -16.9           399.6           313.5
#> 6             -9.3           -17.0           534.2           450.9
#> 7             -9.6           -16.9           645.8           559.7
#> 8             -9.8           -17.0           621.7           535.6
#> 9            -10.1           -16.9           487.5           404.1
#> 10           -10.5           -17.1           309.3           224.6
#> 11           -11.1           -17.0           145.5            83.7
#> 12           -11.9           -17.2            53.0            23.1
#>    mly.grdd.base50 mly.grdd.base55 mly.grdd.base57 mly.grdd.base60
#> 1              2.4             0.5             0.2             0.0
#> 2              3.5             0.7             0.4             0.1
#> 3             18.9             7.2             4.6             2.1
#> 4             89.8            45.0            32.9            19.8
#> 5            227.9           146.8           117.7            80.3
#> 6            367.4           284.2           251.1           202.1
#> 7            473.5           387.4           353.0           301.3
#> 8            449.4           363.3           328.9           277.2
#> 9            320.8           238.1           205.6           158.2
#> 10           146.1            80.9            60.5            36.2
#> 11            40.2            14.9             9.2             4.0
#> 12             8.4             2.5             1.4             0.5
#>    mly.grdd.base65 mly.grdd.base70 mly.grdd.base72 mly.grdd.tb4886
#> 1              0.0             0.0             0.0            -6.7
#> 2              0.0             0.0             0.0            -3.6
#> 3              0.7             0.1             0.1            27.8
#> 4              7.6             2.6             1.7           114.1
#> 5             36.8            13.7             8.4           245.3
#> 6            125.7            62.5            43.2           377.1
#> 7            215.3           131.4           100.3           473.4
#> 8            191.6           109.9            80.4           455.8
#> 9             88.5            38.0            24.1           334.4
#> 10            12.0             2.7             1.2           167.3
#> 11             0.5             0.0             0.0            52.8
#> 12             0.0             0.0             0.0             4.3
#>    mly.grdd.tb5086 mly.htdd.base40 mly.htdd.base45 mly.htdd.base50
#> 1             -9.9           133.9           203.4           283.0
#> 2             -7.2            94.2           153.8           223.6
#> 3             18.1            38.5            80.6           142.1
#> 4             94.2             1.8             9.2            29.0
#> 5            213.8             0.0             0.1             0.6
#> 6            343.9             0.0             0.0             0.0
#> 7            438.9             0.0             0.0             0.0
#> 8            421.3             0.0             0.0             0.0
#> 9            301.6             0.0             0.0             0.1
#> 10           140.0             0.1             1.5             9.2
#> 11            37.9            12.2            33.7            73.5
#> 12            -1.6            69.3           125.5           196.9
#>    mly.htdd.base55 mly.htdd.base57 mly.htdd.base60 mly.htdd.normal
#> 1            367.1           401.4           452.8           521.2
#> 2            298.5           329.4           375.7           435.7
#> 3            216.4           248.3           297.5           364.3
#> 4             67.6            88.7           125.6           179.1
#> 5              5.6            10.9            25.2            50.0
#> 6              0.1             0.3             1.3            -9.6
#> 7              0.0             0.0             0.0           -17.7
#> 8              0.0             0.0             0.0           -17.3
#> 9              0.6             1.5             4.1            -0.1
#> 10            30.1            44.2            71.5           115.6
#> 11           131.6           159.2           204.0           266.1
#> 12           277.1           310.5           361.3           429.1
#>    mly.prcp.20pctl mly.prcp.25pctl mly.prcp.33pctl mly.prcp.40pctl
#> 1             57.9            70.4            74.7            81.3
#> 2             49.5            50.8            64.3            65.3
#> 3             75.4            86.1            95.3            97.8
#> 4             57.2            63.8            74.9            84.6
#> 5             64.0            73.2            78.5            88.4
#> 6             64.0            75.9            80.8            82.3
#> 7             70.9            73.4            94.0            99.8
#> 8             69.6            72.6            75.9            83.6
#> 9             56.9            71.9            81.3            86.4
#> 10            49.5            57.9            72.9            91.7
#> 11            49.8            52.1            58.2            75.7
#> 12            73.7            81.5            99.3           105.9
#>    mly.prcp.50pctl mly.prcp.60pctl mly.prcp.67pctl mly.prcp.75pctl
#> 1             86.6            92.7           101.1           121.7
#> 2             72.1            79.5            87.6           103.1
#> 3            103.6           122.4           129.8           131.8
#> 4             91.9           106.2           114.8           121.4
#> 5             98.6           104.6           112.0           126.7
#> 6            111.0           121.2           122.4           137.4
#> 7            110.5           143.8           149.6           164.6
#> 8             95.5           106.2           126.0           140.7
#> 9             94.0           116.6           128.0           134.4
#> 10           105.9           120.9           126.0           145.5
#> 11            89.2           103.4           108.2           114.3
#> 12           112.8           120.9           124.0           136.4
#>    mly.prcp.80pctl mly.prcp.avgnds.ge001hi mly.prcp.avgnds.ge010hi
#> 1            125.7                    10.8                     6.3
#> 2            112.8                    10.0                     6.0
#> 3            133.9                    11.1                     7.5
#> 4            137.2                    11.4                     6.5
#> 5            132.3                    11.5                     7.3
#> 6            146.3                    11.2                     7.0
#> 7            175.8                    10.5                     6.9
#> 8            149.9                    10.0                     6.5
#> 9            148.8                     8.8                     6.2
#> 10           154.9                     9.5                     5.6
#> 11           121.2                     9.2                     5.7
#> 12           142.5                    11.4                     7.3
#>    mly.prcp.avgnds.ge025hi mly.prcp.avgnds.ge050hi mly.prcp.avgnds.ge100hi
#> 1                      4.4                     2.5                     0.9
#> 2                      3.9                     2.2                     1.0
#> 3                      5.1                     2.7                     1.0
#> 4                      4.2                     2.4                     1.0
#> 5                      4.6                     2.7                     1.0
#> 6                      4.9                     3.1                     1.1
#> 7                      5.1                     3.2                     1.4
#> 8                      4.5                     3.1                     1.2
#> 9                      4.3                     2.7                     1.3
#> 10                     4.2                     2.8                     1.5
#> 11                     4.4                     2.6                     1.0
#> 12                     5.1                     3.3                     1.2
#>    mly.prcp.avgnds.ge200hi mly.prcp.avgnds.ge400hi mly.prcp.avgnds.ge600hi
#> 1                      0.1                     0.0                       0
#> 2                      0.0                     0.0                       0
#> 3                      0.3                     0.0                       0
#> 4                      0.3                     0.1                       0
#> 5                      0.1                     0.0                       0
#> 6                      0.3                     0.0                       0
#> 7                      0.2                     0.0                       0
#> 8                      0.4                     0.0                       0
#> 9                      0.3                     0.0                       0
#> 10                     0.3                     0.1                       0
#> 11                     0.1                     0.0                       0
#> 12                     0.1                     0.0                       0
#>    mly.prcp.normal mly.snow.20pctl mly.snow.25pctl mly.snow.33pctl
#> 1             92.5            38.1            50.8            61.0
#> 2             81.0            40.6            73.7           101.6
#> 3            109.0             2.5             5.1            25.4
#> 4            103.9             0.0             0.0             0.0
#> 5            100.6             0.0             0.0             0.0
#> 6            115.3             0.0             0.0             0.0
#> 7            116.8             0.0             0.0             0.0
#> 8            115.8             0.0             0.0             0.0
#> 9            109.5             0.0             0.0             0.0
#> 10           111.3             0.0             0.0             0.0
#> 11            90.9             0.0             0.0             0.0
#> 12           111.3             0.0             0.0            10.2
#>    mly.snow.40pctl mly.snow.50pctl mly.snow.60pctl mly.snow.67pctl
#> 1             94.0           114.3           210.8           236.2
#> 2            116.8           180.3           241.3           279.4
#> 3             38.1           106.7           137.2           177.8
#> 4              0.0             0.0             0.0             0.0
#> 5              0.0             0.0             0.0             0.0
#> 6              0.0             0.0             0.0             0.0
#> 7              0.0             0.0             0.0             0.0
#> 8              0.0             0.0             0.0             0.0
#> 9              0.0             0.0             0.0             0.0
#> 10             0.0             0.0             0.0             0.0
#> 11             0.0             0.0             0.0             0.0
#> 12            20.3            63.5            81.3           167.6
#>    mly.snow.75pctl mly.snow.80pctl mly.snow.avgnds.ge001ti
#> 1            304.8           403.9                     3.7
#> 2            337.8           429.3                     3.2
#> 3            210.8           238.8                     2.0
#> 4              0.0             0.0                     0.2
#> 5              0.0             0.0                     0.0
#> 6              0.0             0.0                     0.0
#> 7              0.0             0.0                     0.0
#> 8              0.0             0.0                     0.0
#> 9              0.0             0.0                     0.0
#> 10             0.0             0.0                     0.0
#> 11             0.0             0.0                     0.2
#> 12           218.4           259.1                     2.1
#>    mly.snow.avgnds.ge010ti mly.snow.avgnds.ge020ti mly.snow.avgnds.ge030ti
#> 1                      2.1                     1.3                     1.0
#> 2                      2.2                     1.5                     1.2
#> 3                      1.3                     0.9                     0.8
#> 4                      0.1                     0.1                     0.1
#> 5                      0.0                     0.0                     0.0
#> 6                      0.0                     0.0                     0.0
#> 7                      0.0                     0.0                     0.0
#> 8                      0.0                     0.0                     0.0
#> 9                      0.0                     0.0                     0.0
#> 10                     0.0                     0.0                     0.0
#> 11                     0.1                     0.1                     0.1
#> 12                     1.2                     0.7                     0.6
#>    mly.snow.avgnds.ge040ti mly.snow.avgnds.ge050ti mly.snow.avgnds.ge100ti
#> 1                      0.7                     0.5                     0.1
#> 2                      0.9                     0.7                     0.2
#> 3                      0.5                     0.3                     0.0
#> 4                      0.1                     0.0                     0.0
#> 5                      0.0                     0.0                     0.0
#> 6                      0.0                     0.0                     0.0
#> 7                      0.0                     0.0                     0.0
#> 8                      0.0                     0.0                     0.0
#> 9                      0.0                     0.0                     0.0
#> 10                     0.0                     0.0                     0.0
#> 11                     0.1                     0.0                     0.0
#> 12                     0.5                     0.4                     0.1
#>    mly.snow.avgnds.ge200ti mly.snow.normal mly.snwd.avgnds.ge001wi
#> 1                        0           223.5                     7.9
#> 2                        0           256.5                     9.1
#> 3                        0           127.0                     4.0
#> 4                        0            10.2                     0.1
#> 5                        0             0.0                     0.0
#> 6                        0             0.0                     0.0
#> 7                        0             0.0                     0.0
#> 8                        0             0.0                     0.0
#> 9                        0             0.0                     0.0
#> 10                       0             2.5                     0.0
#> 11                       0            12.7                     0.2
#> 12                       0           124.5                     2.9
#>    mly.snwd.avgnds.ge002wi mly.snwd.avgnds.ge003wi mly.snwd.avgnds.ge004wi
#> 1                      6.2                     4.8                     4.0
#> 2                      8.0                     6.4                     6.0
#> 3                      3.1                     2.4                     2.0
#> 4                      0.1                     0.1                     0.1
#> 5                      0.0                     0.0                     0.0
#> 6                      0.0                     0.0                     0.0
#> 7                      0.0                     0.0                     0.0
#> 8                      0.0                     0.0                     0.0
#> 9                      0.0                     0.0                     0.0
#> 10                     0.0                     0.0                     0.0
#> 11                     0.2                     0.1                     0.1
#> 12                     2.2                     1.8                     1.2
#>    mly.snwd.avgnds.ge005wi mly.snwd.avgnds.ge010wi mly.snwd.avgnds.ge020wi
#> 1                      3.4                     0.8                     0.1
#> 2                      5.5                     2.2                     0.2
#> 3                      1.3                     0.4                     0.0
#> 4                      0.0                     0.0                     0.0
#> 5                      0.0                     0.0                     0.0
#> 6                      0.0                     0.0                     0.0
#> 7                      0.0                     0.0                     0.0
#> 8                      0.0                     0.0                     0.0
#> 9                      0.0                     0.0                     0.0
#> 10                     0.0                     0.0                     0.0
#> 11                     0.0                     0.0                     0.0
#> 12                     0.9                     0.3                     0.0
#>    mly.tavg.stddev mly.tmax.normal mly.tmax.stddev mly.tmin.avgnds.grth032
#> 1            -15.4             4.2           -15.4                      NA
#> 2            -15.3             5.7           -15.3                      NA
#> 3            -15.9             9.9           -15.7                      NA
#> 4            -16.6            16.6           -16.3                      NA
#> 5            -16.4            21.9           -16.2                      NA
#> 6            -16.8            26.5           -16.6                      NA
#> 7            -16.3            29.4           -16.1                      NA
#> 8            -16.7            28.5           -16.5                      NA
#> 9            -16.6            24.6           -16.4                      NA
#> 10           -16.5            18.1           -16.4                      NA
#> 11           -16.1            12.2           -15.9                      NA
#> 12           -15.6             6.8           -15.5                      NA
#>    mly.tmin.avgnds.grth040 mly.tmin.avgnds.grth050 mly.tmin.avgnds.grth060
#> 1                       NA                      NA                      NA
#> 2                       NA                      NA                      NA
#> 3                       NA                      NA                      NA
#> 4                       NA                      NA                      NA
#> 5                       NA                      NA                      NA
#> 6                       NA                      NA                      NA
#> 7                       NA                      NA                      NA
#> 8                       NA                      NA                      NA
#> 9                       NA                      NA                      NA
#> 10                      NA                      NA                      NA
#> 11                      NA                      NA                      NA
#> 12                      NA                      NA                      NA
#>    mly.tmin.avgnds.grth070 mly.tmin.avgnds.grth080 mly.tmin.avgnds.grth090
#> 1                       NA                      NA                      NA
#> 2                       NA                      NA                      NA
#> 3                       NA                      NA                      NA
#> 4                       NA                      NA                      NA
#> 5                       NA                      NA                      NA
#> 6                       NA                      NA                      NA
#> 7                       NA                      NA                      NA
#> 8                       NA                      NA                      NA
#> 9                       NA                      NA                      NA
#> 10                      NA                      NA                      NA
#> 11                      NA                      NA                      NA
#> 12                      NA                      NA                      NA
#>    mly.tmin.avgnds.grth100 mly.tmin.avgnds.lsth000 mly.tmin.avgnds.lsth010
#> 1                       NA                     0.1                     2.0
#> 2                       NA                     0.0                     0.8
#> 3                       NA                     0.0                     0.0
#> 4                       NA                     0.0                     0.0
#> 5                       NA                     0.0                     0.0
#> 6                       NA                     0.0                     0.0
#> 7                       NA                     0.0                     0.0
#> 8                       NA                     0.0                     0.0
#> 9                       NA                     0.0                     0.0
#> 10                      NA                     0.0                     0.0
#> 11                      NA                     0.0                     0.0
#> 12                      NA                     0.0                     0.1
#>    mly.tmin.avgnds.lsth020 mly.tmin.avgnds.lsth032 mly.tmin.avgnds.lsth040
#> 1                      7.9                    20.5                    28.3
#> 2                      5.0                    17.7                    25.6
#> 3                      1.6                    10.6                    22.9
#> 4                      0.0                     1.0                     7.3
#> 5                      0.0                     0.0                     0.1
#> 6                      0.0                     0.0                     0.0
#> 7                      0.0                     0.0                     0.0
#> 8                      0.0                     0.0                     0.0
#> 9                      0.0                     0.0                     0.0
#> 10                     0.0                     0.0                     2.4
#> 11                     0.1                     3.6                    14.5
#> 12                     2.5                    13.8                    25.2
#>    mly.tmin.avgnds.lsth050 mly.tmin.avgnds.lsth060 mly.tmin.avgnds.lsth070
#> 1                     30.8                    31.0                    31.0
#> 2                     27.9                    28.0                    28.0
#> 3                     30.1                    30.9                    31.0
#> 4                     24.2                    29.3                    29.9
#> 5                      9.0                    25.6                    30.5
#> 6                      0.3                     8.9                    25.9
#> 7                      0.0                     0.6                    17.6
#> 8                      0.0                     1.6                    20.5
#> 9                      1.4                    12.6                    27.7
#> 10                    15.4                    27.9                    30.9
#> 11                    25.7                    29.8                    30.0
#> 12                    30.2                    30.9                    31.0
#>    mly.tmin.normal mly.tmin.prbocc.lsth016 mly.tmin.prbocc.lsth020
#> 1             -2.3                    81.5                    95.2
#> 2             -1.4                    65.2                    89.8
#> 3              2.1                    20.6                    51.2
#> 4              7.5                     0.0                     0.0
#> 5             12.8                     0.0                     0.0
#> 6             18.0                     0.0                     0.0
#> 7             21.2                     0.0                     0.0
#> 8             20.5                     0.0                     0.0
#> 9             16.8                     0.0                     0.0
#> 10            10.8                     0.0                     0.0
#> 11             5.6                     0.8                     4.1
#> 12             1.0                    33.3                    63.6
#>    mly.tmin.prbocc.lsth024 mly.tmin.prbocc.lsth028 mly.tmin.prbocc.lsth032
#> 1                     99.4                   100.0                   100.0
#> 2                     99.1                   100.0                   100.0
#> 3                     79.2                    94.0                    98.7
#> 4                      1.4                    12.8                    40.4
#> 5                      0.0                     0.0                     0.0
#> 6                      0.0                     0.0                     0.0
#> 7                      0.0                     0.0                     0.0
#> 8                      0.0                     0.0                     0.0
#> 9                      0.0                     0.0                     0.0
#> 10                     0.0                     0.0                     0.7
#> 11                    18.5                    46.6                    78.3
#> 12                    87.2                    97.1                    98.8
#>    mly.tmin.prbocc.lsth036 mly.tmin.stddev
#> 1                    100.0           -15.3
#> 2                    100.0           -15.3
#> 3                    100.0           -15.9
#> 4                     78.5           -16.7
#> 5                      2.8           -16.4
#> 6                      0.0           -17.0
#> 7                      0.0           -16.5
#> 8                      0.0           -16.7
#> 9                      0.0           -16.7
#> 10                    18.8           -16.5
#> 11                    94.9           -16.1
#> 12                    99.8           -15.7
options(op)
# }
```
