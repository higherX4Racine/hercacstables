ACS_RACE_ETHNICITY_VARIABLES <- "extdata" |>
    system.file(
        "race_ethnicity_b03002.csv",
        package = "hercacstables"
        ) |>
    readr::read_csv(
        col_types = "cicc"
    )

usethis::use_data(ACS_RACE_ETHNICITY_VARIABLES, overwrite = TRUE)
