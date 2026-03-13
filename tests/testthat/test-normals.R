test_that("noaa_normals returns expected structure", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_normals("USW00094728", "monthly")

  expect_s3_class(df, "data.frame")
  expect_true("station" %in% names(df))
  expect_true(nrow(df) > 0)
})

test_that("noaa_normals validates period argument", {
  expect_error(noaa_normals("USW00094728", "weekly"), "should be one of")
})
