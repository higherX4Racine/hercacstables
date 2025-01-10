# Copyright (C) 2024 by Higher Expectations for Racine County

RACE_OR_ETHNIC_GROUP_TYPES <- "extdata" |>
    system.file(
        "RACE_OR_ETHNIC_GROUP_TYPES.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "c"
    )

usethis::use_data(RACE_OR_ETHNIC_GROUP_TYPES, overwrite = TRUE)
