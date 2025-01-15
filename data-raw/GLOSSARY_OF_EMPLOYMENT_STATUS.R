## Copyright (C) 2025 by Higher Expectations for Racine County

GLOSSARY_OF_EMPLOYMENT_STATUS <- list(
    "extdata" |>
        system.file(
            "employed_by_sex_and_age_b23001.csv",
            package = "hercacstables"
        ) |>
        readr::read_csv(
            col_types = list(
                group = readr::col_character(),
                index = readr::col_integer(),
                variable = readr::col_character(),
                Sex = readr::col_character(),
                `Lower Age` = readr::col_integer(),
                `Upper Age` = readr::col_integer(),
                `Labor Force` = readr::col_character(),
                Enlistment = readr::col_character(),
                Employment = readr::col_character()
            )
        ) |>
        dplyr::mutate(
            Suffix = "",
            `Census Race/Ethnicity` = "All",
            Poverty = "All"
        ),
    "extdata" |>
        system.file(
            "employed_by_sex_and_race_c23002.csv",
            package = "hercacstables"
        ) |>
        readr::read_csv(
            col_types = list(
                group = readr::col_character(),
                index = readr::col_integer(),
                Sex = readr::col_character(),
                `Lower Age` = readr::col_integer(),
                `Upper Age` = readr::col_integer(),
                `Labor Force` = readr::col_character(),
                Enlistment = readr::col_character(),
                Employment = readr::col_character()
            )
        ) |>
        dplyr::cross_join(
            dplyr::rename(
                hercacstables::TYPES_OF_RACE_OR_ETHNICITY,
                Suffix = "Code",
                `Census Race/Ethnicity` = "Race or Ethnic Group"
            )
        ) |>
        dplyr::mutate(
            variable = hercacstables::build_api_variable(
                group_code = .data$group,
                race_code = .data$Suffix,
                item_number = .data$index,
                separator = "_",
                suffix = "E"
            ),
            Poverty = "All"
        ),
    "extdata" |>
        system.file(
            "employed_by_age_and_veterancy_b21005.csv",
            package = "hercacstables"
        ) |>
        readr::read_csv(
            col_types = readr::cols(
                Name = readr::col_character(),
                Age = readr::col_character(),
                Veteran = readr::col_logical(),
                `In Labor Force` = readr::col_logical(),
                Employed = readr::col_logical(),
                `Lower Age` = readr::col_integer(),
                `Upper Age` = readr::col_integer()
            )
        ),
    "extdata" |>
        system.file(
            "employed_by_sex_and_poverty_b17005.csv",
            package = "hercacstables"
        ) |>
        readr::read_csv(
            col_types = list(
                group = readr::col_character(),
                index = readr::col_integer(),
                variable = readr::col_character(),
                Sex = readr::col_character(),
                `Labor Force` = readr::col_character(),
                Employment = readr::col_character()
            )
        ) |>
        dplyr::mutate(
            `Lower Age` = 16L,
            `Upper Age` = 999L,
            Enlistment = "Civilian",
            Suffix = "",
            `Census Race/Ethnicity` = "All"
        )
) |>
    purrr::list_rbind()

usethis::use_data(GLOSSARY_OF_EMPLOYMENT_STATUS, overwrite = TRUE)
