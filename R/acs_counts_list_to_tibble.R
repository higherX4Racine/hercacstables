#' Organize a list output from a JSON parser to a tibble of ACS counts data.
#'
#' @param .list A list produced by parsing a rectangular ACS json array
#' @param table_name The name of the ACS table
#'
#' @return A tibble of pivoted, R-friendly data, with sub-totals removed.

acs_counts_list_to_tibble <- function(.list, table_name) {
    .list %>%
        utils::tail(-1) %>%
        purrr::map(~ purrr::set_names(.x, as.character(.list[[1]]))) %>%
        dplyr::tibble() %>%
        tidyr::unnest_wider(".") %>%
        dplyr::select(!(dplyr::contains(table_name) &
                            dplyr::ends_with("A"))) %>%
        readr::type_convert() %>%
        acs_counts_pivot_longer(table_name) %>%
        invisible()
}
