build_query_parameters <- function(variables,
                                   for_geo,
                                   for_items = NULL,
                                   in_geos = NULL,
                                   use_key = FALSE) {
    query_parameters <- c(
        list(`get` = paste0(variables, collapse = ",")),
        rlang::inject(build_for_geographies(for_geo, !!!for_items)),
        rlang::inject(build_in_geographies(!!!in_geos))
    )

    if (use_key) {
        query_parameters <- c(query_parameters,
                              key = Sys.getenv("CENSUS_API_KEY"))
    }

    return(query_parameters)
}
