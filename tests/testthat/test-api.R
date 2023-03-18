test_that("data and metadata file regexs are distinct", {
  expect_equal(
    make_census_file_regex("ABC", 123),
    "ACSABC123.*_data_with_overlays_.*\\.csv"
  )
  expect_equal(
    make_census_file_regex("ABC", 123, FALSE),
    "ACSABC123.*_data_with_overlays_.*\\.csv"
  )
  expect_equal(
    make_census_file_regex("ABC", 123, TRUE),
    "ACSABC123.*_metadata_.*\\.csv"
  )
})

test_that("api path components are built as expected", {
  expect_equal(
    url_for_year_and_type(2020, 5),
    "2020/acs/acs5"
  )
  expect_equal(
    query_for_table("C23002A"),
    "get=group(C23002A)"
  )
  expect_equal(
    query_all_counties_in_state(55),
    "&for=county:*&in=state:55"
  )
})
