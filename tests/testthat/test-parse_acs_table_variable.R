library(magrittr)


TABLE_NAME <- "A12345"
ROW        <- 678
STAT_TYPE  <- "E"
VARIABLE <- stringr::str_c(TABLE_NAME, "_", ROW, STAT_TYPE)

ONE_LINER <- dplyr::tibble(Variable = VARIABLE,
                           Foo = VARIABLE)

TEN_LINER <- dplyr::tibble(Index = 1:10) %>%
    mutate(
        Variable = stringr::str_c(
            TABLE_NAME,
            "_",
            stringr::str_pad(
                Index,
                width = 3,
                side = "left",
                pad = 0
            ),
            STAT_TYPE
        ),
        Foo = Variable
    )


test_that("a 1x1 data frame parses into a 1x3 data frame", {
    bar <- parse_acs_table_variable(ONE_LINER)

    expect_equal(bar$Table, TABLE_NAME)
    expect_equal(bar$Row, ROW)
    expect_equal(bar$`Statistic Type`, STAT_TYPE)
})


test_that("The second argument can be the 'Variable' column's name", {
    bar <- parse_acs_table_variable(ONE_LINER, "Foo")

    expect_equal(bar$Table, TABLE_NAME)
    expect_equal(bar$Row, ROW)
    expect_equal(bar$`Statistic Type`, STAT_TYPE)
})


test_that("The second argument works with magrittr's pipe operator", {
    bar <- ONE_LINER %>% parse_acs_table_variable()

    expect_equal(bar$Table, TABLE_NAME)
    expect_equal(bar$Row, ROW)
    expect_equal(bar$`Statistic Type`, STAT_TYPE)

    baz <- ONE_LINER %>%
        parse_acs_table_variable(Foo)

    expect_equal(baz$Table, TABLE_NAME)
    expect_equal(baz$Row, ROW)
    expect_equal(baz$`Statistic Type`, STAT_TYPE)
})


test_that("Multi-line tables work with defaults", {
    bar <- TEN_LINER %>% parse_acs_table_variable()
    expect_equal(bar$Table,
                 rep(TABLE_NAME,
                     nrow(TEN_LINER)))
    expect_equal(bar$Row,
                 1:nrow(TEN_LINER))
    expect_equal(bar$`Statistic Type`,
                 rep(STAT_TYPE,
                     nrow(TEN_LINER)))
})


test_that("Multi-line tables work with named columns", {
    for (name in c("Variable", "Foo")) {
        bar <- TEN_LINER %>% parse_acs_table_variable(name)
        expect_equal(bar$Table,
                     rep(TABLE_NAME,
                         nrow(TEN_LINER)))
        expect_equal(bar$Row,
                     1:nrow(TEN_LINER))
        expect_equal(bar$`Statistic Type`,
                     rep(STAT_TYPE,
                         nrow(TEN_LINER)))
    }

})


test_that("Multi-line tables work with named columns", {
    bar <- TEN_LINER %>% parse_acs_table_variable(Variable)
    expect_equal(bar$Table,
                 rep(TABLE_NAME,
                     nrow(TEN_LINER)))
    expect_equal(bar$Row,
                 1:nrow(TEN_LINER))
    expect_equal(bar$`Statistic Type`,
                 rep(STAT_TYPE,
                     nrow(TEN_LINER)))

    bar <- TEN_LINER %>% parse_acs_table_variable(Foo)
    expect_equal(bar$Table,
                 rep(TABLE_NAME,
                     nrow(TEN_LINER)))
    expect_equal(bar$Row,
                 1:nrow(TEN_LINER))
    expect_equal(bar$`Statistic Type`,
                 rep(STAT_TYPE,
                     nrow(TEN_LINER)))
})
