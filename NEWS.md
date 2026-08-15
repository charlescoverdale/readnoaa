# readnoaa 0.2.0

## Bug fixes

* `noaa_normals()` works for all periods. `period = "annual"` requested
  `normals-annual-1991-2020`, which NCEI does not recognise; the annual
  normals are published as `normals-annualseasonal-1991-2020`.
  `period = "daily"` sent no date window, which that dataset requires. Both
  previously failed with HTTP 400 on every call, leaving `"monthly"` as the
  only period that worked. `period = "hourly"` has been added.

* Hourly datasets no longer lose their timestamps. `global-hourly` and
  `local-climatological-data` publish ISO 8601 timestamps, which the date
  parser did not recognise and silently converted to `NA`, discarding the
  time axis of every hourly request. These now return a `POSIXct` column
  in UTC.

* Station identifiers are no longer corrupted. Values were type-guessed on
  read, so ISD and GSOD identifiers with leading zeros lost them: Heathrow's
  `"03772099999"` became the number `3772099999`. All columns are now read as
  character and coerced explicitly.

* Requests for many stations no longer fail. The cache filename embedded the
  full station list, so a request for roughly fifteen or more stations
  exceeded the 255-character filename limit and aborted. Cache keys now use a
  readable prefix plus a digest, and stay within the limit for any request.

* Empty responses are no longer cached. A request whose window ran past what
  NCEI had published was written to the cache and served from there
  indefinitely, so the missing days never appeared even after NOAA published
  them. Responses with no observations are now never cached, and an empty
  result returns a zero-row data frame instead of raising an error.

* Missing elevations are `NA` rather than `-999.9`. The GHCN-Daily sentinel
  value was returned as though it were a real measurement for 4,619 stations.

* `noaa_stations(text = )` matches literally. The search string was passed
  straight to `grepl()` as a regular expression, so a name containing
  punctuation such as `"ST. LOUIS ("` raised an invalid-regex error, and
  metacharacters silently matched more than intended. Pass `regex = TRUE`
  for the old behaviour.

* API errors report what actually went wrong. A failed request reported only
  its status code, discarding the explanation NCEI returns in the response
  body, such as `boundingBox: A bounding box is required.`

* `list_datasets()` no longer advertises `noaa-global-surface-temperature`,
  which the data service rejects as an unsupported dataset. A `requires`
  column records the datasets that need a date window or a bounding box.

* Column names containing hyphens now use underscores rather than dots, so a
  normals column matches the code that was requested: `MLY-TAVG-NORMAL`
  returns as `mly_tavg_normal`.

* Retries now cover HTTP 500, 502, and 504 alongside 429 and 503.

## New features

* `noaa_coverage()` reports the first and last year of data for every
  element a station records, from the GHCN-Daily element inventory. This
  answers how current a station is before you request data from it, which
  matters because coverage varies from a few days for US stations to over a
  year for some international ones, and some listed stations stopped
  reporting years ago.

* `noaa_stations()` and `noaa_nearby()` accept `element` and `active_since`
  to return only stations that record a given variable, or that were still
  reporting in a given year.

* `cache_info()` lists cached responses with their size and age.

* All data functions accept `refresh` to bypass the cache for a single call.

## Cache behaviour

* Cached responses now expire. A request whose window reaches into the last
  five weeks is treated as provisional and expires after one day, because
  NCEI publishes recent observations with a lag and revises them; older
  windows expire after 30 days. Previously nothing ever expired, so a result
  fetched during the publication lag was served indefinitely. Configurable
  through `readnoaa.cache_days_recent` and `readnoaa.cache_days`.

* Cache writes are atomic, so an interrupted download cannot leave a
  truncated file that is later served as valid data.

## Other changes

* Requests that do not name `datatypes` now drop columns containing no data
  at all. An unfiltered `daily-summaries` request returned 152 columns of
  which around 130 were entirely empty. Pass `drop_empty = FALSE` to keep
  them.

* `list_datatypes()` reports what a station actually records, read from the
  element inventory, rather than the dataset's full column schema. It
  previously reported 149 codes for a station recording about 20. It also
  accepts `start_date` and `end_date` to show only elements recorded during a
  window, and no longer probes a hard-coded week in 2024.

* `noaa_stations()` and `noaa_nearby()` return the station metadata that was
  previously discarded when parsing: `state`, `gsn_flag`, `hcn_crn_flag`,
  and `wmo_id`.

* Multi-year daily requests union their column sets across chunks rather than
  assuming every year returns the same elements.

* `noaa_normals()` documents that the NCEI normals datasets are published in
  US customary units and ignore the `units` parameter.

* README station identifiers corrected. Five of the nine listed were wrong:
  `USW00014739` is Boston, not Chicago O'Hare (`USW00094846`); `UKW00035054`
  is West Malling, not Heathrow (`UKM00003772`); `UKE00105915` is Hampstead;
  `FRE00104898` does not exist (Paris-Montsouris is `FRM00007156`); and
  Sydney Observatory Hill stopped reporting in 2020.

# readnoaa 0.1.2

* Fixed edge case in CSV numeric coercion where columns with all-NA original
  values could be incorrectly converted.

# readnoaa 0.1.1

* Examples now cache to `tempdir()` instead of the user's home directory,
  fixing CRAN policy compliance for `\donttest` examples.
* Cache directory is now configurable via `options(readnoaa.cache_dir = ...)`.

# readnoaa 0.1.0

* Initial release.
* Daily, monthly, annual, and climate normals data retrieval.
* Generic fetcher for any NCEI dataset.
* Station discovery by location, bounding box, or text search.
* Local caching of downloaded data.
