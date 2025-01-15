EXAMPLE_FRAME <- tibble::tribble(
    ~ Hello, ~ World,
    "A",     1,
    "B",     2,
    "C",     3
)

test_that("one-column searching works", {
    expect_equal(
        search_in_columns(EXAMPLE_FRAME,
                          Hello = "B"),
        EXAMPLE_FRAME[2,]
    )
    expect_equal(
        search_in_columns(EXAMPLE_FRAME,
                          World = "\\d"),
        EXAMPLE_FRAME
    )
})

test_that("searches are case-insensitive", {
    expect_equal(
        search_in_columns(EXAMPLE_FRAME,
                          Hello = "[ab]"),
        EXAMPLE_FRAME[1:2,]
    )
})

test_that("combined_searches_work", {
    expect_equal(
        search_in_columns(EXAMPLE_FRAME,
                          Hello = "[BC]",
                          World = "[12]"),
        EXAMPLE_FRAME[2,]
    )
})

test_that("unnamed arguments cause a failure", {
    expect_error(
        search_in_columns(EXAMPLE_FRAME, "\\w"),
        "Each array of search terms must have a name."
    )
})

test_that("negation works", {
    expect_equal(
        search_in_columns(EXAMPLE_FRAME,
                          `-Hello` = "A"),
        EXAMPLE_FRAME[2:3,]
    )
    expect_equal(
        search_in_columns(EXAMPLE_FRAME,
                          Hello = "\\w",
                          "-World" = "3"),
        EXAMPLE_FRAME[1:2,]
    )
})
