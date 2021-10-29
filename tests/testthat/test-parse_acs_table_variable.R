test_that("a 1x1 tibble parses into a 1x3 tibble", {
    foo <- dplyr::tibble(Variable = "A12345_678E")
    bar <- parse_acs_table_variable(foo)
    expect_identical(bar,
                     dplyr::tibble(
                         Table = "A12345",
                         Row = as.integer(678),
                         `Statistic Type` = "E"
                     ))
})
