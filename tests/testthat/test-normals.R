test_that("noaa_normals rejects unknown periods", {
  expect_error(noaa_normals("USW00094728", "weekly"), "should be one of")
})

test_that("noaa_normals warns when dates are supplied for a full-year period", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_normals"))
  on.exit(options(op))

  expect_warning(
    noaa_normals("USW00094728", "monthly", start_date = "2020-01-01"),
    "ignored"
  )
})

test_that("each normals period maps to a live NCEI dataset", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_normals"))
  on.exit(options(op))

  monthly <- noaa_normals("USW00094728", "monthly")
  expect_s3_class(monthly, "data.frame")
  expect_equal(nrow(monthly), 12)
  expect_identical(monthly$month, 1:12)

  annual <- noaa_normals("USW00094728", "annual")
  expect_s3_class(annual, "data.frame")
  expect_gt(nrow(annual), 0)

  daily <- noaa_normals("USW00094728", "daily",
                        start_date = "2020-01-01", end_date = "2020-01-31")
  expect_equal(nrow(daily), 31)
  expect_identical(daily$month, rep(1L, 31))
  expect_identical(daily$day, 1:31)
})
