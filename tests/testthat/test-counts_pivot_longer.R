test_that("a raw ACS counts table gets tidy", {
  require(dplyr)
  raw_counts <- tibble(
    C23002A_001E = c(10, 10, 20, 30),
    C23002A_001M = c(1, 1, 2, 3),
    C23002A_001EA = c(NULL, NULL, NULL, NULL),
    C23002A_002E = c(1, 1, 2, 3),
    C23002A_002M = c(0, 0, 0, 0),
    C23002A_002EA = c(NULL, NULL, NULL, NULL),
    state = rep(55, 4),
    county = 100:103
  ) |> mutate(GEO_ID = paste0("US00", .data$state, .data$county))

  long_counts <- tribble(
    ~state, ~county, ~GEO_ID, ~Table, ~Row, ~E, ~M,
    55, 100, "US0055100", "C23002A", 1, 10, 1,
    55, 100, "US0055100", "C23002A", 2, 1, 0,
    55, 101, "US0055101", "C23002A", 1, 10, 1,
    55, 101, "US0055101", "C23002A", 2, 1, 0,
    55, 102, "US0055102", "C23002A", 1, 20, 2,
    55, 102, "US0055102", "C23002A", 2, 2, 0,
    55, 103, "US0055103", "C23002A", 1, 30, 3,
    55, 103, "US0055103", "C23002A", 2, 3, 0
  )

  expect_equal(
    raw_counts |> counts_pivot_longer("C23002A"),
    long_counts
  )
})
