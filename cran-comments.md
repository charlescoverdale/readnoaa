# CRAN submission comments — readnoaa 0.1.2

## Reason for this submission

This is a small bug-fix update to readnoaa 0.1.1, currently on CRAN.

CSV numeric coercion had an edge case where a column whose original
values were entirely `NA` could be converted incorrectly. Fixed, with a
regression test.

No API changes.

## R CMD check results

0 errors | 0 warnings | 0 notes (CRAN default settings, R 4.5.2, macOS).

## Notes on data access

Unchanged: the package calls the NOAA NCEI API on demand (no key
required) and caches locally using `tools::R_user_dir()`. No data is
bundled. Network-using examples are wrapped in `\donttest{}` and tests
in `skip_on_cran()`, so the check does not depend on the API being
reachable.

## Downstream dependencies

None on CRAN.
