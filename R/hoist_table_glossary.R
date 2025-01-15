#' Hoist details about a Census data group from a list of strings to separate columns
#'
#' @param .glossary &lt;data-frame&gt; a table of glossary about Census API variables, e.g. [METADATA_FOR_ACS_VARIABLES]
#' @param .group &lt;chr&gt; the code for the group, e.g. "B01001"
#' @param .fields &lt;chr\[\]&gt; names for the new columns, e.g. c("Sex", "Age")
#'
#' @return a new data frame with more columns
#' @export
#' @concept glossary
#'
#' @examples
#' hoist_table_glossary(METADATA_FOR_ACS_VARIABLES, "B06002", c("Median age", "Place of birth"))
hoist_table_glossary <- function(.glossary, .group, .fields){
    .field_list <- .fields |>
        seq_along() |>
        rlang::set_names(.fields)
    .glossary |>
        dplyr::filter(.data$Group == .group) |>
        tidyr::hoist(.col = "Details", !!!.field_list)
}
