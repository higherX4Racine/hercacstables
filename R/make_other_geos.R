.modified_defaults <- function(original_names, ...){
    rlang::dots_list(
        !!!rlang::rep_named(original_names, "*"),
        ...,
        .homonyms = "last"
    )
}

.index_of <- function(.geography){
    if (is.integer(.geography)) {
        .geography <- sprintf("%03d",
                             .geography)
    }
    .geography <- stringr::str_to_lower(.geography)
    with(hercacstables::GEOGRAPHY_HIERARCHY_METADATA,
         dplyr::coalesce(
             match(.geography,
                   stringr::str_to_lower(Label)),
             match(.geography,
                   Code),
             match(.geography,
                   stringr::str_to_lower(Geography))
         )
    )
}

#' Possibly helpful function for creating a list of arguments for querying the Census API
#'
#' @param geography the name or numeric code of the target census geographic level
#' @param ... name-value pairs for specific containing geographies, e.g. `state = 55L`
#'
#' @return a list of geographic levels and values
#' @export
#'
#' @examples
#' all_racine_tracts <- make_other_geos("tract", state = 55L, county = 101L)
make_other_geos <- function(geography, ...){
    hercacstables::GEOGRAPHY_HIERARCHY_METADATA |>
        dplyr::pull(
            "Parent Geos"
        ) |>
        purrr::pluck(
            .index_of(geography)
        ) |>
        .modified_defaults(
            ...
        )
}
