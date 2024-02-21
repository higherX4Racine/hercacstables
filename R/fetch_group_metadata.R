fetch_group_metadata <- function(.year, .survey_type, .survey_or_table_code, .group){
    .json <- "https://api.census.gov/data" |>
        paste(
            .year,
            .survey_type,
            .survey_or_table_code,
            "groups",
            .group,
            sep = "/"
        ) |>
        paste0(
            ".json?key=",
            Sys.getenv("CENSUS_API_KEY")
        ) |>
        jsonlite::read_json() |>
        purrr::pluck(
            "variables"
        )

    .json |>
        purrr::list_transpose() |>
        tibble::as_tibble() |>
        dplyr::mutate(
            Variable = names(.json)
        ) |>
        dplyr::select(
            "Variable",
            "label"
        ) |>
        dplyr::filter(
            stringr::str_detect(.data$Variable, "E$")
        ) |>
        dplyr::arrange(
            .data$Variable
        )
}
