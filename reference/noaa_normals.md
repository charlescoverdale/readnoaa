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
(degrees Fahrenheit, inches) and ignore the API's `units` parameter, so
unlike the observational functions there is no metric option. Convert
after the fact if you need Celsius or millimetres.

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
#> ✔ Fetching monthly climate normals [495ms]
#> 
#> ℹ Fetching daily climate normals
#> ✔ Fetching daily climate normals [888ms]
#> 
#>        station                         name  date month day dly_cldd_base40
#> 1  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-01     1   1             1.0
#> 2  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-02     1   2             1.0
#> 3  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-03     1   3             1.0
#> 4  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-04     1   4             1.0
#> 5  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-05     1   5             1.0
#> 6  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-06     1   6             1.0
#> 7  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-07     1   7             1.0
#> 8  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-08     1   8             1.0
#> 9  USW00094728 NEW YORK CNTRL PK TWR, NY US 01-09     1   9             1.0
#> 10 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-10     1  10             1.0
#> 11 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-11     1  11             0.9
#> 12 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-12     1  12             0.9
#> 13 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-13     1  13             0.9
#> 14 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-14     1  14             0.9
#> 15 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-15     1  15             0.9
#> 16 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-16     1  16             0.8
#> 17 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-17     1  17             0.8
#> 18 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-18     1  18             0.8
#> 19 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-19     1  19             0.8
#> 20 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-20     1  20             0.8
#> 21 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-21     1  21             0.8
#> 22 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-22     1  22             0.8
#> 23 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-23     1  23             0.7
#> 24 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-24     1  24             0.7
#> 25 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-25     1  25             0.7
#> 26 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-26     1  26             0.7
#> 27 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-27     1  27             0.8
#> 28 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-28     1  28             0.8
#> 29 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-29     1  29             0.8
#> 30 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-30     1  30             0.8
#> 31 USW00094728 NEW YORK CNTRL PK TWR, NY US 01-31     1  31             0.8
#>    dly_cldd_base45 dly_cldd_base50 dly_cldd_base55 dly_cldd_base57
#> 1              0.4             0.1               0               0
#> 2              0.4             0.1               0               0
#> 3              0.4             0.1               0               0
#> 4              0.4             0.1               0               0
#> 5              0.4             0.1               0               0
#> 6              0.4             0.1               0               0
#> 7              0.4             0.1               0               0
#> 8              0.4             0.1               0               0
#> 9              0.4             0.1               0               0
#> 10             0.4             0.1               0               0
#> 11             0.4             0.1               0               0
#> 12             0.4             0.1               0               0
#> 13             0.3             0.1               0               0
#> 14             0.3             0.1               0               0
#> 15             0.3             0.1               0               0
#> 16             0.2             0.1               0               0
#> 17             0.2             0.1               0               0
#> 18             0.2             0.1               0               0
#> 19             0.2             0.1               0               0
#> 20             0.2             0.1               0               0
#> 21             0.2             0.1               0               0
#> 22             0.2             0.1               0               0
#> 23             0.2             0.1               0               0
#> 24             0.2             0.1               0               0
#> 25             0.2             0.1               0               0
#> 26             0.2             0.1               0               0
#> 27             0.2             0.1               0               0
#> 28             0.2             0.1               0               0
#> 29             0.3             0.1               0               0
#> 30             0.3             0.1               0               0
#> 31             0.3             0.1               0               0
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
#> 1            -11.8           -14.9             1.0             0.4
#> 2            -11.8           -14.9             1.0             0.4
#> 3            -11.8           -14.9             1.0             0.4
#> 4            -11.7           -14.9             1.0             0.4
#> 5            -11.7           -14.9             1.0             0.4
#> 6            -11.7           -14.9             1.0             0.4
#> 7            -11.6           -14.9             1.0             0.4
#> 8            -11.6           -14.9             1.0             0.4
#> 9            -11.6           -14.9             1.0             0.4
#> 10           -11.5           -14.8             1.0             0.4
#> 11           -11.5           -14.8             0.9             0.4
#> 12           -11.4           -14.8             0.9             0.4
#> 13           -11.4           -14.8             0.9             0.3
#> 14           -11.4           -14.8             0.9             0.3
#> 15           -11.3           -14.8             0.9             0.3
#> 16           -11.3           -14.8             0.8             0.2
#> 17           -11.3           -14.8             0.8             0.2
#> 18           -11.2           -14.8             0.8             0.2
#> 19           -11.2           -14.8             0.8             0.2
#> 20           -11.2           -14.8             0.8             0.2
#> 21           -11.2           -14.8             0.8             0.2
#> 22           -11.1           -14.8             0.8             0.2
#> 23           -11.1           -14.8             0.7             0.2
#> 24           -11.1           -14.8             0.7             0.2
#> 25           -11.1           -14.8             0.7             0.2
#> 26           -11.0           -14.8             0.7             0.2
#> 27           -11.0           -14.8             0.8             0.2
#> 28           -11.0           -14.8             0.8             0.2
#> 29           -10.9           -14.8             0.8             0.3
#> 30           -10.9           -14.8             0.8             0.3
#> 31           -10.9           -14.8             0.8             0.3
#>    dly_grdd_base50 dly_grdd_base55 dly_grdd_base57 dly_grdd_base60
#> 1              0.1               0               0               0
#> 2              0.1               0               0               0
#> 3              0.1               0               0               0
#> 4              0.1               0               0               0
#> 5              0.1               0               0               0
#> 6              0.1               0               0               0
#> 7              0.1               0               0               0
#> 8              0.1               0               0               0
#> 9              0.1               0               0               0
#> 10             0.1               0               0               0
#> 11             0.1               0               0               0
#> 12             0.1               0               0               0
#> 13             0.1               0               0               0
#> 14             0.1               0               0               0
#> 15             0.1               0               0               0
#> 16             0.1               0               0               0
#> 17             0.1               0               0               0
#> 18             0.1               0               0               0
#> 19             0.1               0               0               0
#> 20             0.1               0               0               0
#> 21             0.1               0               0               0
#> 22             0.1               0               0               0
#> 23             0.1               0               0               0
#> 24             0.1               0               0               0
#> 25             0.1               0               0               0
#> 26             0.1               0               0               0
#> 27             0.1               0               0               0
#> 28             0.1               0               0               0
#> 29             0.1               0               0               0
#> 30             0.1               0               0               0
#> 31             0.1               0               0               0
#>    dly_grdd_base65 dly_grdd_base70 dly_grdd_base72 dly_grdd_tb4886
#> 1                0               0               0             0.4
#> 2                0               0               0             0.4
#> 3                0               0               0             0.4
#> 4                0               0               0             0.4
#> 5                0               0               0             0.4
#> 6                0               0               0             0.4
#> 7                0               0               0             0.4
#> 8                0               0               0             0.5
#> 9                0               0               0             0.5
#> 10               0               0               0             0.5
#> 11               0               0               0             0.4
#> 12               0               0               0             0.4
#> 13               0               0               0             0.4
#> 14               0               0               0             0.4
#> 15               0               0               0             0.4
#> 16               0               0               0             0.4
#> 17               0               0               0             0.4
#> 18               0               0               0             0.4
#> 19               0               0               0             0.4
#> 20               0               0               0             0.4
#> 21               0               0               0             0.4
#> 22               0               0               0             0.3
#> 23               0               0               0             0.3
#> 24               0               0               0             0.3
#> 25               0               0               0             0.3
#> 26               0               0               0             0.3
#> 27               0               0               0             0.4
#> 28               0               0               0             0.4
#> 29               0               0               0             0.4
#> 30               0               0               0             0.4
#> 31               0               0               0             0.4
#>    dly_grdd_tb5086 dly_htdd_base40 dly_htdd_base45 dly_htdd_base50
#> 1              0.3             3.7             5.9             8.3
#> 2              0.3             3.8             6.0             8.4
#> 3              0.3             3.9             6.0             8.5
#> 4              0.3             4.0             6.1             8.6
#> 5              0.3             4.0             6.2             8.7
#> 6              0.3             4.2             6.3             8.8
#> 7              0.3             4.2             6.4             8.9
#> 8              0.4             4.3             6.5             8.9
#> 9              0.4             4.4             6.5             9.1
#> 10             0.4             4.4             6.6             9.1
#> 11             0.3             4.4             6.6             9.2
#> 12             0.3             4.4             6.7             9.2
#> 13             0.3             4.5             6.7             9.2
#> 14             0.3             4.5             6.7             9.3
#> 15             0.3             4.5             6.7             9.3
#> 16             0.3             4.5             6.7             9.3
#> 17             0.3             4.5             6.8             9.3
#> 18             0.3             4.5             6.8             9.4
#> 19             0.3             4.5             6.8             9.4
#> 20             0.3             4.5             6.8             9.4
#> 21             0.3             4.5             6.8             9.4
#> 22             0.3             4.5             6.8             9.4
#> 23             0.3             4.5             6.8             9.4
#> 24             0.3             4.5             6.8             9.4
#> 25             0.3             4.5             6.8             9.4
#> 26             0.3             4.5             6.7             9.3
#> 27             0.3             4.5             6.7             9.3
#> 28             0.3             4.4             6.7             9.3
#> 29             0.3             4.4             6.7             9.3
#> 30             0.3             4.4             6.6             9.2
#> 31             0.3             4.3             6.6             9.2
#>    dly_htdd_base55 dly_htdd_base57 dly_htdd_base60 dly_htdd_normal
#> 1             11.0            12.1            13.7            16.6
#> 2             11.1            12.2            13.8            16.7
#> 3             11.2            12.3            14.0            16.8
#> 4             11.3            12.4            14.0            16.9
#> 5             11.4            12.5            14.1            17.0
#> 6             11.5            12.6            14.2            17.0
#> 7             11.5            12.7            14.3            17.1
#> 8             11.6            12.7            14.3            17.2
#> 9             11.7            12.8            14.5            17.3
#> 10            11.8            12.9            14.5            17.4
#> 11            11.8            12.9            14.6            17.4
#> 12            11.9            13.0            14.6            17.5
#> 13            11.9            13.0            14.7            17.5
#> 14            12.0            13.1            14.7            17.6
#> 15            12.0            13.1            14.7            17.6
#> 16            12.0            13.2            14.8            17.6
#> 17            12.1            13.2            14.8            17.6
#> 18            12.1            13.2            14.8            17.7
#> 19            12.1            13.2            14.8            17.7
#> 20            12.1            13.2            14.8            17.7
#> 21            12.1            13.2            14.8            17.7
#> 22            12.1            13.3            14.8            17.7
#> 23            12.1            13.2            14.8            17.7
#> 24            12.1            13.2            14.8            17.7
#> 25            12.1            13.2            14.8            17.7
#> 26            12.1            13.2            14.8            17.6
#> 27            12.0            13.2            14.8            17.6
#> 28            12.0            13.1            14.7            17.6
#> 29            12.0            13.1            14.7            17.6
#> 30            11.9            13.0            14.7            17.5
#> 31            11.9            13.0            14.6            17.5
#>    dly_prcp_25pctl dly_prcp_50pctl dly_prcp_75pctl dly_prcp_pctall_ge001hi
#> 1              0.1             0.5             1.3                    35.8
#> 2              0.1             0.5             1.3                    35.7
#> 3              0.1             0.5             1.3                    35.6
#> 4              0.1             0.5             1.3                    35.5
#> 5              0.1             0.5             1.3                    35.5
#> 6              0.1             0.5             1.3                    35.5
#> 7              0.1             0.5             1.3                    35.4
#> 8              0.1             0.4             1.3                    35.3
#> 9              0.1             0.4             1.3                    35.3
#> 10             0.1             0.4             1.2                    35.2
#> 11             0.1             0.4             1.2                    35.2
#> 12             0.1             0.4             1.2                    35.1
#> 13             0.1             0.4             1.2                    35.0
#> 14             0.1             0.4             1.2                    35.0
#> 15             0.1             0.4             1.2                    34.9
#> 16             0.1             0.4             1.2                    34.8
#> 17             0.1             0.4             1.2                    34.8
#> 18             0.1             0.4             1.2                    34.7
#> 19             0.1             0.4             1.2                    34.6
#> 20             0.1             0.4             1.2                    34.5
#> 21             0.1             0.4             1.2                    34.4
#> 22             0.1             0.4             1.2                    34.3
#> 23             0.1             0.4             1.2                    34.3
#> 24             0.1             0.4             1.2                    34.2
#> 25             0.1             0.4             1.2                    34.2
#> 26             0.1             0.4             1.2                    34.2
#> 27             0.1             0.4             1.2                    34.2
#> 28             0.1             0.4             1.2                    34.2
#> 29             0.1             0.4             1.1                    34.2
#> 30             0.1             0.4             1.1                    34.2
#> 31             0.1             0.4             1.1                    34.2
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
#> 1                        0        -25397.5        -25397.5        -25397.5
#> 2                        0        -25397.5        -25397.5        -25397.5
#> 3                        0        -25397.5        -25397.5        -25397.5
#> 4                        0        -25397.5        -25397.5        -25397.5
#> 5                        0        -25397.5        -25397.5        -25397.5
#> 6                        0        -25397.5        -25397.5        -25397.5
#> 7                        0             1.3             2.5             7.6
#> 8                        0             1.3             2.5             7.6
#> 9                        0             1.3             2.5             7.6
#> 10                       0             1.3             2.5             7.6
#> 11                       0             1.3             2.5             7.6
#> 12                       0             1.3             2.5             7.9
#> 13                       0             1.3             2.5             7.9
#> 14                       0             1.3             2.5             7.9
#> 15                       0             1.3             2.5             7.9
#> 16                       0             1.3             2.5             8.1
#> 17                       0             1.3             2.5             8.1
#> 18                       0             1.3             2.5             8.4
#> 19                       0             1.3             2.5             8.4
#> 20                       0             1.3             2.8             8.4
#> 21                       0             1.3             2.8             8.6
#> 22                       0             1.3             2.8             8.6
#> 23                       0             1.3             2.8             8.9
#> 24                       0             1.3             2.8             8.9
#> 25                       0             1.3             2.8             9.1
#> 26                       0             1.3             3.0             9.1
#> 27                       0             1.3             3.0             9.1
#> 28                       0             1.3             3.0             9.4
#> 29                       0             1.5             3.0             9.4
#> 30                       0             1.5             3.0             9.4
#> 31                       0             1.5             3.0             9.7
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
#> 1                      0.4                     0.0             5.1
#> 2                      0.4                     0.0             5.1
#> 3                      0.4                     0.0             5.1
#> 4                      0.4                     0.0             5.1
#> 5                      0.4                     0.0             5.1
#> 6                      0.4                     0.0             5.1
#> 7                      0.4                     0.1             5.1
#> 8                      0.4                     0.1             5.1
#> 9                      0.4                     0.1             5.1
#> 10                     0.4                     0.1             5.1
#> 11                     0.4                     0.1             5.1
#> 12                     0.4                     0.1             5.1
#> 13                     0.4                     0.1             5.1
#> 14                     0.5                     0.1             5.1
#> 15                     0.5                     0.1             5.1
#> 16                     0.5                     0.1             5.1
#> 17                     0.5                     0.1             5.1
#> 18                     0.5                     0.1             5.1
#> 19                     0.5                     0.1             5.1
#> 20                     0.6                     0.1             5.1
#> 21                     0.6                     0.1             5.1
#> 22                     0.6                     0.1             5.1
#> 23                     0.6                     0.2             5.1
#> 24                     0.6                     0.2             5.1
#> 25                     0.6                     0.2             5.1
#> 26                     0.6                     0.2             5.1
#> 27                     0.6                     0.2             5.1
#> 28                     0.6                     0.2             5.1
#> 29                     0.6                     0.2             5.1
#> 30                     0.6                     0.2             5.1
#> 31                     0.6                     0.2             5.1
#>    dly_snwd_50pctl dly_snwd_75pctl dly_snwd_pctall_ge001wi
#> 1              7.6            15.2                    16.0
#> 2              7.6            15.2                    16.5
#> 3              7.6            15.2                    17.0
#> 4              7.6            15.2                    17.5
#> 5              7.6            15.2                    18.1
#> 6              7.6            15.2                    18.6
#> 7              7.6            15.2                    19.1
#> 8              7.6            15.2                    19.6
#> 9              7.6            15.2                    20.1
#> 10             7.6            15.2                    20.7
#> 11             7.6            15.2                    21.2
#> 12             7.6            15.2                    21.7
#> 13            10.2            15.2                    22.3
#> 14            10.2            15.2                    22.8
#> 15            10.2            15.2                    23.4
#> 16            10.2            15.2                    23.9
#> 17            10.2            15.2                    24.5
#> 18            10.2            17.8                    25.1
#> 19            10.2            17.8                    25.7
#> 20            10.2            17.8                    26.3
#> 21            10.2            17.8                    27.0
#> 22            10.2            17.8                    27.6
#> 23            10.2            17.8                    28.2
#> 24            10.2            17.8                    28.7
#> 25            12.7            17.8                    29.2
#> 26            12.7            17.8                    29.7
#> 27            12.7            20.3                    30.1
#> 28            12.7            20.3                    30.4
#> 29            12.7            20.3                    30.7
#> 30            12.7            20.3                    31.0
#> 31            12.7            20.3                    31.3
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
#> 1              1.8           -12.6             4.8           -12.2
#> 2              1.7           -12.6             4.7           -12.2
#> 3              1.6           -12.5             4.6           -12.2
#> 4              1.5           -12.5             4.5           -12.2
#> 5              1.4           -12.5             4.4           -12.1
#> 6              1.3           -12.4             4.4           -12.1
#> 7              1.2           -12.4             4.3           -12.1
#> 8              1.2           -12.4             4.2           -12.1
#> 9              1.1           -12.4             4.2           -12.1
#> 10             1.0           -12.4             4.2           -12.1
#> 11             0.9           -12.4             4.1           -12.1
#> 12             0.9           -12.4             4.1           -12.1
#> 13             0.8           -12.4             4.0           -12.1
#> 14             0.8           -12.4             4.0           -12.1
#> 15             0.8           -12.4             4.0           -12.1
#> 16             0.7           -12.4             3.9           -12.1
#> 17             0.7           -12.4             3.9           -12.1
#> 18             0.7           -12.4             3.9           -12.1
#> 19             0.7           -12.4             3.9           -12.1
#> 20             0.7           -12.4             3.9           -12.1
#> 21             0.6           -12.4             3.9           -12.1
#> 22             0.6           -12.4             3.9           -12.2
#> 23             0.7           -12.5             4.0           -12.2
#> 24             0.7           -12.5             4.0           -12.2
#> 25             0.7           -12.6             4.1           -12.2
#> 26             0.7           -12.6             4.1           -12.2
#> 27             0.7           -12.6             4.1           -12.2
#> 28             0.8           -12.6             4.2           -12.3
#> 29             0.8           -12.6             4.2           -12.3
#> 30             0.8           -12.6             4.3           -12.3
#> 31             0.9           -12.7             4.3           -12.3
#>    dly_tmin_normal dly_tmin_stddev mtd_prcp_normal mtd_snow_normal
#> 1             -1.2           -12.6             0.3             0.5
#> 2             -1.3           -12.5             0.6             1.0
#> 3             -1.4           -12.5             0.9             1.5
#> 4             -1.6           -12.4             1.2             2.0
#> 5             -1.7           -12.4             1.5             2.5
#> 6             -1.7           -12.4             1.9             3.0
#> 7             -1.8           -12.4             2.2             3.6
#> 8             -1.9           -12.3             2.4             4.1
#> 9             -2.1           -12.3             2.7             4.8
#> 10            -2.1           -12.3             3.0             5.6
#> 11            -2.2           -12.3             3.4             6.1
#> 12            -2.3           -12.3             3.7             6.9
#> 13            -2.3           -12.3             4.0             7.6
#> 14            -2.4           -12.3             4.3             8.4
#> 15            -2.4           -12.3             4.6             9.1
#> 16            -2.5           -12.3             4.9             9.9
#> 17            -2.6           -12.3             5.2            10.7
#> 18            -2.6           -12.3             5.5            11.4
#> 19            -2.6           -12.3             5.8            12.2
#> 20            -2.7           -12.3             6.1            13.0
#> 21            -2.7           -12.3             6.4            13.7
#> 22            -2.7           -12.4             6.7            14.5
#> 23            -2.7           -12.4             6.9            15.2
#> 24            -2.7           -12.4             7.2            16.0
#> 25            -2.7           -12.4             7.5            17.0
#> 26            -2.7           -12.4             7.8            17.8
#> 27            -2.7           -12.5             8.1            18.5
#> 28            -2.7           -12.5             8.4            19.6
#> 29            -2.6           -12.5             8.7            20.3
#> 30            -2.6           -12.6             8.9            21.3
#> 31            -2.6           -12.6             9.2            22.4
#>    ytd_prcp_normal ytd_snow_normal
#> 1              0.3             0.5
#> 2              0.6             1.0
#> 3              0.9             1.5
#> 4              1.2             2.0
#> 5              1.5             2.5
#> 6              1.9             3.0
#> 7              2.2             3.6
#> 8              2.4             4.1
#> 9              2.7             4.8
#> 10             3.0             5.6
#> 11             3.4             6.1
#> 12             3.7             6.9
#> 13             4.0             7.6
#> 14             4.3             8.4
#> 15             4.6             9.1
#> 16             4.9             9.9
#> 17             5.2            10.7
#> 18             5.5            11.4
#> 19             5.8            12.2
#> 20             6.1            13.0
#> 21             6.4            13.7
#> 22             6.7            14.5
#> 23             6.9            15.2
#> 24             7.2            16.0
#> 25             7.5            17.0
#> 26             7.8            17.8
#> 27             8.1            18.5
#> 28             8.4            19.6
#> 29             8.7            20.3
#> 30             8.9            21.3
#> 31             9.2            22.4
options(op)
# }
```
