#' Pull apart the lists of details for one group of ACS data
#'
#' @param .group the code of the group, like "B25043" or "C15010B"
#'
#' @return a tibble with at least 4 columns, like [hercacstables::GLOSSARY_OF_ACS_VARIABLES], but `Details` is split into multiple columns with uppercase letter names.
#' @export
#'
#' @examples
#' unpack_group_details("B01002B")
#'
#' @seealso [GLOSSARY_OF_ACS_VARIABLES]
unpack_group_details <- function(.group) {
    hercacstables::GLOSSARY_OF_ACS_VARIABLES |>
        dplyr::filter(
            .data$Group == .group
        ) |>
        dplyr::mutate(
            Details = purrr::map(.data$Details,
                                 \(.d) tibble::tibble(
                                     Column = LETTERS[seq_along(.d)],
                                     Detail = .d
                                 )
            )
        ) |>
        tidyr::unnest(
            cols = "Details"
        ) |>
        tidyr::pivot_wider(
            names_from = "Column",
            values_from = "Detail",
            values_fill = ""
        )
}
