#' Use the `for` geography to specify the level that you are querying data for.
#'
#' @param for_geo &lt;chr&gt; the geographical level the data will describe, e.g. `"tract"`
#' @param ...  &lt;[`dynamic-dots`][rlang::dyn-dots]&gt; The specific items to search for, which will be all items if you leave them empty.
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
