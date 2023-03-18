test_that("bad arguments cause errors", {
  expect_error(info_url("hi", 2020, 5))
})

test_that("good arguments give good urls", {
  expect_equal(
    info_url("geography", 2012, 3),
    "https://api.census.gov/data/2012/acs/acs3/geography.json"
  )
})
