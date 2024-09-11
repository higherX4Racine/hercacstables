test_that("weird inputs are excluded", {
    expect_equal(
        build_in_geographies(state = 55,
                             county = 101,
                             foo = "",
                             barf = NULL,
                             "HOO"),
        list(`in` = "state:55 county:101")
    )
})

test_that("a single input works", {
    expect_equal(
        build_in_geographies(state = "03"),
        list(`in` = "state:03")
    )
})

test_that("an empty input yields an empty list", {
    expect_equal(
        build_in_geographies(),
        list()
    )
})
