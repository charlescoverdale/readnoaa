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
noaa_annual("USW00094728", "2020-01-01", "2024-01-01")
#> ℹ Fetching annual summaries
#> ✔ Fetching annual summaries [182ms]
#> 
#>       station                        name       date awnd  cdsd  cldd dp01 dp05
#> 1 USW00094728 NY CITY CENTRAL PARK, NY US 2020-01-01   NA 725.4 725.4  127   NA
#> 2 USW00094728 NY CITY CENTRAL PARK, NY US 2021-01-01   NA 716.6 716.6  140   NA
#> 3 USW00094728 NY CITY CENTRAL PARK, NY US 2022-01-01  2.4 749.6 749.6  122   NA
#> 4 USW00094728 NY CITY CENTRAL PARK, NY US 2023-01-01  2.1 671.6 671.6  123   NA
#> 5 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01  2.2 741.3 741.3  125   NA
#>   dp10 dp1x dsnd dsnw dt00 dt32 dx32 dx70 dx90 dyfg dyhf dyts  emnt emsd emsn
#> 1   83   10    9    3    0   41    6  147   20  153    8   27  -9.9  230  165
#> 2   85   12   24    6    0   58    8  158   17  145   13   30  -9.9  360  376
#> 3   85    9   11    4    0   74   18  157   25  129   15   25 -13.8  180  185
#> 4   84   15    2    0    0   28    1  152   12  143    9   34 -16.0   50   23
#> 5   78   11   18    5    0   50    8  164   21  121   13   23 -10.5   50   81
#>    emxp emxt evap fzf0 fzf1  fzf2  fzf3  fzf4 fzf5 fzf6 fzf7  fzf8  fzf9   hdsd
#> 1  64.5 35.6   NA  0.0 -4.3  -6.6    NA    NA -3.8 -3.8 -6.6  -9.9  -9.9 2407.0
#> 2 181.1 36.7   NA  0.0 -3.8    NA    NA    NA  0.0 -4.3 -4.9  -8.2  -9.9 2379.0
#> 3  47.0 36.1   NA -0.5 -2.7 -13.2 -13.2 -13.2 -1.6 -4.3 -4.9  -8.8 -11.0 2380.9
#> 4 139.2 33.9   NA -1.0 -2.7    NA    NA    NA -0.5 -4.9 -4.9 -16.0 -16.0 2165.2
#> 5  93.0 35.0   NA -1.0 -2.7  -7.1  -7.1 -10.5 -0.5 -4.9 -4.9  -7.7    NA 2168.1
#>   hn01 hn02 hn03 hn04 hn05 hn06 hn07 hn08 hn09 hn10 hn11 hn12 hn13 hn14 hn15
#> 1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>     htdd hx01 hx02 hx03 hx04 hx05 hx06 hx07 hx08 hx09 hx10 hx11 hx12 hx13 hx14
#> 1 2407.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2 2379.0   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3 2380.9   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4 2165.2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5 2168.1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   hx15 ln01 ln02 ln03 ln04 ln05 ln06 ln07 ln08 ln09 ln10 ln11 ln12 ln13 ln14
#> 1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   ln15 lx01 lx02 lx03 lx04 lx05 lx06 lx07 lx08 lx09 lx10 lx11 lx12 lx13 lx14
#> 1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   lx15 mn01 mn02 mn03 mn04 mn05 mn06 mn07 mn08 mn09 mn10 mn11 mn12 mn13 mn14
#> 1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   mn15 mnpn mx01 mx02 mx03 mx04 mx05 mx06 mx07 mx08 mx09 mx10 mx11 mx12 mx13
#> 1   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 2   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 3   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 4   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 5   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   mx14 mx15 mxpn   prcp psun snow tavg time tmax tmin tsun wdf1 wdf2 wdf5 wdfg
#> 1   NA   NA   NA 1152.8   NA  325 14.1   NA 17.9 10.2   NA   NA   NA   NA   NA
#> 2   NA   NA   NA 1518.2   NA  718 13.8   NA 17.6 10.0   NA   NA   NA   NA   NA
#> 3   NA   NA   NA 1175.8   NA  448 13.5   NA 17.6  9.4   NA   NA  240  270   NA
#> 4   NA   NA   NA 1506.6   NA   59 14.4   NA 18.2 10.5   NA   NA  310  210   NA
#> 5   NA   NA   NA 1178.0   NA  261 14.4   NA 18.3 10.5   NA   NA   60   40   NA
#>   wdfm wdmv wsf1 wsf2 wsf5 wsfg wsfm
#> 1   NA   NA   NA   NA   NA   NA   NA
#> 2   NA   NA   NA   NA   NA   NA   NA
#> 3   NA   NA   NA 13.0 21.9   NA   NA
#> 4   NA   NA   NA 13.0 30.4   NA   NA
#> 5   NA   NA   NA 14.8 26.4   NA   NA
options(op)
# }
```
