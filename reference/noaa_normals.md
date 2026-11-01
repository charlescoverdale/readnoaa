# Climate normals (1991-2020)

Returns 30-year climate normals from the NCEI Normals datasets. Normals
are the average conditions over the 1991-2020 reference period, and are
used as the baseline against which current weather is compared.

## Usage

``` r
noaa_normals(
  station,
  period = "monthly",
  datatypes = NULL,
  start_date = NULL,
  end_date = NULL,
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

- period:

  Character. One of `"monthly"`, `"daily"`, `"hourly"`, or `"annual"`.

- datatypes:

  Optional character vector of data type codes.

- start_date, end_date:

  Optional character dates bounding the window for the `"daily"` and
  `"hourly"` periods. Ignored for `"monthly"` and `"annual"`, which
  cover the whole year by construction.

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

A data frame. Columns vary by period, but typically include `station`, a
climatological `date` with derived `month`/`day`/`hour` columns, and
normal values for temperature, precipitation, and other variables.

## Details

Four periods are available, each backed by a different NCEI dataset:

- `"monthly"`:

  `normals-monthly-1991-2020`. Twelve rows per station.

- `"daily"`:

  `normals-daily-1991-2020`. One row per day of the year.

- `"hourly"`:

  `normals-hourly-1991-2020`. One row per hour of the year.

- `"annual"`:

  `normals-annualseasonal-1991-2020`. One row per station, covering
  annual and seasonal statistics.

The daily and hourly datasets require a date window, which is supplied
automatically as a full calendar year unless you narrow it with
`start_date` and `end_date`. Because normals are climatological rather
than tied to a particular year, only the month and day of those
arguments are meaningful.

Normals carry a climatological pseudo-date rather than a calendar date:
`"01"` for a month, `"01-31"` for a day of the year. These are returned
verbatim in `date`, with integer `month`, `day`, and `hour` columns
added alongside for filtering and joining. The annual and seasonal
dataset has no date column at all.

## Units

The NCEI normals datasets are published in United States customary units
(degrees Fahrenheit, inches). Asked for metric units, the API converts
them inconsistently: precipitation and monthly maximum and minimum
temperature are converted, monthly average temperature is not, and
temperature ranges are converted as if they were temperatures (giving
negative diurnal ranges). This function therefore always requests the
published units and, unlike the observational functions, has no metric
option. Convert after the fact if you need Celsius or millimetres.

## See also

Other weather data:
[`noaa_annual()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_annual.md),
[`noaa_daily()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_daily.md),
[`noaa_monthly()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_monthly.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
try({
  # Monthly normals: twelve rows, values in Fahrenheit and inches
  noaa_normals("USW00094728", "monthly")

  # Daily normals for January only
  noaa_normals("USW00094728", "daily",
  start_date = "2020-01-01", end_date = "2020-01-31")
})
#> ℹ Fetching monthly climate normals
#> ✔ Fetching monthly climate normals [2.8s]
#> 
#> ℹ Fetching daily climate normals
#> ✔ Fetching daily climate normals [3.4s]
#> 
#>        station                         name  date month day dly_cldd_base40
#> 1  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-01     1   1             1.8
#> 2  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-02     1   2             1.8
#> 3  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-03     1   3             1.8
#> 4  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-04     1   4             1.7
#> 5  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-05     1   5             1.7
#> 6  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-06     1   6             1.7
#> 7  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-07     1   7             1.7
#> 8  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-08     1   8             1.7
#> 9  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-09     1   9             1.7
#> 10 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-10     1  10             1.7
#> 11 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-11     1  11             1.6
#> 12 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-12     1  12             1.6
#> 13 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-13     1  13             1.5
#> 14 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-14     1  14             1.5
#> 15 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-15     1  15             1.5
#> 16 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-16     1  16             1.4
#> 17 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-17     1  17             1.4
#> 18 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-18     1  18             1.4
#> 19 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-19     1  19             1.3
#> 20 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-20     1  20             1.3
#> 21 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-21     1  21             1.3
#> 22 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-22     1  22             1.3
#> 23 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-23     1  23             1.2
#> 24 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-24     1  24             1.2
#> 25 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-25     1  25             1.2
#> 26 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-26     1  26             1.2
#> 27 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-27     1  27             1.3
#> 28 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-28     1  28             1.3
#> 29 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-29     1  29             1.3
#> 30 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-30     1  30             1.3
#> 31 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-31     1  31             1.3
#>    dly_cldd_base45 dly_cldd_base50 dly_cldd_base55 dly_cldd_base57
#> 1              0.7             0.2             0.0               0
#> 2              0.7             0.2             0.0               0
#> 3              0.7             0.2             0.0               0
#> 4              0.7             0.2             0.0               0
#> 5              0.6             0.2             0.0               0
#> 6              0.7             0.2             0.0               0
#> 7              0.7             0.2             0.0               0
#> 8              0.7             0.2             0.0               0
#> 9              0.7             0.2             0.1               0
#> 10             0.7             0.2             0.1               0
#> 11             0.6             0.2             0.0               0
#> 12             0.6             0.2             0.0               0
#> 13             0.5             0.2             0.0               0
#> 14             0.5             0.2             0.0               0
#> 15             0.5             0.1             0.0               0
#> 16             0.4             0.1             0.0               0
#> 17             0.4             0.1             0.0               0
#> 18             0.4             0.1             0.0               0
#> 19             0.4             0.1             0.0               0
#> 20             0.4             0.1             0.0               0
#> 21             0.4             0.1             0.0               0
#> 22             0.4             0.1             0.0               0
#> 23             0.4             0.1             0.0               0
#> 24             0.4             0.1             0.0               0
#> 25             0.4             0.1             0.0               0
#> 26             0.4             0.1             0.0               0
#> 27             0.4             0.1             0.0               0
#> 28             0.4             0.1             0.0               0
#> 29             0.5             0.1             0.0               0
#> 30             0.5             0.1             0.0               0
#> 31             0.5             0.1             0.0               0
#>    dly_cldd_base60 dly_cldd_base70 dly_cldd_base72 dly_cldd_normal
#> 1                0               0               0               0
#> 2                0               0               0               0
#> 3                0               0               0               0
#> 4                0               0               0               0
#> 5                0               0               0               0
#> 6                0               0               0               0
#> 7                0               0               0               0
#> 8                0               0               0               0
#> 9                0               0               0               0
#> 10               0               0               0               0
#> 11               0               0               0               0
#> 12               0               0               0               0
#> 13               0               0               0               0
#> 14               0               0               0               0
#> 15               0               0               0               0
#> 16               0               0               0               0
#> 17               0               0               0               0
#> 18               0               0               0               0
#> 19               0               0               0               0
#> 20               0               0               0               0
#> 21               0               0               0               0
#> 22               0               0               0               0
#> 23               0               0               0               0
#> 24               0               0               0               0
#> 25               0               0               0               0
#> 26               0               0               0               0
#> 27               0               0               0               0
#> 28               0               0               0               0
#> 29               0               0               0               0
#> 30               0               0               0               0
#> 31               0               0               0               0
#>    dly_dutr_normal dly_dutr_stddev dly_grdd_base40 dly_grdd_base45
#> 1             10.7             5.1             1.8             0.7
#> 2             10.8             5.1             1.8             0.7
#> 3             10.8             5.1             1.8             0.7
#> 4             10.9             5.1             1.7             0.7
#> 5             10.9             5.2             1.7             0.6
#> 6             11.0             5.2             1.7             0.7
#> 7             11.1             5.2             1.7             0.7
#> 8             11.1             5.2             1.7             0.7
#> 9             11.2             5.2             1.7             0.7
#> 10            11.3             5.3             1.7             0.7
#> 11            11.3             5.3             1.6             0.6
#> 12            11.4             5.3             1.6             0.6
#> 13            11.5             5.3             1.5             0.5
#> 14            11.5             5.3             1.5             0.5
#> 15            11.6             5.3             1.5             0.5
#> 16            11.6             5.3             1.4             0.4
#> 17            11.7             5.4             1.4             0.4
#> 18            11.8             5.4             1.4             0.4
#> 19            11.8             5.4             1.3             0.4
#> 20            11.9             5.4             1.3             0.4
#> 21            11.9             5.4             1.3             0.4
#> 22            12.0             5.4             1.3             0.4
#> 23            12.0             5.4             1.2             0.4
#> 24            12.1             5.4             1.2             0.4
#> 25            12.1             5.4             1.2             0.4
#> 26            12.2             5.4             1.2             0.4
#> 27            12.2             5.4             1.3             0.4
#> 28            12.2             5.3             1.3             0.4
#> 29            12.3             5.3             1.3             0.5
#> 30            12.3             5.3             1.3             0.5
#> 31            12.4             5.3             1.3             0.5
#>    dly_grdd_base50 dly_grdd_base55 dly_grdd_base57 dly_grdd_base60
#> 1              0.2             0.0               0               0
#> 2              0.2             0.0               0               0
#> 3              0.2             0.0               0               0
#> 4              0.2             0.0               0               0
#> 5              0.2             0.0               0               0
#> 6              0.2             0.0               0               0
#> 7              0.2             0.0               0               0
#> 8              0.2             0.0               0               0
#> 9              0.2             0.1               0               0
#> 10             0.2             0.1               0               0
#> 11             0.2             0.0               0               0
#> 12             0.2             0.0               0               0
#> 13             0.2             0.0               0               0
#> 14             0.2             0.0               0               0
#> 15             0.1             0.0               0               0
#> 16             0.1             0.0               0               0
#> 17             0.1             0.0               0               0
#> 18             0.1             0.0               0               0
#> 19             0.1             0.0               0               0
#> 20             0.1             0.0               0               0
#> 21             0.1             0.0               0               0
#> 22             0.1             0.0               0               0
#> 23             0.1             0.0               0               0
#> 24             0.1             0.0               0               0
#> 25             0.1             0.0               0               0
#> 26             0.1             0.0               0               0
#> 27             0.1             0.0               0               0
#> 28             0.1             0.0               0               0
#> 29             0.1             0.0               0               0
#> 30             0.1             0.0               0               0
#> 31             0.1             0.0               0               0
#>    dly_grdd_base65 dly_grdd_base70 dly_grdd_base72 dly_grdd_tb4886
#> 1                0               0               0             0.7
#> 2                0               0               0             0.7
#> 3                0               0               0             0.7
#> 4                0               0               0             0.7
#> 5                0               0               0             0.7
#> 6                0               0               0             0.7
#> 7                0               0               0             0.7
#> 8                0               0               0             0.8
#> 9                0               0               0             0.8
#> 10               0               0               0             0.8
#> 11               0               0               0             0.7
#> 12               0               0               0             0.7
#> 13               0               0               0             0.7
#> 14               0               0               0             0.7
#> 15               0               0               0             0.6
#> 16               0               0               0             0.6
#> 17               0               0               0             0.6
#> 18               0               0               0             0.6
#> 19               0               0               0             0.6
#> 20               0               0               0             0.6
#> 21               0               0               0             0.6
#> 22               0               0               0             0.5
#> 23               0               0               0             0.5
#> 24               0               0               0             0.5
#> 25               0               0               0             0.5
#> 26               0               0               0             0.5
#> 27               0               0               0             0.6
#> 28               0               0               0             0.6
#> 29               0               0               0             0.6
#> 30               0               0               0             0.6
#> 31               0               0               0             0.6
#>    dly_grdd_tb5086 dly_htdd_base40 dly_htdd_base45 dly_htdd_base50
#> 1              0.5             6.6            10.5            15.0
#> 2              0.5             6.8            10.7            15.2
#> 3              0.5             6.9            10.8            15.3
#> 4              0.5             7.1            11.0            15.5
#> 5              0.5             7.2            11.1            15.7
#> 6              0.5             7.4            11.3            15.8
#> 7              0.5             7.5            11.5            16.0
#> 8              0.6             7.7            11.6            16.1
#> 9              0.6             7.8            11.7            16.3
#> 10             0.6             7.9            11.8            16.4
#> 11             0.5             7.9            11.9            16.5
#> 12             0.5             7.9            12.0            16.6
#> 13             0.5             8.0            12.0            16.6
#> 14             0.5             8.0            12.1            16.7
#> 15             0.4             8.1            12.1            16.8
#> 16             0.4             8.1            12.1            16.8
#> 17             0.4             8.1            12.2            16.8
#> 18             0.4             8.1            12.2            16.9
#> 19             0.4             8.1            12.2            16.9
#> 20             0.4             8.1            12.2            16.9
#> 21             0.4             8.1            12.2            16.9
#> 22             0.4             8.1            12.2            16.9
#> 23             0.4             8.1            12.2            16.9
#> 24             0.4             8.1            12.2            16.9
#> 25             0.4             8.0            12.2            16.9
#> 26             0.4             8.0            12.1            16.8
#> 27             0.4             8.0            12.1            16.8
#> 28             0.4             7.9            12.1            16.7
#> 29             0.4             7.9            12.0            16.7
#> 30             0.4             7.8            11.9            16.6
#> 31             0.4             7.7            11.9            16.5
#>    dly_htdd_base55 dly_htdd_base57 dly_htdd_base60 dly_htdd_normal
#> 1             19.8            21.8            24.8            29.8
#> 2             20.0            22.0            25.0            30.0
#> 3             20.2            22.2            25.2            30.2
#> 4             20.4            22.3            25.3            30.3
#> 5             20.5            22.5            25.5            30.5
#> 6             20.7            22.7            25.6            30.6
#> 7             20.8            22.8            25.8            30.8
#> 8             21.0            22.9            25.9            30.9
#> 9             21.1            23.1            26.1            31.1
#> 10            21.2            23.2            26.2            31.2
#> 11            21.3            23.3            26.3            31.3
#> 12            21.4            23.4            26.4            31.4
#> 13            21.5            23.5            26.5            31.5
#> 14            21.6            23.6            26.6            31.6
#> 15            21.7            23.6            26.6            31.6
#> 16            21.7            23.7            26.7            31.7
#> 17            21.8            23.7            26.7            31.7
#> 18            21.8            23.8            26.8            31.8
#> 19            21.8            23.8            26.8            31.8
#> 20            21.8            23.8            26.8            31.8
#> 21            21.9            23.8            26.8            31.8
#> 22            21.9            23.9            26.8            31.8
#> 23            21.8            23.8            26.8            31.8
#> 24            21.8            23.8            26.8            31.8
#> 25            21.8            23.8            26.8            31.8
#> 26            21.8            23.8            26.7            31.7
#> 27            21.7            23.7            26.7            31.7
#> 28            21.6            23.6            26.6            31.6
#> 29            21.6            23.6            26.6            31.6
#> 30            21.5            23.5            26.5            31.5
#> 31            21.4            23.4            26.4            31.4
#>    dly_prcp_25pctl dly_prcp_50pctl dly_prcp_75pctl dly_prcp_pctall_ge001hi
#> 1             0.05            0.19            0.52                    35.8
#> 2             0.05            0.19            0.51                    35.7
#> 3             0.05            0.18            0.51                    35.6
#> 4             0.05            0.18            0.51                    35.5
#> 5             0.05            0.18            0.51                    35.5
#> 6             0.05            0.18            0.50                    35.5
#> 7             0.05            0.18            0.50                    35.4
#> 8             0.05            0.17            0.50                    35.3
#> 9             0.05            0.17            0.50                    35.3
#> 10            0.05            0.17            0.49                    35.2
#> 11            0.05            0.17            0.49                    35.2
#> 12            0.05            0.17            0.49                    35.1
#> 13            0.05            0.17            0.49                    35.0
#> 14            0.05            0.17            0.49                    35.0
#> 15            0.05            0.16            0.48                    34.9
#> 16            0.05            0.16            0.48                    34.8
#> 17            0.05            0.16            0.48                    34.8
#> 18            0.05            0.16            0.48                    34.7
#> 19            0.05            0.16            0.48                    34.6
#> 20            0.05            0.16            0.48                    34.5
#> 21            0.05            0.16            0.47                    34.4
#> 22            0.05            0.16            0.47                    34.3
#> 23            0.05            0.16            0.47                    34.3
#> 24            0.05            0.16            0.47                    34.2
#> 25            0.05            0.15            0.47                    34.2
#> 26            0.05            0.15            0.46                    34.2
#> 27            0.05            0.15            0.46                    34.2
#> 28            0.04            0.15            0.46                    34.2
#> 29            0.04            0.15            0.45                    34.2
#> 30            0.04            0.15            0.45                    34.2
#> 31            0.04            0.15            0.45                    34.2
#>    dly_prcp_pctall_ge010hi dly_prcp_pctall_ge025hi dly_prcp_pctall_ge050hi
#> 1                     22.1                    15.7                     9.7
#> 2                     22.0                    15.6                     9.6
#> 3                     21.9                    15.6                     9.5
#> 4                     21.8                    15.5                     9.4
#> 5                     21.6                    15.3                     9.4
#> 6                     21.5                    15.2                     9.3
#> 7                     21.4                    15.1                     9.2
#> 8                     21.3                    15.0                     9.2
#> 9                     21.2                    14.9                     9.1
#> 10                    21.1                    14.8                     9.0
#> 11                    21.1                    14.7                     8.9
#> 12                    21.0                    14.6                     8.9
#> 13                    20.9                    14.5                     8.8
#> 14                    20.9                    14.4                     8.7
#> 15                    20.8                    14.3                     8.6
#> 16                    20.8                    14.3                     8.6
#> 17                    20.7                    14.2                     8.5
#> 18                    20.7                    14.2                     8.4
#> 19                    20.6                    14.1                     8.4
#> 20                    20.5                    14.0                     8.3
#> 21                    20.4                    13.9                     8.2
#> 22                    20.4                    13.8                     8.2
#> 23                    20.3                    13.8                     8.1
#> 24                    20.3                    13.7                     8.1
#> 25                    20.2                    13.6                     8.0
#> 26                    20.1                    13.5                     7.9
#> 27                    20.1                    13.4                     7.9
#> 28                    20.0                    13.3                     7.8
#> 29                    20.0                    13.2                     7.8
#> 30                    20.0                    13.1                     7.7
#> 31                    20.0                    13.1                     7.7
#>    dly_prcp_pctall_ge100hi dly_prcp_pctall_ge200hi dly_prcp_pctall_ge400hi
#> 1                      3.4                     0.3                       0
#> 2                      3.4                     0.3                       0
#> 3                      3.4                     0.3                       0
#> 4                      3.3                     0.3                       0
#> 5                      3.3                     0.3                       0
#> 6                      3.3                     0.3                       0
#> 7                      3.3                     0.3                       0
#> 8                      3.2                     0.3                       0
#> 9                      3.2                     0.3                       0
#> 10                     3.2                     0.3                       0
#> 11                     3.2                     0.3                       0
#> 12                     3.2                     0.3                       0
#> 13                     3.2                     0.3                       0
#> 14                     3.2                     0.3                       0
#> 15                     3.2                     0.3                       0
#> 16                     3.2                     0.3                       0
#> 17                     3.2                     0.4                       0
#> 18                     3.2                     0.4                       0
#> 19                     3.2                     0.4                       0
#> 20                     3.2                     0.4                       0
#> 21                     3.2                     0.4                       0
#> 22                     3.3                     0.4                       0
#> 23                     3.3                     0.4                       0
#> 24                     3.3                     0.3                       0
#> 25                     3.3                     0.3                       0
#> 26                     3.2                     0.3                       0
#> 27                     3.2                     0.3                       0
#> 28                     3.2                     0.3                       0
#> 29                     3.2                     0.3                       0
#> 30                     3.2                     0.3                       0
#> 31                     3.2                     0.2                       0
#>    dly_prcp_pctall_ge600hi dly_snow_25pctl dly_snow_50pctl dly_snow_75pctl
#> 1                        0         -9999.0         -9999.0         -9999.0
#> 2                        0         -9999.0         -9999.0         -9999.0
#> 3                        0         -9999.0         -9999.0         -9999.0
#> 4                        0         -9999.0         -9999.0         -9999.0
#> 5                        0         -9999.0         -9999.0         -9999.0
#> 6                        0         -9999.0         -9999.0         -9999.0
#> 7                        0             0.5             1.0             3.0
#> 8                        0             0.5             1.0             3.0
#> 9                        0             0.5             1.0             3.0
#> 10                       0             0.5             1.0             3.0
#> 11                       0             0.5             1.0             3.0
#> 12                       0             0.5             1.0             3.1
#> 13                       0             0.5             1.0             3.1
#> 14                       0             0.5             1.0             3.1
#> 15                       0             0.5             1.0             3.1
#> 16                       0             0.5             1.0             3.2
#> 17                       0             0.5             1.0             3.2
#> 18                       0             0.5             1.0             3.3
#> 19                       0             0.5             1.0             3.3
#> 20                       0             0.5             1.1             3.3
#> 21                       0             0.5             1.1             3.4
#> 22                       0             0.5             1.1             3.4
#> 23                       0             0.5             1.1             3.5
#> 24                       0             0.5             1.1             3.5
#> 25                       0             0.5             1.1             3.6
#> 26                       0             0.5             1.2             3.6
#> 27                       0             0.5             1.2             3.6
#> 28                       0             0.5             1.2             3.7
#> 29                       0             0.6             1.2             3.7
#> 30                       0             0.6             1.2             3.7
#> 31                       0             0.6             1.2             3.8
#>    dly_snow_pctall_ge001ti dly_snow_pctall_ge010ti dly_snow_pctall_ge020ti
#> 1                      9.0                     5.0                     3.1
#> 2                      9.1                     5.1                     3.2
#> 3                      9.3                     5.2                     3.3
#> 4                      9.5                     5.3                     3.3
#> 5                      9.7                     5.4                     3.4
#> 6                      9.9                     5.5                     3.5
#> 7                     10.1                     5.7                     3.6
#> 8                     10.3                     5.8                     3.6
#> 9                     10.4                     5.9                     3.7
#> 10                    10.6                     6.0                     3.8
#> 11                    10.7                     6.1                     3.9
#> 12                    10.9                     6.2                     4.0
#> 13                    11.0                     6.2                     4.0
#> 14                    11.2                     6.3                     4.1
#> 15                    11.3                     6.5                     4.2
#> 16                    11.5                     6.6                     4.2
#> 17                    11.6                     6.7                     4.3
#> 18                    11.8                     6.8                     4.4
#> 19                    11.9                     7.0                     4.5
#> 20                    12.1                     7.1                     4.6
#> 21                    12.2                     7.2                     4.7
#> 22                    12.2                     7.3                     4.7
#> 23                    12.3                     7.4                     4.8
#> 24                    12.4                     7.5                     4.8
#> 25                    12.4                     7.6                     4.9
#> 26                    12.5                     7.7                     4.9
#> 27                    12.5                     7.7                     5.0
#> 28                    12.5                     7.8                     5.0
#> 29                    12.5                     7.8                     5.0
#> 30                    12.5                     7.8                     5.0
#> 31                    12.5                     7.8                     5.1
#>    dly_snow_pctall_ge030ti dly_snow_pctall_ge040ti dly_snow_pctall_ge050ti
#> 1                      2.3                     1.7                     1.5
#> 2                      2.4                     1.7                     1.5
#> 3                      2.4                     1.7                     1.5
#> 4                      2.4                     1.8                     1.5
#> 5                      2.5                     1.8                     1.5
#> 6                      2.5                     1.8                     1.5
#> 7                      2.6                     1.9                     1.6
#> 8                      2.6                     1.9                     1.6
#> 9                      2.7                     2.0                     1.6
#> 10                     2.7                     2.0                     1.6
#> 11                     2.8                     2.0                     1.6
#> 12                     2.8                     2.1                     1.7
#> 13                     2.9                     2.1                     1.7
#> 14                     2.9                     2.2                     1.7
#> 15                     3.0                     2.2                     1.8
#> 16                     3.1                     2.3                     1.8
#> 17                     3.1                     2.4                     1.9
#> 18                     3.2                     2.4                     1.9
#> 19                     3.3                     2.5                     2.0
#> 20                     3.4                     2.6                     2.0
#> 21                     3.5                     2.7                     2.1
#> 22                     3.6                     2.8                     2.1
#> 23                     3.6                     2.8                     2.2
#> 24                     3.7                     2.9                     2.2
#> 25                     3.8                     3.0                     2.2
#> 26                     3.8                     3.0                     2.3
#> 27                     3.9                     3.0                     2.3
#> 28                     3.9                     3.1                     2.3
#> 29                     3.9                     3.1                     2.3
#> 30                     3.9                     3.1                     2.4
#> 31                     4.0                     3.1                     2.4
#>    dly_snow_pctall_ge100ti dly_snow_pctall_ge200ti dly_snwd_25pctl
#> 1                      0.4                     0.0               2
#> 2                      0.4                     0.0               2
#> 3                      0.4                     0.0               2
#> 4                      0.4                     0.0               2
#> 5                      0.4                     0.0               2
#> 6                      0.4                     0.0               2
#> 7                      0.4                     0.1               2
#> 8                      0.4                     0.1               2
#> 9                      0.4                     0.1               2
#> 10                     0.4                     0.1               2
#> 11                     0.4                     0.1               2
#> 12                     0.4                     0.1               2
#> 13                     0.4                     0.1               2
#> 14                     0.5                     0.1               2
#> 15                     0.5                     0.1               2
#> 16                     0.5                     0.1               2
#> 17                     0.5                     0.1               2
#> 18                     0.5                     0.1               2
#> 19                     0.5                     0.1               2
#> 20                     0.6                     0.1               2
#> 21                     0.6                     0.1               2
#> 22                     0.6                     0.1               2
#> 23                     0.6                     0.2               2
#> 24                     0.6                     0.2               2
#> 25                     0.6                     0.2               2
#> 26                     0.6                     0.2               2
#> 27                     0.6                     0.2               2
#> 28                     0.6                     0.2               2
#> 29                     0.6                     0.2               2
#> 30                     0.6                     0.2               2
#> 31                     0.6                     0.2               2
#>    dly_snwd_50pctl dly_snwd_75pctl dly_snwd_pctall_ge001wi
#> 1                3               6                    16.0
#> 2                3               6                    16.5
#> 3                3               6                    17.0
#> 4                3               6                    17.5
#> 5                3               6                    18.1
#> 6                3               6                    18.6
#> 7                3               6                    19.1
#> 8                3               6                    19.6
#> 9                3               6                    20.1
#> 10               3               6                    20.7
#> 11               3               6                    21.2
#> 12               3               6                    21.7
#> 13               4               6                    22.3
#> 14               4               6                    22.8
#> 15               4               6                    23.4
#> 16               4               6                    23.9
#> 17               4               6                    24.5
#> 18               4               7                    25.1
#> 19               4               7                    25.7
#> 20               4               7                    26.3
#> 21               4               7                    27.0
#> 22               4               7                    27.6
#> 23               4               7                    28.2
#> 24               4               7                    28.7
#> 25               5               7                    29.2
#> 26               5               7                    29.7
#> 27               5               8                    30.1
#> 28               5               8                    30.4
#> 29               5               8                    30.7
#> 30               5               8                    31.0
#> 31               5               8                    31.3
#>    dly_snwd_pctall_ge002wi dly_snwd_pctall_ge003wi dly_snwd_pctall_ge004wi
#> 1                     12.5                    10.0                     7.8
#> 2                     12.9                    10.3                     8.0
#> 3                     13.4                    10.6                     8.3
#> 4                     13.8                    10.9                     8.6
#> 5                     14.2                    11.1                     8.8
#> 6                     14.6                    11.4                     9.1
#> 7                     15.0                    11.7                     9.4
#> 8                     15.4                    12.0                     9.6
#> 9                     15.9                    12.3                     9.9
#> 10                    16.3                    12.6                    10.2
#> 11                    16.8                    13.0                    10.6
#> 12                    17.2                    13.3                    10.9
#> 13                    17.7                    13.7                    11.3
#> 14                    18.1                    14.0                    11.7
#> 15                    18.6                    14.4                    12.0
#> 16                    19.0                    14.8                    12.4
#> 17                    19.5                    15.2                    12.8
#> 18                    20.0                    15.6                    13.3
#> 19                    20.5                    16.0                    13.7
#> 20                    21.1                    16.5                    14.2
#> 21                    21.6                    16.9                    14.7
#> 22                    22.2                    17.4                    15.2
#> 23                    22.7                    17.8                    15.7
#> 24                    23.1                    18.2                    16.1
#> 25                    23.6                    18.7                    16.5
#> 26                    23.9                    19.0                    17.0
#> 27                    24.3                    19.4                    17.3
#> 28                    24.6                    19.7                    17.7
#> 29                    24.9                    20.0                    18.0
#> 30                    25.1                    20.3                    18.4
#> 31                    25.4                    20.5                    18.6
#>    dly_snwd_pctall_ge005wi dly_snwd_pctall_ge010wi dly_snwd_pctall_ge020wi
#> 1                      6.2                     1.3                     0.2
#> 2                      6.5                     1.4                     0.2
#> 3                      6.7                     1.4                     0.2
#> 4                      6.9                     1.5                     0.2
#> 5                      7.2                     1.5                     0.2
#> 6                      7.4                     1.6                     0.2
#> 7                      7.7                     1.7                     0.2
#> 8                      7.9                     1.8                     0.2
#> 9                      8.2                     1.9                     0.3
#> 10                     8.5                     1.9                     0.3
#> 11                     8.8                     2.0                     0.3
#> 12                     9.2                     2.2                     0.3
#> 13                     9.5                     2.3                     0.3
#> 14                     9.9                     2.4                     0.3
#> 15                    10.2                     2.6                     0.3
#> 16                    10.6                     2.7                     0.3
#> 17                    11.0                     2.9                     0.4
#> 18                    11.4                     3.1                     0.4
#> 19                    11.9                     3.3                     0.4
#> 20                    12.4                     3.5                     0.4
#> 21                    12.9                     3.7                     0.4
#> 22                    13.4                     4.0                     0.5
#> 23                    13.8                     4.2                     0.5
#> 24                    14.3                     4.4                     0.5
#> 25                    14.7                     4.7                     0.5
#> 26                    15.1                     4.9                     0.5
#> 27                    15.5                     5.1                     0.5
#> 28                    15.9                     5.3                     0.6
#> 29                    16.2                     5.5                     0.6
#> 30                    16.6                     5.7                     0.6
#> 31                    16.9                     5.9                     0.6
#>    dly_tavg_normal dly_tavg_stddev dly_tmax_normal dly_tmax_stddev
#> 1             35.2             9.4            40.6            10.0
#> 2             35.0             9.4            40.4            10.1
#> 3             34.8             9.5            40.3            10.1
#> 4             34.7             9.5            40.1            10.1
#> 5             34.5             9.5            40.0            10.2
#> 6             34.4             9.6            39.9            10.2
#> 7             34.2             9.6            39.7            10.2
#> 8             34.1             9.7            39.6            10.2
#> 9             33.9             9.7            39.5            10.2
#> 10            33.8             9.7            39.5            10.3
#> 11            33.7             9.7            39.4            10.3
#> 12            33.6             9.7            39.3            10.3
#> 13            33.5             9.7            39.2            10.3
#> 14            33.4             9.7            39.2            10.3
#> 15            33.4             9.7            39.2            10.3
#> 16            33.3             9.7            39.1            10.3
#> 17            33.3             9.7            39.1            10.3
#> 18            33.2             9.7            39.1            10.2
#> 19            33.2             9.7            39.1            10.2
#> 20            33.2             9.6            39.1            10.2
#> 21            33.1             9.6            39.1            10.2
#> 22            33.1             9.6            39.1            10.1
#> 23            33.2             9.5            39.2            10.1
#> 24            33.2             9.5            39.2            10.1
#> 25            33.2             9.4            39.3            10.0
#> 26            33.2             9.4            39.3            10.0
#> 27            33.3             9.4            39.4            10.0
#> 28            33.4             9.3            39.5             9.9
#> 29            33.4             9.3            39.6             9.9
#> 30            33.5             9.3            39.7             9.9
#> 31            33.6             9.2            39.8             9.8
#>    dly_tmin_normal dly_tmin_stddev mtd_prcp_normal mtd_snow_normal
#> 1             29.8             9.4            0.12             0.2
#> 2             29.6             9.5            0.24             0.4
#> 3             29.4             9.5            0.35             0.6
#> 4             29.2             9.6            0.48             0.8
#> 5             29.0             9.6            0.60             1.0
#> 6             28.9             9.7            0.73             1.2
#> 7             28.7             9.7            0.85             1.4
#> 8             28.5             9.8            0.96             1.6
#> 9             28.3             9.8            1.08             1.9
#> 10            28.2             9.9            1.20             2.2
#> 11            28.1             9.9            1.33             2.4
#> 12            27.9             9.9            1.45             2.7
#> 13            27.8             9.9            1.57             3.0
#> 14            27.7             9.9            1.69             3.3
#> 15            27.6             9.9            1.81             3.6
#> 16            27.5             9.9            1.93             3.9
#> 17            27.4             9.9            2.05             4.2
#> 18            27.3             9.9            2.16             4.5
#> 19            27.3             9.8            2.27             4.8
#> 20            27.2             9.8            2.39             5.1
#> 21            27.2             9.8            2.50             5.4
#> 22            27.2             9.7            2.62             5.7
#> 23            27.1             9.7            2.73             6.0
#> 24            27.1             9.7            2.85             6.3
#> 25            27.1             9.6            2.96             6.7
#> 26            27.2             9.6            3.07             7.0
#> 27            27.2             9.5            3.18             7.3
#> 28            27.2             9.5            3.29             7.7
#> 29            27.3             9.5            3.41             8.0
#> 30            27.3             9.4            3.52             8.4
#> 31            27.4             9.4            3.64             8.8
#>    ytd_prcp_normal ytd_snow_normal
#> 1             0.12             0.2
#> 2             0.24             0.4
#> 3             0.35             0.6
#> 4             0.48             0.8
#> 5             0.60             1.0
#> 6             0.73             1.2
#> 7             0.85             1.4
#> 8             0.96             1.6
#> 9             1.08             1.9
#> 10            1.20             2.2
#> 11            1.33             2.4
#> 12            1.45             2.7
#> 13            1.57             3.0
#> 14            1.69             3.3
#> 15            1.81             3.6
#> 16            1.93             3.9
#> 17            2.05             4.2
#> 18            2.16             4.5
#> 19            2.27             4.8
#> 20            2.39             5.1
#> 21            2.50             5.4
#> 22            2.62             5.7
#> 23            2.73             6.0
#> 24            2.85             6.3
#> 25            2.96             6.7
#> 26            3.07             7.0
#> 27            3.18             7.3
#> 28            3.29             7.7
#> 29            3.41             8.0
#> 30            3.52             8.4
#> 31            3.64             8.8
options(op)
# }
```
