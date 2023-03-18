#' Coerce a ragged list to a tibble with some list columns
#'
#' @param .l the ragged list
#'
#' @return a tibble
#' @export
#'
#' @examples
#' rags <- list(One = list(A = 1:2, B = "a"), Two = list(A = 1))
#' ragged_list_to_tibble(rags)
ragged_list_to_tibble <- function(.l) {
    .l %>%
        purrr::map_dfr(
            ~ tibble::as_tibble(
                purrr::map(., list)
            ),
            .id = "id"
        ) %>%
        dplyr::mutate(
            dplyr::across(where(is.list),
                          .fns = ~ purrr::map(., unlist)),
            dplyr::across(where(~ all(purrr::map_lgl(., ~ length(.) == 1))),
                          unlist))
}
