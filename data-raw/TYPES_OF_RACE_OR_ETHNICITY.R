# Copyright (C) 2024 by Higher Expectations for Racine County

TYPES_OF_RACE_OR_ETHNICITY <- "extdata" |>
    system.file(
        "TYPES_OF_RACE_OR_ETHNICITY.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "c"
    )

usethis::use_data(TYPES_OF_RACE_OR_ETHNICITY, overwrite = TRUE)
