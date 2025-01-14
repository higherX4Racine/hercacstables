#' Create the part of a Census API query that describes containing geographies
#'
#' @param ...  &lt;[`dynamic-dots`][rlang::dyn-dots]&gt; key-value pairs like "state='03'"
#'
#' @return A string of ampersand-separated `in=geo:code` pairs
#' @keywords internal
#'
#' @examples
#' hercacstables:::build_in_geographies(state=55, county = 101, barf=NULL)
#'
build_in_geographies <- function(...){
    .l <- list(...) |>
        purrr::keep(
            ~ !(is.null(.) || is.na(.)) && nchar(.) > 0
        )

    if (length(.l) == 0) {
        return(list())
    }

    .l <- purrr::keep_at(.l, .l |> names() |> setdiff(""))

    .l |>
        names() |>
        paste0(":", .l, collapse = " ") |>
        list(`in` = _)
}
