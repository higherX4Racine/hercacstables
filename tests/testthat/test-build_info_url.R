test_that("bad arguments cause errors", {
    expect_error(build_info_url("hi", 2020, 5))
})

test_that("good arguments give good urls", {
    expect_equal(
        build_info_url("geography", 2012, 3),
        glue::glue("{CENSUS_API_SCHEME}://{CENSUS_API_HOSTNAME}/",
                   "{CENSUS_API_PATHROOT}/2012/acs/acs3/geography.json",
                   "?key={Sys.getenv('CENSUS_API_KEY')}")
    )
})
