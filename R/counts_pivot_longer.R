#' Split an ACS "Variable" value into three components
#'
#' @param .x A data frame with many variables that contain \code{table_name}
#' @param table_name The name of the ACS table that the data come from
#' @return A data frame where the "Variable" value has been split

counts_pivot_longer <- function(.x,
                                table_name) {
  .x |>
    tidyr::pivot_longer(dplyr::contains(table_name),
      names_to = "Variable",
      values_to = "Value"
    ) |>
    parse_acs_table_variable() |>
    tidyr::pivot_wider(
      names_from = "Statistic Type",
      values_from = "Value"
    )
}
