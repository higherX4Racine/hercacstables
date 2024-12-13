#' Pull apart the lists of details for one group of ACS data
#'
#' @param .group the code of the group, like "B25043" or "C15010B"
#'
#' @return a tibble with at least 4 columns, like [hercacstables::ACS_VARIABLE_METADATA], but `Details` is split into multiple columns with uppercase letter names.
#' @export
#'
#' @examples
#' unpack_group_details("B01002B")
#'
#' @seealso [ACS_VARIABLE_METADATA]
unpack_group_details <- function(.group) {
    hercacstables::ACS_VARIABLE_METADATA |>
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
