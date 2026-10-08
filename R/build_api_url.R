#' Create an API call to send to api.census.gov
#'
#' @param variables &lt;chr\[\]&gt; a vector of variable names, like `"B01001_001E"`
#' @param for_geo `<chr>` A Census geography like "us," "state," "tract," or "school district (unified)."
#' @param for_items &lt;chr\[\]&gt; one or more instances of `for_geo` desired, e.g. `"*"` or `"000200"`, passed on to [`build_for_geographies()`]
#' @param survey_type e.g. "acs" or "dec"
#' @param table_or_survey_code e.g. "acs5" or "pl"
#' @param year an integer year, e.g. `2021L`
#' @param ... &lt;[`dynamic dots`][rlang::dyn-dots]&gt; list of key-value pairs to pass to [`build_in_geographies()`]
#' @param use_key &lt;lgl?&gt; optional, should the query include a Census API key from the system environment. Defaults to `TRUE`
#'
#' @return one URL, as a string
#' @keywords internal
#' @examples
#' hercacstables:::build_api_url(paste0("B25003_00", 1:3, "E"),
#'                               "tract",
#'                               "*",
#'                               "acs",
#'                               "acs5",
#'                               2020L,
#'                               state = 55L,
#'                               county = 101L,
#'                               use_key = FALSE)
#'
#' hercacstables:::build_api_url(paste0("P1_00", c(1, 3, 4), "N"),
#'                               "tract",
#'                               "*",
#'                               "dec",
#'                               "pl",
#'                               2020L,
#'                               state = 55L,
#'                               county = 101L,
#'                               use_key = FALSE)
build_api_url <- function(variables,
                          for_geo,
                          for_items,
                          survey_type,
                          table_or_survey_code,
                          year,
                          ...,
                          use_key = TRUE) {

    .request <- "" |>
        httr2::url_modify(
            scheme = CENSUS_API_SCHEME,
            hostname = CENSUS_API_HOSTNAME,
            path = CENSUS_API_PATHROOT
        ) |>
        httr2::request() |>
        httr2::req_url_path_append(
            year,
            survey_type,
            table_or_survey_code
        ) |>
        httr2::req_url_query(
            get = variables,
            .multi = "comma"
        ) |>
        httr2::req_url_query(
            `for` = rlang::inject(build_for_geographies(for_geo, !!!for_items))
        ) |>
        httr2::req_url_query(
            `in` = build_in_geographies(...),
            .multi = "explode"
        )

    if (use_key) {
        .request <- httr2::req_url_query(.request,
                                         key = api_key_value())
    }

    httr2::req_get_url(.request)
}
