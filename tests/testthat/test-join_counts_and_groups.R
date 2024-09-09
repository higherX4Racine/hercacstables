test_that("A smooth joining is achieved", {
  require(dplyr)
  my_counts <- expand.grid(Table = LETTERS[1:3], Row = 1:3) |>
    mutate(N = 9:1)
  group_names <- c("Pochard", "Dabbler", "Sea Duck")
  my_groups <- tibble(
    Table = rep("A"),
    Row = 1:3,
    Group = group_names
  )
  result <- join_counts_and_groups(my_counts, my_groups)
  expect_identical(result$Group, group_names)
})
