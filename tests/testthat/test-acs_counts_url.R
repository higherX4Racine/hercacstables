test_that("state data table api urls are correct", {
  url <- paste0("https://api.census.gov/",
                "data/2020/acs/acs5",
                "?get=group(C23002A)&for=county:*&in=state:55")
  expect_equal(acs_counts_url(2020, 5, "C23002A", 55), url)

})
