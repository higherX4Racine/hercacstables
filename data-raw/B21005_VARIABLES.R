B21005_VARIABLES <- "extdata" |>
    system.file(
        "b21005.csv",
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
    )

usethis::use_data(B21005_VARIABLES, overwrite = TRUE)
