#' Computes a remainder values from measures of some subgroups and one all-group
#'
#' @param .data_frame <dataframe> the input data
#' @param grouping_column <chr> the name of the column that defines the grouping
#' @param value_column <chr> the name of the column that holds the values
#' @param whole_name <chr> the level of the grouping that signifies the total
#' @param part_names <chr\[\]> the other levels of the grouping
#' @param remainder_name <chr> the new name for the difference between whole and parts
#'
#' @return a new data frame with the same number of columns but extra rows and a new group level
#' @export
subtract_parts_from_whole <- function(.data_frame,
                                      grouping_column,
                                      value_column,
                                      whole_name,
                                      part_names,
                                      remainder_name) {
    .data_frame |>
        tidyr::pivot_wider(
            names_from = tidyselect::all_of(grouping_column),
            values_from = tidyselect::all_of(value_column),
            values_fill = 0
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
            `e98baacc-91a8-4bb2-a6b5-248f9c231e29` = sum(
                dplyr::c_across(tidyselect::all_of(part_names))
            ),
            "{remainder_name}" := .data[[whole_name]] -
                .data$`e98baacc-91a8-4bb2-a6b5-248f9c231e29`
        ) |>
        dplyr::ungroup() |>
        dplyr::select(
            !tidyselect::any_of(c("e98baacc-91a8-4bb2-a6b5-248f9c231e29"))
        ) |>
        tidyr::pivot_longer(
            cols = tidyselect::all_of(c(part_names, remainder_name)),
            names_to = grouping_column,
            values_to = value_column
        )
}
