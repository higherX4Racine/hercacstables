#' Download metadata about the most recent versions of the 1- and 5-year ACS
#'
#' @param information_type &lt;chr&gt; "geographies", "groups", or "variables"
#'
#' @return a tibble with dimensions that depend upon `information_type`
#' @export
#' @concept metadata
latest_acs_metadata <- function(information_type) {
    rlang::arg_match(
        information_type,
        c("geography", "groups", "variables")
    )

    .this_year <- as.POSIXlt(Sys.Date())$year + 1900L

    .RAW_ACS_GROUP_METADATA <- tibble::tibble(
        .year_span = c(1L, 5L),
        .year = .this_year - c(1L, 2L),
        .info_type = information_type
    ) |>
        dplyr::mutate(
            Metadata = purrr::pmap(dplyr::pick(tidyselect::everything()),
                                   fetch_metadata_table),
            Dataset = paste0("ACS", .data$.year_span)
        ) |>
        dplyr::select(
            c("Dataset", "Metadata")
        ) |>
        tidyr::unnest(
            "Metadata"
        )
}
