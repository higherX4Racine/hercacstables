#' Convert a list of json objects from the census into a data frame
#'
#' @param .json_list the list of objects
#'
#' @return a [tibble::tibble()] with column names taken from the list
json_list_to_frame <- function(.json_list){
    .json_list |>
        tail(-1) |>
        purrr::list_transpose() |>
        rlang::set_names(
            as.character(.json_list[[1]])
        ) |>
        tibble::as_tibble() |>
        dplyr::mutate(
            dplyr::across(tidyselect::where(is.list),
                          ~ dplyr::na_if(as.character(.), "NULL"))
        )
}
