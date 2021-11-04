#' Organize a list output from a JSON parser to a tibble of ACS groups data.
#'
#' @param .x A list that comes from parsing a rectangular ACS json array
#' @param detail_names The names of the table's grouping fields
#'
#' @return A tibble of pivoted, R-friendly metadata without annotation fields
acs_groups_list_to_tibble <- function(.x, detail_names = NULL) {
    Description <- NULL
    Variable <- NULL
    . <- NULL
    result <- .x %>%
        purrr::pluck(1) %>%
        dplyr::tibble() %>%
        dplyr::mutate(Variable = names(.)) %>%
        tidyr::unnest_wider(".") %>%
        dplyr::rename(Description = .data$label) %>%
        dplyr::select(.data$Description,
                      .data$Variable) %>%
        parse_acs_table_variable() %>%
        dplyr::filter(.data$`Statistic Type` == "E") %>%
        dplyr::mutate(Description = stringr::str_remove(.data$Description,
                                                        "Estimate!!")) %>%
        dplyr::select(.data$Table,
                      .data$Row,
                      .data$Description) %>%
        dplyr::relocate(.data$Table,
                        .data$Row,
                        .data$Description) %>%
        dplyr::arrange(.data$Table,
                       .data$Row)
    if (!is.null(detail_names)) {
        result <- result %>%
            tidyr::separate(
                .data$Description,
                into = detail_names,
                sep = "!!",
                extra = "merge",
                fill = "right",
                remove = FALSE
            ) %>%
            dplyr::mutate(dplyr::across(
                dplyr::all_of(detail_names),
                ~ stringr::str_remove_all(.x, ":")
            ))
    }
    invisible(result)
}
