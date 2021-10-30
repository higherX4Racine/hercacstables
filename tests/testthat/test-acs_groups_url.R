test_that("the groups url is what is expected", {
  expect_equal(acs_groups_url(2020, 5, "C23002A"),
               paste0("https://api.census.gov/data",
                      "/2020/acs/acs5/groups/C23002A.json"))
})
