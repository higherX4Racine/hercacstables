#' Create the query part of a call to the Census's data API
#'
#' @inheritParams build_for_geographies
#' @param variables &lt;chr\[\]&gt; a vector of variable names, like `"B01001_001E"`
#' @param for_items &lt;chr\[\]&gt; one or more instances of `for_geo` desired, e.g. `"*"` or `"000200"`, passed on to [`build_for_geographies()`]
#' @param in_geos &lt;lst&gt; a list of key-value pairs to pass to [`build_in_geographies()`]
#' @param use_key &lt;lgl?&gt; optional, should the query include a Census API key from the system environment. Defaults to `TRUE`
#'
#' @returns a list of key-value pairs that can be converted into a URL query.
#' @keywords internal
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
                              key = api_key_value())
    }

    return(query_parameters)
}
