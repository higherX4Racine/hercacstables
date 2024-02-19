## code to prepare `UNEMPLOYMENT_VARIABLES` dataset goes here

UNEMPLOYMENT_VARIABLES <- "extdata" |>
    system.file(
        "unemployment_variables.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = list(
            Sex = readr::col_character(),
            `Lower Age` = readr::col_integer(),
            `Upper Age` = readr::col_integer(),
            `Labor Status` = readr::col_character(),
            Group = readr::col_character(),
            Index = readr::col_double(),
            Variable = readr::col_character()
        )
    )

usethis::use_data(UNEMPLOYMENT_VARIABLES, overwrite = TRUE)
