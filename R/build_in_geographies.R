#' Create the part of a Census API query that describes containing geographies
#'
#' @param ...  &lt;[`dynamic-dots`][rlang::dyn-dots]&gt; key-value pairs like "state='03'"
#'
#' @return A vector of "geo:code" pairs
#' @keywords internal
#'
#' @examples
#' hercacstables:::build_in_geographies(state=55, county = 101, barf=NULL)
#'
build_in_geographies <- function(...){
    .l <- list(...) |>
        purrr::discard(
            \(.) is.null(.) || is.na(.) || nchar(.) < 1
        ) |>
        purrr::keep_at(
            \(.) nchar(.) > 1
        )

    if (is.null(.l) || length(.l) == 0) {
        return(NULL)
    }

    paste0(names(.l), ":", .l)
}
