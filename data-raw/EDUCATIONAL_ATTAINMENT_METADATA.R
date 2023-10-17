## code to prepare `EDUCATIONAL_ATTAINMENT_METADATA` dataset goes here

by_poverty <- "extdata" |>
    system.file(
        "sex_by_poverty_by_school_b17003.csv",
        package = "hercacstables"
        ) |>
    readr::read_csv(
        col_types = readr::cols(
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
        "sex_by_age_by_school_b15001.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = readr::cols(
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
        "sex_school_for_race_c15002.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = readr::cols(
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
        )
    )

EDUCATIONAL_ATTAINMENT_METADATA <- list(
    "sex_age" = by_age,
    "race_ethnicity" = by_race_ethnicity,
    "poverty" = by_poverty
)

usethis::use_data(EDUCATIONAL_ATTAINMENT_METADATA, overwrite = TRUE)
