test_that("data and metadata file regexs are distinct", {
    expect_equal(make_census_file_regex("ABC", 123),
                 "ACSABC123.*_data_with_overlays_.*\\.csv")
    expect_equal(make_census_file_regex("ABC", 123, FALSE),
                 "ACSABC123.*_data_with_overlays_.*\\.csv")
    expect_equal(make_census_file_regex("ABC", 123, TRUE),
                 "ACSABC123.*_metadata_.*\\.csv")
})
