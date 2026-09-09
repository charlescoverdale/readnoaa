# readnoaa

[![CRAN status](https://www.r-pkg.org/badges/version/readnoaa)](https://CRAN.R-project.org/package=readnoaa) [![CRAN downloads](https://cranlogs.r-pkg.org/badges/readnoaa)](https://CRAN.R-project.org/package=readnoaa) [![Total Downloads](https://cranlogs.r-pkg.org/badges/grand-total/readnoaa)](https://CRAN.R-project.org/package=readnoaa) [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**readnoaa** provides clean, tidy access to climate and weather data from [NOAA](https://www.noaa.gov/) (the National Oceanic and Atmospheric Administration) directly from R. No API key required.

## What is NOAA?

The National Oceanic and Atmospheric Administration is a US federal agency responsible for monitoring weather, oceans, and the atmosphere. Its [National Centers for Environmental Information (NCEI)](https://www.ncei.noaa.gov/) is the world's largest archive of weather and climate data, hosting observations from over 100,000 stations across 180 countries, with some records stretching back to the 1700s.

NCEI maintains the [Data Service API](https://www.ncei.noaa.gov/support/access-data-service-api-user-documentation), which provides free, open access to this archive. Unlike many government data APIs, it requires no API key: you can start pulling data immediately.

## Types of data

NOAA's archive covers a wide range of weather and climate variables. Daily observations include maximum and minimum temperature, precipitation, snowfall, snow depth, and wind speed. Monthly and annual summaries aggregate these into averages and totals. The data spans land-based weather stations, marine buoys, and airport observation sites worldwide.

Beyond current observations, NOAA publishes 30-year climate normals: statistical baselines calculated from the 1991-2020 period that represent typical weather for a given location. These are widely used in agriculture, energy, construction, and climate research to understand how current conditions compare to long-term averages. The archive also includes hourly observations, precipitation data, and local climatological records for more specialised use cases.

## Why readnoaa?

The flagship R package for NOAA data, [rnoaa](https://github.com/ropensci/rnoaa) (~3,300 downloads/month at its peak), was archived from CRAN in February 2024 when NOAA deprecated its CDO v2 API. The planned rOpenSci replacement never materialised. The only remaining CRAN package ([noaa](https://cran.r-project.org/package=noaa), 3 functions, ~180 downloads/month) still targets the broken old API.

**readnoaa** fills this gap by targeting NOAA's current NCEI Data Service v1 API. It provides dedicated functions for the most common datasets (daily observations, monthly and annual summaries, climate normals) plus a generic fetcher for the full archive. Station discovery functions help you find stations by location or name, and check what they actually record.

## Installation

```r
install.packages("readnoaa")

# Or install the development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/readnoaa")
```

## Quick start

### Daily temperature for Central Park, NYC

```r
library(readnoaa)

df <- noaa_daily("USW00094728", "2024-01-01", "2024-01-31",
                 datatypes = c("TMAX", "TMIN"))
head(df, 4)
#>       station                        name       date tmax tmin
#> 1 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01  8.3  1.7
#> 2 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-02  5.6 -1.6
#> 3 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-03  6.1  1.1
#> 4 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-04  7.2 -2.1
```

### Find stations near London

```r
noaa_nearby(51.5, -0.1, radius_km = 40)
#>       station      name latitude longitude distance_km
#> 1 UKE00105915 HAMPSTEAD  51.5608    0.1789    20.44295
#> 2 UKM00003772  HEATHROW  51.4780   -0.4610    25.11402
#> 3 UKE00107650  HEATHROW  51.4789    0.4489    38.07617
```

Not every station in the list is still reporting. Add `element` and `active_since` to keep only those that currently record the variable you need:

```r
noaa_nearby(51.5, -0.1, radius_km = 40,
            element = "TMAX", active_since = 2025)
#>       station     name distance_km
#> 1 UKM00003772 HEATHROW    25.11402
#> 2 UKE00107650 HEATHROW    38.07617
```

### Monthly precipitation summary

```r
df <- noaa_monthly("USW00094728", "2024-01", "2024-12", datatypes = "PRCP")
head(df, 3)
#>       station                        name       date  prcp
#> 1 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01 134.1
#> 2 USW00094728 NY CITY CENTRAL PARK, NY US 2024-02-01  52.1
#> 3 USW00094728 NY CITY CENTRAL PARK, NY US 2024-03-01 230.3
```

### Climate normals

```r
noaa_normals("USW00094728", "monthly",
             datatypes = c("MLY-TAVG-NORMAL", "MLY-PRCP-NORMAL"))
#>       station                         name date month mly_prcp_normal mly_tavg_normal
#> 1 USW00094728 NEW YORK CNTRL PK TWR, NY US   01     1            92.5            33.7
#> 2 USW00094728 NEW YORK CNTRL PK TWR, NY US   02     2            81.0            35.9
#> 3 USW00094728 NEW YORK CNTRL PK TWR, NY US   03     3           109.0            42.8
```

Normals carry a climatological pseudo-date rather than a calendar date (`"01"` for a month, `"01-31"` for a day of the year), so integer `month`, `day`, and `hour` columns are added alongside for filtering and joining. Four periods are available: `"monthly"`, `"daily"`, `"hourly"`, and `"annual"`. The daily and hourly periods accept `start_date` and `end_date` to narrow the window.

Note that the NCEI normals datasets are published in US customary units (Fahrenheit and inches) and ignore the `units` argument, so unlike the observational functions there is no metric option.

### Multiple stations in one call

```r
df <- noaa_monthly(c("USW00094728", "USW00023174", "USW00094846"),
                   "2024-01", "2024-03", datatypes = "PRCP")
head(df, 4)
#>       station                                     name       date  prcp
#> 1 USW00023174 LOS ANGELES INTERNATIONAL AIRPORT, CA US 2024-01-01  49.6
#> 2 USW00023174 LOS ANGELES INTERNATIONAL AIRPORT, CA US 2024-02-01 254.7
#> 3 USW00023174 LOS ANGELES INTERNATIONAL AIRPORT, CA US 2024-03-01  83.5
#> 4 USW00094728              NY CITY CENTRAL PARK, NY US 2024-01-01 134.1
```

### Annual temperature trends

```r
df <- noaa_annual("USW00094728", "2020-01-01", "2024-01-01",
                  datatypes = "TAVG")
head(df, 3)
#>       station                        name       date tavg
#> 1 USW00094728 NY CITY CENTRAL PARK, NY US 2020-01-01 14.1
#> 2 USW00094728 NY CITY CENTRAL PARK, NY US 2021-01-01 13.8
#> 3 USW00094728 NY CITY CENTRAL PARK, NY US 2022-01-01 13.5
```

### Hourly data with the generic fetcher

`noaa_get()` reaches any NCEI dataset, including those without a dedicated function. Note that the hourly datasets use ISD station identifiers rather than the GHCN-Daily identifiers used elsewhere, and their `date` column is a `POSIXct` timestamp in UTC.

```r
df <- noaa_get("global-hourly", station = "72505394728",
               start_date = "2024-07-01", end_date = "2024-07-01",
               datatypes = c("TMP", "WND"))
head(df, 3)
#>       station                        name                date     tmp            wnd
#> 1 72505394728 NY CITY CENTRAL PARK, NY US 2024-07-01 00:04:00 +0228,5 999,9,C,0000,5
#> 2 72505394728 NY CITY CENTRAL PARK, NY US 2024-07-01 00:41:00 +0228,5 999,9,C,0000,5
#> 3 72505394728 NY CITY CENTRAL PARK, NY US 2024-07-01 00:49:00 +0230,5 999,9,V,0015,5
```

## Finding stations

Every NOAA data request needs a station ID. There are three ways to work with them.

**1. Search by location** using `noaa_nearby()`:

```r
noaa_nearby(-33.87, 151.21, radius_km = 30,
            element = "TMAX", active_since = 2025)
#>       station                           name distance_km
#> 1 ASN00066196 SYDNEY HARBOUR (WEDDING CAKE W    5.859814
#> 2 ASN00066037             SYDNEY AIRPORT AMO    9.162697
#> 3 ASN00066194      CANTERBURY RACECOURSE AWS    9.760497
#> 4 ASN00066124 PARRAMATTA NORTH (MASONS DRIVE   19.748268
```

**2. Search by name or bounding box** using `noaa_stations()`:

```r
noaa_stations(text = "Heathrow")
#>       station     name latitude longitude elevation wmo_id
#> 1 UKE00107650 HEATHROW  51.4789    0.4489      25.0   <NA>
#> 2 UKM00003772 HEATHROW  51.4780   -0.4610      25.3  03772

# Search by bounding box (south, west, north, east)
noaa_stations(bbox = c(35, -120, 40, -115))
```

Text is matched literally, so punctuation in a station name is safe. Pass `regex = TRUE` if you want a regular expression instead.

**3. Check what a station records** using `noaa_coverage()`:

```r
noaa_coverage("USW00094728", element = c("TMAX", "TMIN", "PRCP", "SNOW"))
#>       station element first_year last_year years
#> 1 USW00094728    PRCP       1869      2026   158
#> 2 USW00094728    SNOW       1869      2026   158
#> 3 USW00094728    TMAX       1869      2026   158
#> 4 USW00094728    TMIN       1869      2026   158
```

### How current is the data?

This is the question worth asking before any analysis. NCEI publishes US station data with a lag of only a few days, but coverage elsewhere varies enormously: some international stations lag by months, and others remain in the station list years after they stopped reporting. Sydney Observatory Hill (`ASN00066062`), for example, is still listed but its record ends in 2020.

`noaa_coverage()` reads NOAA's own element inventory and gives you the first and last year for every variable a station records, so you can check before requesting a window the station never covered.

### Common station IDs

| Station | Location |
|---|---|
| `USW00094728` | New York City (Central Park) |
| `USW00023174` | Los Angeles International Airport |
| `USW00094846` | Chicago O'Hare |
| `USW00014739` | Boston Logan |
| `UKM00003772` | London Heathrow |
| `ASN00066037` | Sydney Airport |
| `JA000047662` | Tokyo |
| `GME00111445` | Berlin-Tempelhof |
| `FRM00007156` | Paris-Montsouris |

## Common variables

| Variable | Code | Unit (metric) | Function |
|---|---|---|---|
| Maximum temperature | `TMAX` | °C | `noaa_daily()` |
| Minimum temperature | `TMIN` | °C | `noaa_daily()` |
| Precipitation | `PRCP` | mm | `noaa_daily()`, `noaa_monthly()` |
| Snowfall | `SNOW` | mm | `noaa_daily()` |
| Snow depth | `SNWD` | mm | `noaa_daily()` |
| Average temperature | `TAVG` | °C | `noaa_monthly()`, `noaa_annual()` |
| Wind speed | `AWND` | m/s | `noaa_daily()` |
| Normal temperature | `MLY-TAVG-NORMAL` | °F | `noaa_normals()` |
| Normal precipitation | `MLY-PRCP-NORMAL` | inches | `noaa_normals()` |

`list_datatypes()` reports what a particular station records, drawn from NOAA's element inventory rather than the dataset schema. Supply a date window to see only what it still records:

```r
list_datatypes("daily-summaries", "USW00094728")
#> 59 codes, covering the station's full record back to 1869

list_datatypes("daily-summaries", "USW00094728", start_date = "2025-01-01")
#>  [1] "AWND" "PGTM" "PRCP" "SNOW" "SNWD" "TMAX" "TMIN" "WDF2" "WDF5" "WSF2"
#> [11] "WSF5" "WT01" "WT02" "WT03" "WT04" "WT06" "WT08" "WT09"
```

By default, a request that does not name `datatypes` drops columns that hold no data at all, because an unfiltered `daily-summaries` request returns the whole GHCN-Daily element set as columns and few stations report more than a handful. Pass `drop_empty = FALSE` to keep them.

## Data quality flags

NCEI applies automated quality control checks to all observations, flagging approximately 0.3% of values. You can include these flags by setting `include_flags = TRUE`:

```r
noaa_daily("USW00094728", "2024-01-01", "2024-01-05",
           datatypes = "TMAX", include_flags = TRUE)
#>       station                        name       date tmax tmax_attributes
#> 1 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-01  8.3             ,,W
#> 2 USW00094728 NY CITY CENTRAL PARK, NY US 2024-01-02  5.6             ,,W
```

This adds attribute columns alongside each data column containing measurement and quality flag codes. Flags are useful for filtering suspect observations in research workflows.

To include station coordinates (latitude, longitude, elevation) with each observation, use `include_location = TRUE`.

## Functions

| Function | Description |
|---|---|
| `noaa_daily()` | Daily weather observations |
| `noaa_monthly()` | Monthly summaries |
| `noaa_annual()` | Annual summaries |
| `noaa_normals()` | 30-year climate normals (1991-2020) |
| `noaa_get()` | Generic fetcher for any NCEI dataset |
| `noaa_stations()` | Search for stations by bounding box or text |
| `noaa_nearby()` | Find stations near a point |
| `noaa_coverage()` | Which elements a station records, and for which years |
| `list_datasets()` | Curated table of common datasets |
| `list_datatypes()` | Data types a station records |
| `cache_info()` | Inspect the local cache |
| `clear_cache()` | Clear the local cache |

## Caching

Data is cached locally in `tools::R_user_dir("readnoaa", "cache")` on first download, and the location can be changed with `options(readnoaa.cache_dir = ...)`.

Cached responses expire, which matters because NCEI publishes recent observations with a lag and continues to revise them. A request whose window reaches into the last five weeks is treated as provisional and expires after a day; older windows are treated as settled and expire after 30 days. Both thresholds are configurable through `readnoaa.cache_days_recent` and `readnoaa.cache_days`.

Any single call can bypass the cache with `refresh = TRUE`, or skip it entirely with `cache = FALSE`. `cache_info()` lists what is currently stored along with its age, and `clear_cache()` empties it.

Responses that contain no observations are never cached, so a request made while NCEI is still publishing a window will not freeze that gap in place.

## Data sources

Daily observations come from the [Global Historical Climatology Network - Daily (GHCN-Daily)](https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily), which integrates data from over 100,000 stations across 180 countries. Monthly and annual summaries are derived from the Global Summary of the Month and Year datasets. Climate normals follow the WMO guidelines (WMO-No. 1203, *Guidelines on the Calculation of Climate Normals*) for calculating 30-year averages.

Station discovery uses the GHCN-Daily station list, and `noaa_coverage()` uses the GHCN-Daily element inventory. The inventory is around 36 MB, so it is downloaded only when a coverage-aware function needs it, and cached thereafter.

## Related packages

| Package | Description |
|---|---|
| [`climatekit`](https://github.com/charlescoverdale/climatekit) | Climate indices computed from weather data (frost days, degree days, SPI/SPEI drought, Huglin/Winkler, heat stress) |
| [`carbondata`](https://github.com/charlescoverdale/carbondata) | Carbon market data (EU/UK ETS, voluntary registries) |
| [`cer`](https://github.com/charlescoverdale/cer) | Clean Energy Regulator data (Australia) |

## Licence and limitations

NOAA data is produced by the US federal government and is in the public domain. There are no restrictions on its use, redistribution, or modification.

The NCEI Data Service API is free and requires no API key, but it does enforce rate limits. This package automatically throttles requests and retries on transient errors. Daily data requests spanning more than one year are automatically split into yearly chunks to avoid API timeouts.

Station coverage varies: some stations have gaps, some record only a few variables, and some stopped reporting years ago while remaining in the station list. Use `noaa_coverage()` to check before relying on a station. This package is not affiliated with or endorsed by NOAA.

## Issues

Please report bugs or requests at <https://github.com/charlescoverdale/readnoaa/issues>.

## Keywords

NOAA, weather data, climate data, NCEI, GHCN, temperature, precipitation, meteorology, environmental data, API, R package
