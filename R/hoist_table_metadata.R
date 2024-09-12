hoist_table_metadata <- function(.metadata, .group, .fields){
    .field_list <- .fields |>
        seq_along() |>
        rlang::set_names(.fields)
    .metadata |>
        dplyr::filter(.data$Group == .group) |>
        tidyr::hoist(.col = "Details", !!!.field_list)
}
