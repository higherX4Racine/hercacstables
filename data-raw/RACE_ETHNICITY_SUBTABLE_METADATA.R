RACE_ETHNICITY_SUBTABLE_METADATA <- "extdata" |>
    system.file(
        "race_ethnicity_subtable_metadata.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "c",
        na = character()
    )

usethis::use_data(RACE_ETHNICITY_SUBTABLE_METADATA, overwrite = TRUE)
