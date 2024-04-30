TABLE_NAME <- "A12345"
ROW <- 678
STAT_TYPE <- "E"
VARIABLE <- stringr::str_c(TABLE_NAME, "_", ROW, STAT_TYPE)

ONE_LINER <- dplyr::tibble(
  Variable = VARIABLE,
  Foo = VARIABLE
)


triple_test <- function(x, .list) {
  eval(bquote(expect_equal(.(x)$Table, TABLE_NAME)))
  eval(bquote(expect_equal(.(x)$Row, ROW)))
  eval(bquote(expect_equal(.(x)$`Statistic Type`, STAT_TYPE)))
}


test_that("a 1x1 data frame parses into a 1x3 data frame", {
  triple_test(parse_acs_table_variable(ONE_LINER))
})


test_that("The second argument can be the 'Variable' column's name", {
  triple_test(parse_acs_table_variable(ONE_LINER, "Foo"))
  triple_test(parse_acs_table_variable(ONE_LINER, "Variable"))
})


test_that("The second argument works with the pipe operator", {
  ONE_LINER |>
    parse_acs_table_variable() |>
    triple_test()
  ONE_LINER |>
    parse_acs_table_variable(Foo) |>
    triple_test()
  ONE_LINER |>
    parse_acs_table_variable(Variable) |>
    triple_test()
})


TEN_LINER <- dplyr::tibble(Index = 1:10) |>
  dplyr::mutate(
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


thirty_test <- function(x) {
  N <- nrow(TEN_LINER)
  eval(bquote(expect_equal(.(x)$Table, rep(TABLE_NAME, N))))
  eval(bquote(expect_equal(.(x)$Row, 1:N)))
  eval(bquote(expect_equal(
    .(x)$`Statistic Type`, rep(STAT_TYPE, N)
  )))
}


test_that("Multi-line tables work with defaults", {
  TEN_LINER |>
    parse_acs_table_variable() |>
    thirty_test()
})


test_that("Multi-line tables work with named columns", {
  TEN_LINER |>
    parse_acs_table_variable("Foo") |>
    thirty_test()
  TEN_LINER |>
    parse_acs_table_variable("Variable") |>
    thirty_test()
})


test_that("Multi-line tables work with rlang columns", {
  TEN_LINER |>
    parse_acs_table_variable(Foo) |>
    thirty_test()
  TEN_LINER |>
    parse_acs_table_variable(Variable) |>
    thirty_test()
})
