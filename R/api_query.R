# Copyright (C) 2022 by Higher Expectations for Racine County

.colonic <- function(...) {
    list(...) %>%
        purrr::imap(~ paste0("in=", .y, ":", .x)) %>%
        paste0(collapse = "&")
}


#' Construct the query part of the URL for a call to the US Census API
#'
#' @param variables a vector of variable names, like `"B01001_001E"`
#' @param for_geo the geographical level the data will describe, e.g. `"tract"`
#' @param for_items the specific instances of `for_geo` desired, e.g. `"*"` or `"000200"`
#' @param ... <[`dynamic dots`][rlang::dyn-dots]> other items to pass to the query
#' @param use_key optional, should the query include a Census API key from the system environment. Defaults to `TRUE`
#'
#' @return a string with the query part of a Census API call
#' @export
#'
#' @examples
#' api_query(paste0("B25003_00", 1:3, "E"),
#'                  "tract",
#'                  "*",
#'                  state = 55L,
#'                  county = 101L,
#'                  use_key = FALSE)
#'
#' api_query(paste0("P1_00", c(1, 3, 4), "N"),
#'                  "block%20group",
#'                  "*",
#'                  state = 55L,
#'                  county = 101L,
#'                  use_key = FALSE)
api_query <- function(variables,
                      for_geo,
                      for_items,
                      ...,
                      use_key = TRUE) {
    query <- glue::glue(
        paste0(variables, collapse = ","),
        "for={for_geo}:{paste0(for_items, collapse = ',')}",
        .colonic(...),
        .sep = "&"
    )

    if (use_key) {
        query <- glue::glue("{query}&key=",
                            Sys.getenv("CENSUS_API_KEY"))
    }

    query
}
