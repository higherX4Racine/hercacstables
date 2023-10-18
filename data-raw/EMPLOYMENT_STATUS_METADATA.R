## code to prepare `EMPLOYMENT_STATUS_METADATA` dataset goes here

EMPLOYMENT_STATUS_METADATA <- list(
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
                hercacstables::race_or_ethnicity,
                Suffix = "code",
                `Census Race/Ethnicity` = "label"
            )
        ) |>
        dplyr::mutate(
            variable = hercacstables::build_api_variable(
                table_code = .data$group,
                race_code = .data$Suffix,
                item_number = .data$index,
                separator = "_",
                suffix = "E"
            ),
            Poverty = "All"
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

usethis::use_data(EMPLOYMENT_STATUS_METADATA, overwrite = TRUE)
