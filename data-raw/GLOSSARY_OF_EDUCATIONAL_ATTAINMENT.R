## Copyright (C) 2025 by Higher Expectations for Racine County

by_poverty <- "extdata" |>
    system.file(
        "education_by_sex_and_poverty_b17003.csv",
        package = "hercacstables"
        ) |>
    readr::read_csv(
        col_types = list(
            group = readr::col_character(),
            index = readr::col_integer(),
            variable = readr::col_character(),
            Sex = readr::col_character(),
            Education = readr::col_character(),
            Poverty = readr::col_character()
        )
    ) |>
    dplyr::inner_join(
        hercacstables::EDUCATIONAL_ATTAINMENT_LEVELS,
        by = c(Education = "Broad"),
        relationship = "many-to-many"
    ) |>
    dplyr::mutate(
        `Lower Age` = 25L,
        `Upper Age` = 999L,
        `Age` = "All"
    ) |>
    dplyr::select(
        !"Detailed"
    ) |>
    dplyr::distinct()

by_age <- "extdata" |>
    system.file(
        "education_by_sex_and_age_b15001.csv",
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
            Age = readr::col_character(),
            Education = readr::col_character()
        )
    ) |>
    dplyr::inner_join(
        hercacstables::EDUCATIONAL_ATTAINMENT_LEVELS,
        by = c(Education = "Detailed")
    ) |>
    dplyr::select(
        !"Education",
        Education = "Broad"
    ) |>
    dplyr::distinct()

by_race_ethnicity <- "extdata" |>
    system.file(
        "education_by_sex_and_race_c15002.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = list(
            group = readr::col_character(),
            index = readr::col_integer(),
            Sex = readr::col_character(),
            `Lower Age` = readr::col_integer(),
            `Upper Age` = readr::col_integer(),
            Age = readr::col_character(),
            Education = readr::col_character()
        )
    ) |>
    dplyr::inner_join(
        hercacstables::EDUCATIONAL_ATTAINMENT_LEVELS,
        by = c(Education = "Broad"),
        relationship = "many-to-many"
    ) |>
    dplyr::select(
        !"Detailed"
    ) |>
    dplyr::distinct() |>
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
        )
    )

GLOSSARY_OF_EDUCATIONAL_ATTAINMENT <- list(
    "sex_age" = by_age,
    "sex_race" = by_race_ethnicity,
    "sex_poverty" = by_poverty
)

usethis::use_data(GLOSSARY_OF_EDUCATIONAL_ATTAINMENT, overwrite = TRUE)
