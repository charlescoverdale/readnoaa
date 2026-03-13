test_that("noaa_get returns expected structure", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_get("daily-summaries", station = "USW00094728",
                 start_date = "2024-01-01", end_date = "2024-01-07",
                 datatypes = c("TMAX", "TMIN"))

  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})

test_that("noaa_get validates dates when provided", {
  expect_error(
    noaa_get("daily-summaries", station = "USW00094728",
             start_date = "bad"),
    "YYYY-MM-DD"
  )
})
