test_that("no error checking on this one", {
    expect_equal(
        build_for_geographies("tract",
                              state = 55,
                              county = 101,
                              foo = "",
                              barf = NULL,
                              "HOO"),
        "tract:55,101,,,HOO"
    )
})

test_that("a single input works", {
    expect_equal(
        build_for_geographies("state"),
        "state:*"
    )
})
