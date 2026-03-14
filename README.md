# readnoaa

[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**readnoaa** provides clean, tidy access to climate and weather data from [NOAA](https://www.noaa.gov/) (the National Oceanic and Atmospheric Administration) directly from R. No API key required.

## What is NOAA?

The National Oceanic and Atmospheric Administration is a US federal agency responsible for monitoring weather, oceans, and the atmosphere. Its [National Centers for Environmental Information (NCEI)](https://www.ncei.noaa.gov/) is the world's largest archive of weather and climate data, hosting observations from over 100,000 stations across 180 countries, with some records stretching back to the 1700s.

NCEI maintains the [Data Service API](https://www.ncei.noaa.gov/access/services/data/v1), which provides free, open access to this archive. Unlike many government data APIs, it requires no API key - you can start pulling data immediately. The API returns clean CSV with data current to approximately 2-3 days ago.

## Types of data

NOAA's archive covers a wide range of weather and climate variables. Daily observations include maximum and minimum temperature, precipitation, snowfall, snow depth, and wind speed. Monthly and annual summaries aggregate these into averages and totals. The data spans land-based weather stations, marine buoys, and airport observation sites worldwide.

Beyond current observations, NOAA publishes 30-year climate normals — statistical baselines calculated from the 1991-2020 period that represent "typical" weather for a given location. These are widely used in agriculture, energy, construction, and climate research to understand how current conditions compare to long-term averages. The archive also includes hourly observations, 15-minute precipitation data, and local climatological records for more specialised use cases.

## Why readnoaa?

The flagship R package for NOAA data, [rnoaa](https://github.com/ropensci/rnoaa) (~3,300 downloads/month at its peak), was archived from CRAN in February 2024 when NOAA deprecated its CDO v2 API. The planned rOpenSci replacement never materialised. The only remaining CRAN package ([noaa](https://cran.r-project.org/package=noaa), 3 functions, ~180 downloads/month) still targets the broken old API.

**readnoaa** fills this gap by targeting NOAA's current NCEI Data Service v1 API. It provides dedicated functions for the most common datasets (daily observations, monthly/annual summaries, climate normals) plus a generic fetcher for the full archive. Station discovery functions help you find stations by location or name.

## Installation

```r
# Install from GitHub
devtools::install_github("charlescoverdale/readnoaa")
```

## Quick start

### Daily temperature for Central Park, NYC

```r
library(readnoaa)

df <- noaa_daily("USW00094728", "2024-01-01", "2024-01-31",
                 datatypes = c("TMAX", "TMIN"))
head(df)
#>       station       date                          name tmax tmin
#>   USW00094728 2024-01-01 NEW YORK CITY CENTRAL PARK, NY  8.9  3.3
#>   USW00094728 2024-01-02 NEW YORK CITY CENTRAL PARK, NY  5.0 -1.1
#>   USW00094728 2024-01-03 NEW YORK CITY CENTRAL PARK, NY  2.8 -2.2
#>   ...
```

### Find stations near London

```r
stations <- noaa_nearby(51.5, -0.1, radius_km = 25)
head(stations)
#>        station                    name latitude longitude distance_km
#>   UKE00105915     LONDON WEATHER CENTRE   51.517    -0.117        1.4
#>   UKW00035054     HEATHROW             51.478    -0.449       24.1
#>   ...
```

### Monthly precipitation summary

```r
df <- noaa_monthly("USW00094728", "2024-01", "2024-12",
                   datatypes = c("PRCP"))
head(df)
#>       station       date                          name  prcp
#>   USW00094728 2024-01-01 NEW YORK CITY CENTRAL PARK, NY  87.6
#>   USW00094728 2024-02-01 NEW YORK CITY CENTRAL PARK, NY  55.4
#>   ...
```

### Climate normals

```r
normals <- noaa_normals("USW00094728", "monthly")
head(normals)
#>       station                          name  month  mly_tavg_normal  mly_prcp_normal
#>   USW00094728 NEW YORK CITY CENTRAL PARK, NY  01     1.2              86.4
#>   USW00094728 NEW YORK CITY CENTRAL PARK, NY  02     2.3              76.5
#>   ...
```

### Multiple stations in one call

```r
# Compare rainfall across three US cities
df <- noaa_monthly(c("USW00094728", "USW00023174", "USW00014739"),
                   "2024-01", "2024-12", datatypes = "PRCP")
head(df)
#>       station       date                               name  prcp
#>   USW00094728 2024-01-01 NEW YORK CITY CENTRAL PARK, NY US   87.6
#>   USW00023174 2024-01-01 LOS ANGELES INTL AP, CA US         52.3
#>   USW00014739 2024-01-01 CHICAGO OHARE INTL AP, IL US       44.2
#>   ...
```

### Annual temperature trends

```r
df <- noaa_annual("USW00094728", "2000-01-01", "2024-01-01",
                  datatypes = "TAVG")
head(df)
#>       station       date                          name  tavg
#>   USW00094728 2000-01-01 NEW YORK CITY CENTRAL PARK, NY  13.1
#>   USW00094728 2001-01-01 NEW YORK CITY CENTRAL PARK, NY  13.4
#>   ...
```

### Hourly data with the generic fetcher

```r
# noaa_get() can access any NCEI dataset, including those
# without a dedicated function
df <- noaa_get("global-hourly", station = "USW00094728",
               start_date = "2024-07-01", end_date = "2024-07-01")
```

## Finding stations

Every NOAA data request needs a station ID. There are two ways to find stations:

**1. Search by location** using `noaa_nearby()`:

```r
# Stations within 50 km of Sydney, Australia
noaa_nearby(-33.87, 151.21, radius_km = 50)
```

**2. Search by name or bounding box** using `noaa_stations()`:

```r
# Search by name
noaa_stations(text = "Heathrow")

# Search by bounding box (south, west, north, east)
noaa_stations(bbox = c(35, -120, 40, -115))
```

### Common station IDs

| Station | Location |
|---|---|
| `USW00094728` | New York City (Central Park) |
| `USW00023174` | Los Angeles International Airport |
| `USW00014739` | Chicago O'Hare |
| `UKE00105915` | London Weather Centre |
| `UKW00035054` | London Heathrow |
| `ASN00066062` | Sydney Observatory Hill |
| `JA000047662`  | Tokyo |
| `GME00111445` | Berlin-Tempelhof |
| `FRE00104898` | Paris-Montsouris |

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
| Normal temperature | `MLY-TAVG-NORMAL` | °C | `noaa_normals()` |
| Normal precipitation | `MLY-PRCP-NORMAL` | mm | `noaa_normals()` |

Use `list_datatypes()` to discover all available variables for a given dataset and station.

## Data quality flags

NCEI applies automated quality control checks to all observations, flagging approximately 0.3% of values. You can include these flags by setting `include_flags = TRUE`:

```r
df <- noaa_daily("USW00094728", "2024-01-01", "2024-01-31",
                 datatypes = c("TMAX", "TMIN"), include_flags = TRUE)
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
| `noaa_stations()` | Search for stations by bbox or text |
| `noaa_nearby()` | Find stations near a point |
| `list_datasets()` | Curated table of common datasets |
| `list_datatypes()` | Available data types for a dataset |
| `clear_cache()` | Clear local cache |

## Data sources

Daily observations come from the [Global Historical Climatology Network - Daily (GHCN-Daily)](https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily), which integrates data from over 100,000 stations across 180 countries. Monthly and annual summaries are derived from the Global Summary of the Month/Year datasets. Climate normals follow the [WMO guidelines](https://library.wmo.int/idurl/4/55797) for calculating 30-year averages.

## Licence and limitations

NOAA data is produced by the US federal government and is in the public domain. There are no restrictions on its use, redistribution, or modification.

The NCEI Data Service API is free and requires no API key, but it does enforce rate limits. This package automatically throttles requests and retries on rate-limit errors. Daily data requests spanning more than one year are automatically split into yearly chunks to avoid API timeouts. Data is typically available up to 2-3 days behind real time, and station coverage varies — some stations have gaps or limited variable availability. This package is not affiliated with or endorsed by NOAA.
