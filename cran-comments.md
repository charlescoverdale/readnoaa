# CRAN submission comments: readnoaa 0.2.2

## Reason for this submission

A bug-fix release. The NCEI normals endpoint applies metric units
inconsistently: it converts precipitation and some temperatures but not
others, and converts temperature ranges as if they were temperatures,
giving negative values. `noaa_normals()` asked for metric units while
documenting US customary units, so it returned a mix of millimetres,
Fahrenheit and Celsius, and some wrong values. It now requests standard
units, so every column matches the documentation. The
citation entry also reported a hard-coded version; it now reads the
installed one.

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
