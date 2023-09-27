.weighted_margin <- function(.x, .fields, .name, .weight_field){
    dplyr::count(.x,
                 dplyr::pick(tidyselect::all_of(.fields)),
                 wt = .data[[.weight_field]],
                 name = .name)
}

.bind_margin <- function(.x, .fields, .name, .weight_field){
    dplyr::inner_join(.x,
                      .weighted_margin(
                          .x,
                          .fields,
                          .name,
                          .weight_field
                      ),
                      by = .fields
    )
}

.safe_division <- function(numerator, denominator){
    dplyr::if_else(denominator > 0,
                   numerator / denominator,
                   0.0)
}

#' Determine the relative contribution of different demographic groups to the populations of a set of areas.
#'
#' @param block_data a tibble of census data that connects blocks to enclosing geographic areas.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> grouping fields in the data besides `demography` and `place`
#' @param demography_field optional, the field that identifies peoples' demographic group. Defaults to "Race/Ethnicity"
#' @param place_field optional, the field that denotes your custom geographic areas. Defaults to "Place"
#' @param weight_field optional, the field that denotes counts. Defaults to "Population"
#'
#' @return a tibble with proportions for estimating per-demographic values from per-tract data
#' @export
margins_by_demography_and_place <- function(block_data,
                                            ...,
                                            demography_field = "Race/Ethnicity",
                                            place_field = "Place",
                                            weight_field = "Population"){

    block_data |>
        .weighted_margin(
            c(..., demography_field, place_field),
            "margin_2D",
            .weight_field = weight_field
        ) |>
        dplyr::inner_join(
            .weighted_margin(
                block_data,
                c(..., demography_field),
                "margin_1D",
                .weight_field = weight_field
            ),
            by = c(..., demography_field)
        ) |>
        dplyr::inner_join(
            .weighted_margin(
                block_data,
                c(...),
                "margin_0D",
                .weight_field = weight_field
            ),
            by = c(...)
        ) |>
        dplyr::mutate(
            "to {demography_field}" := .safe_division(
                .data$margin_1D,
                .data$margin_0D
            ),
            "to {demography_field} in {place_field}" := .safe_division(
                .data$margin_2D,
                .data$margin_1D
            ),
            .keep = "unused"
        )
}
