## Copyright (C) 2025 by Higher Expectations for Racine County

RACE_ETHNICITY_SUBTABLES <- "extdata" |>
    system.file(
        "RACE_ETHNICITY_SUBTABLES.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "c",
        na = character()
    )

usethis::use_data(RACE_ETHNICITY_SUBTABLES, overwrite = TRUE)
