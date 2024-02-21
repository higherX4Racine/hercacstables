## Copyright (C) 2023 by Higher Expectations for Racine County

#' Split a census query into fewer than 50 variables per query
#'
#' The census API complains if you have more than 50 variables per query.
#'
#' @param .x a tibble with a column called "Variable"
#' @param max_per_query defaults to 40
#' @param ... other arguments for "hercacstables::api_url"
#'
#' @return a list of JSON-formatted census replies.
#' @export
safe_api_query <- function(.x, max_per_query = 40, ...){
    split(
        .x$Variable,
        rep(LETTERS,
            each = max_per_query,
            length.out = nrow(.x))
    ) %>%
        purrr::map(
            api_url,
            ...
        ) %>%
        purrr::map(
            do_api_query
        )
}
