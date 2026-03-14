# readnoaa

[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**readnoaa** provides clean, tidy access to climate and weather data from [NOAA](https://www.noaa.gov/) (the National Oceanic and Atmospheric Administration) directly from R. No API key required.

## What is NOAA?

The National Oceanic and Atmospheric Administration is a US federal agency responsible for monitoring weather, oceans, and the atmosphere. Its [National Centers for Environmental Information (NCEI)](https://www.ncei.noaa.gov/) is the world's largest archive of weather and climate data, hosting observations from over 100,000 stations across 180 countries, with some records stretching back to the 1700s.

NCEI maintains the [Data Service API](https://www.ncei.noaa.gov/access/services/data/v1), which provides free, open access to this archive. Unlike many government data APIs, it requires no API key - you can start pulling data immediately. The API returns clean CSV with data current to approximately 2-3 days ago.

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


