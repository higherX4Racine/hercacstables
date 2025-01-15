#' Computes a remainder values from measures of some subgroups and one all-group
#'
#' @param .data_frame &lt;dataframe&gt; the input data
#' @param grouping_column &lt;chr&gt; the name of the column that defines the grouping
#' @param value_column &lt;chr&gt; the name of the column that holds the values
#' @param whole_name &lt;chr&gt; the level of the grouping that signifies the total
#' @param part_names &lt;chr\[\]&gt; the other levels of the grouping
#' @param remainder_name &lt;chr&gt; the new name for the difference between whole and parts
#'
#' @return a new data frame with the same number of columns but extra rows and a new group level
#' @export
subtract_parts_from_whole <- function(.data_frame,
                                      grouping_column,
                                      value_column,
                                      whole_name,
                                      part_names,
                                      remainder_name) {

    .other_cols <- setdiff(names(.data_frame),
                           c(grouping_column, value_column))

    .data_frame |>
        dplyr::summarize(
            "{value_column}" := sum(
                .data[[value_column]] *
                    dplyr::case_match(.data[[grouping_column]],
                                      whole_name ~ 1.0,
                                      part_names ~ -1.0,
                                      .default = 0.0),
                na.rm = TRUE
            ),
            "{grouping_column}" := remainder_name,
            .by = tidyselect::all_of(.other_cols)
        ) |>
        dplyr::bind_rows(
            dplyr::semi_join(
                .data_frame,
                tibble::tibble("{grouping_column}" := c(whole_name, part_names)),
                by = grouping_column
            )
        ) |>
        dplyr::arrange(
            dplyr::across(tidyselect::all_of(c(.other_cols, grouping_column)))
        )

}
