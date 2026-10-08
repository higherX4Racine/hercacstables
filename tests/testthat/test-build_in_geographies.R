test_that("weird inputs are excluded", {
    expect_equal(
        build_in_geographies(state = 55,
                             county = 101,
                             foo = "",
                             barf = NULL,
                             "HOO"),
        c("state:55", "county:101")
    )
})

test_that("a single input works", {
    expect_equal(
        build_in_geographies(state = "03"),
        "state:03"
    )
})

test_that("an empty input yields an empty list", {
    expect_equal(
        build_in_geographies(),
        NULL
    )
})
