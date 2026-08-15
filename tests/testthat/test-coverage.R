test_that("noaa_coverage requires a station", {
  expect_error(noaa_coverage(), "at least one station")
  expect_error(noaa_coverage(character()), "at least one station")
})

test_that("noaa_coverage reports element spans", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_coverage"))
  on.exit(options(op))

  cov <- noaa_coverage("USW00094728", element = c("TMAX", "PRCP"))
  expect_s3_class(cov, "data.frame")
  expect_named(cov, c("station", "element", "first_year", "last_year", "years"))
  expect_setequal(cov$element, c("TMAX", "PRCP"))
  expect_true(all(cov$last_year >= cov$first_year))
  expect_equal(cov$years, cov$last_year - cov$first_year + 1L)
})

test_that("noaa_coverage distinguishes current from lapsed stations", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_coverage"))
  on.exit(options(op))

  cov <- noaa_coverage(c("USW00094728", "ASN00066062"), element = "TMAX")

  central_park <- cov$last_year[cov$station == "USW00094728"]
  sydney_obs   <- cov$last_year[cov$station == "ASN00066062"]

  # Central Park is maintained; Sydney Observatory Hill stopped years ago
  expect_gt(central_park, sydney_obs)
})

test_that("noaa_coverage warns about stations outside the daily inventory", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_coverage"))
  on.exit(options(op))

  expect_warning(noaa_coverage("not-a-station"), "No inventory entry")
})
