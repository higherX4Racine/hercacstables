#' Hoist details about a Census data group from a list of strings to separate columns
#'
#' @param .metadata <data-frame> a table of metadata about Census API variables, e.g. `hercacstables::METADATA_ACS5$variables`
#' @param .group <chr> the code for the group, e.g. "B01001"
#' @param .fields <chr\[\]> names for the new columns, e.g. c("Sex", "Age")
#'
#' @return a new data frame with more columns
#' @export
#' @concept metadata
#'
#' @examples
#' hoist_table_metadata(METADATA_ACS5$variables, "B06002", c("Median age", "Place of birth"))
hoist_table_metadata <- function(.metadata, .group, .fields){
    .field_list <- .fields |>
        seq_along() |>
        rlang::set_names(.fields)
    .metadata |>
        dplyr::filter(.data$Group == .group) |>
        tidyr::hoist(.col = "Details", !!!.field_list)
}
