test_that("list_datasets returns curated table", {
  df <- list_datasets()
  expect_s3_class(df, "data.frame")
  expect_named(df, c("dataset", "description", "frequency"))
  expect_true(nrow(df) > 0)
  expect_true("daily-summaries" %in% df$dataset)
  expect_true("global-summary-of-the-month" %in% df$dataset)
})

test_that("list_datatypes returns character vector", {
  skip_on_cran()
  skip_if_offline()

  types <- list_datatypes("daily-summaries", "USW00094728")
  expect_type(types, "character")
  expect_true(length(types) > 0)
})
