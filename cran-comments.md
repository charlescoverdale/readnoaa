# CRAN submission comments: readnoaa 0.2.1

## This is a resubmission

0.2.0 was rejected by the incoming checks on 2026-09-08 for three problems,
all fixed here.

**A Windows-only test ERROR.** `write_cache()` closed its connection with
`on.exit()`, which registers against the enclosing function's frame rather
than the `tryCatch` block, so the handle was still open when `file.rename()`
ran. Unix renames an open file without complaint; Windows refuses, so every
cache write returned `FALSE` there. The connection is now closed before the
rename. This was invisible on macOS and only your Windows builder caught it,
which I am grateful for.

**A DESCRIPTION URL that answers HTTP 400.** It cited the bare NCEI Data
Service endpoint, which rejects a request carrying no query parameters. It
now points at the NCEI API user documentation. The endpoint the package
actually calls is unchanged.

**A dead README link.** `library.wmo.int` is unreachable and returned an
HTTP/2 protocol error. Replaced with a plain citation to WMO-No. 1203.

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
