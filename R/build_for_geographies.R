#' Use the `for` geography to specify the level that you are querying data for.
#'
#' @param for_geo E.g. "tract" or "county subdivision", if that's what you want.
#' @param ...  <[`dynamic-dots`][rlang::dyn-dots]> The specific items to search for, which will be all items if you leave them empty.
#'
#' @return a list with one element named `for` which is a "key:value" string
#' @keywords internal
#'
#' @examples
#' hercacstables:::build_for_geographies("block")
#' hercacstables:::build_for_geographies("tract", "000400", "000500")
build_for_geographies <- function(for_geo, ...){

    for_items = paste(..., sep = ",")
    if (length(for_items) == 0) {
        for_items = "*"
    }
    list(
        `for` = paste(for_geo, for_items, sep = ":")
    )
}
