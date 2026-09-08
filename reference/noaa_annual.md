# Annual weather summaries

Returns annual summary data from the NCEI Global Summary of the Year
dataset.

## Usage

``` r
noaa_annual(
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

  Date. First day of the year.

- name:

  Character. Station name.

- ...:

  Numeric. Data columns vary by station and request.

## See also

Other weather data:
[`noaa_daily()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_daily.md),
[`noaa_monthly()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_monthly.md),
[`noaa_normals()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_normals.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
try({
  noaa_annual("USW00094728", "2020-01-01", "2024-01-01")
})
#> ℹ Fetching annual summaries
#> ✔ Fetching annual summaries [115ms]
#> 
#>       station                        name       date awnd  cdsd  cldd dp01 dp10
#> 1 USW00094728 NY CITY CENTRAL PARK, NY US 2020-01-01   NA 725.4 725.4  127   83
#> 2 USW00094728 NY CITY CENTRAL PARK, NY US 2021-01-01   NA 716.6 716.6  140   85
#> 3 USW00094728 NY CITY CENTRAL PARK, NY US 2022-01-01  2.4 749.6 749.6  122   85
#> 4 USW00094728 NY CITY CENTRAL PARK, NY US 2023-01-01  2.1 671.6 671.6  123   84
#> 5 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01  2.2 741.3 741.3  125   78
#>   dp1x dsnd dsnw dt00 dt32 dx32 dx70 dx90 dyfg dyhf dyts  emnt emsd emsn  emxp
#> 1   10    9    3    0   41    6  147   20  153    8   27  -9.9  230  165  64.5
#> 2   12   24    6    0   58    8  158   17  145   13   30  -9.9  360  376 181.1
#> 3    9   11    4    0   74   18  157   25  129   15   25 -13.8  180  185  47.0
#> 4   15    2    0    0   28    1  152   12  143    9   34 -16.0   50   23 139.2
#> 5   11   18    5    0   50    8  164   21  130   15   24 -10.5   50   81  93.0
#>   emxt fzf0 fzf1  fzf2  fzf3  fzf4 fzf5 fzf6 fzf7  fzf8  fzf9   hdsd   htdd
#> 1 35.6  0.0 -4.3  -6.6    NA    NA -3.8 -3.8 -6.6  -9.9  -9.9 2407.0 2407.0
#> 2 36.7  0.0 -3.8    NA    NA    NA  0.0 -4.3 -4.9  -8.2  -9.9 2379.0 2379.0
#> 3 36.1 -0.5 -2.7 -13.2 -13.2 -13.2 -1.6 -4.3 -4.9  -8.8 -11.0 2380.9 2380.9
#> 4 33.9 -1.0 -2.7    NA    NA    NA -0.5 -4.9 -4.9 -16.0 -16.0 2165.2 2165.2
#> 5 35.0 -1.0 -2.7  -7.1  -7.1 -10.5 -0.5 -4.9 -4.9  -7.7    NA 2168.1 2168.1
#>     prcp snow tavg tmax tmin wdf2 wdf5 wsf2 wsf5
#> 1 1152.8  325 14.1 17.9 10.2   NA   NA   NA   NA
#> 2 1518.2  718 13.8 17.6 10.0   NA   NA   NA   NA
#> 3 1175.8  448 13.5 17.6  9.4  240  270 13.0 21.9
#> 4 1506.6   59 14.4 18.2 10.5  310  210 13.0 30.4
#> 5 1178.0  261 14.4 18.3 10.5   60   40 14.8 26.4
options(op)
# }
```
