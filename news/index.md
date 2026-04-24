# Changelog

## readnoaa 0.1.2

- Fixed edge case in CSV numeric coercion where columns with all-NA
  original values could be incorrectly converted.

## readnoaa 0.1.1

CRAN release: 2026-03-19

- Examples now cache to
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) instead of the
  user’s home directory, fixing CRAN policy compliance for `\donttest`
  examples.
- Cache directory is now configurable via
  `options(readnoaa.cache_dir = ...)`.

## readnoaa 0.1.0

- Initial release.
- Daily, monthly, annual, and climate normals data retrieval.
- Generic fetcher for any NCEI dataset.
- Station discovery by location, bounding box, or text search.
- Local caching of downloaded data.
