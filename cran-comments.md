# CRAN submission comments — readnoaa 0.2.0

## Reason for this submission

This is a bug-fix and feature release for readnoaa 0.1.1, currently on CRAN.
Version 0.1.2 was prepared but never submitted, and its change is folded in
here.

The release repairs several code paths that failed against the live NCEI
API, and adds a function for checking station coverage.

Fixes:

* `noaa_normals()` failed with HTTP 400 for `period = "annual"` (wrong
  dataset identifier) and `period = "daily"` (the dataset requires a date
  window that was never sent). Only `"monthly"` worked. A `"hourly"` period
  has been added.
* The hourly datasets publish ISO 8601 timestamps, which the date parser did
  not recognise and silently converted to `NA`.
* Station identifiers were type-guessed on read, so ISD and GSOD identifiers
  lost their leading zeros.
* Cache filenames embedded the full station list, so requests naming roughly
  fifteen or more stations exceeded the filename length limit and aborted.
* Responses containing no observations were cached and served indefinitely.
  Cached responses now expire, and cache writes are atomic.
* The GHCN-Daily missing-elevation sentinel (`-999.9`) was returned as a
  real measurement.
* `noaa_stations(text = )` passed the search string to `grepl()` as a regular
  expression, so names containing punctuation raised an error.
* API errors reported only a status code, discarding the explanation NCEI
  returns in the response body.

New:

* `noaa_coverage()` reports the first and last year of data for each element
  a station records, from the GHCN-Daily element inventory.
* `cache_info()` lists cached responses with their size and age.
* `noaa_stations()` and `noaa_nearby()` gain `element` and `active_since`
  filters; all data functions gain `refresh`.

There are two changes in default output, both documented in NEWS.md: requests
that do not name `datatypes` now drop all-empty columns, and column names
containing hyphens use underscores rather than dots.

## Examples hardened against an unreachable the NCEI API

Every `\donttest{}` example that makes a network call is now wrapped in
`try()`, so a build machine that cannot reach the NCEI API gets a printed
condition rather than an example ERROR. 9 blocks were affected. The
`options(op)` cache restore stays outside the `try()` so it always runs.

I verified that every generated example still parses: each Rd file with
examples was extracted with `tools::Rd2ex(commentDonttest = FALSE)` and
passed to `parse()` without error.

## R CMD check results

0 errors | 0 warnings | 0 notes (CRAN default settings, R 4.5.2, macOS).

## Notes on data access

Unchanged: the package calls the NOAA NCEI API on demand (no key required)
and caches locally using `tools::R_user_dir()`. No data is bundled.
Network-using examples are wrapped in `\donttest{}` and tests in
`skip_on_cran()`, so the check does not depend on the API being reachable.

`noaa_coverage()` downloads an additional NCEI metadata file of around 36 MB.
This is fetched only when a coverage-aware function is called, never at load
time, and never during checks.

## Downstream dependencies

None on CRAN.
