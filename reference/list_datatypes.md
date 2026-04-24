# List available data types for a dataset

Queries the NCEI API to discover what data types (variables) are
available for a given dataset and station. This makes a short data
request to identify available columns.

## Usage

``` r
list_datatypes(dataset, station, cache = TRUE)
```

## Arguments

- dataset:

  Character. Dataset identifier (e.g. `"daily-summaries"`).

- station:

  Character. A station ID to query.

- cache:

  Logical. Use cached data if available (default `TRUE`).

## Value

A character vector of available data type codes.

## See also

Other data access:
[`clear_cache()`](https://charlescoverdale.github.io/readnoaa/reference/clear_cache.md),
[`list_datasets()`](https://charlescoverdale.github.io/readnoaa/reference/list_datasets.md),
[`noaa_get()`](https://charlescoverdale.github.io/readnoaa/reference/noaa_get.md)

## Examples

``` r
# \donttest{
op <- options(readnoaa.cache_dir = tempdir())
list_datatypes("daily-summaries", "USW00094728")
#> ℹ Discovering data types for daily-summaries
#> ✔ Discovering data types for daily-summaries [572ms]
#> 
#>   [1] "ACMC"         "ACMH"         "ACSC"         "ACSH"         "ADPT"        
#>   [6] "ASLP"         "ASTP"         "AWBT"         "AWDR"         "AWND"        
#>  [11] "DAEV"         "DAPR"         "DASF"         "DATN"         "DATX"        
#>  [16] "DAWM"         "DWPR"         "EVAP"         "FMTM"         "FRGB"        
#>  [21] "FRGT"         "FRTH"         "GAHT"         "MDEV"         "MDPR"        
#>  [26] "MDSF"         "MDTN"         "MDTX"         "MDWM"         "MNPN"        
#>  [31] "MXPN"         "PGTM"         "PRCP"         "PSUN"         "RHAV"        
#>  [36] "RHMN"         "RHMX"         "SN01"         "SN02"         "SN03"        
#>  [41] "SN11"         "SN12"         "SN13"         "SN14"         "SN21"        
#>  [46] "SN22"         "SN23"         "SN31"         "SN32"         "SN33"        
#>  [51] "SN34"         "SN35"         "SN36"         "SN51"         "SN52"        
#>  [56] "SN53"         "SN54"         "SN55"         "SN56"         "SN57"        
#>  [61] "SN61"         "SN72"         "SN81"         "SN82"         "SN83"        
#>  [66] "SNOW"         "SNWD"         "SX01"         "SX02"         "SX03"        
#>  [71] "SX11"         "SX12"         "SX13"         "SX14"         "SX15"        
#>  [76] "SX17"         "SX21"         "SX22"         "SX23"         "SX31"        
#>  [81] "SX32"         "SX33"         "SX34"         "SX35"         "SX36"        
#>  [86] "SX51"         "SX52"         "SX53"         "SX54"         "SX55"        
#>  [91] "SX56"         "SX57"         "SX61"         "SX72"         "SX81"        
#>  [96] "SX82"         "SX83"         "TAVG"         "TAXN"         "THIC"        
#> [101] "TMAX"         "TMIN"         "TOBS"         "TSUN"         "WDF1"        
#> [106] "WDF2"         "WDF5"         "WDFG"         "WDFI"         "WDFM"        
#> [111] "WDMV"         "WESD"         "WESF"         "WSF1"         "WSF2"        
#> [116] "WSF5"         "WSFG"         "WSFI"         "WSFM"         "WT01"        
#> [121] "WT02"         "WT03"         "WT04"         "WT05"         "WT06"        
#> [126] "WT07"         "WT08"         "WT09"         "WT10"         "WT11"        
#> [131] "WT12"         "WT13"         "WT14"         "WT15"         "WT16"        
#> [136] "WT17"         "WT18"         "WT19"         "WT21"         "WT22"        
#> [141] "WV01"         "WV03"         "WV07"         "WV18"         "WV20"        
#> [146] "ALT"          "STATION_INFO" "STATION_NAME" "TIME"        
options(op)
# }
```
