#' Hoist details about a Census data group from a list of strings to separate columns
#'
#' @param .glossary <data-frame> a table of glossary about Census API variables, e.g. [GLOSSARY_OF_ACS_VARIABLES]
#' @param .group <chr> the code for the group, e.g. "B01001"
#' @param .fields <chr\[\]> names for the new columns, e.g. c("Sex", "Age")
#'
#' @return a new data frame with more columns
#' @export
#' @concept glossary
#'
#' @examples
#' hoist_table_glossary(GLOSSARY_OF_ACS_VARIABLES, "B06002", c("Median age", "Place of birth"))
hoist_table_glossary <- function(.glossary, .group, .fields){
    .field_list <- .fields |>
        seq_along() |>
        rlang::set_names(.fields)
    .glossary |>
        dplyr::filter(.data$Group == .group) |>
        tidyr::hoist(.col = "Details", !!!.field_list)
}
