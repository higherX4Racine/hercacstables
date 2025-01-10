# Copyright (C) 2024 by Higher Expectations for Racine County

TABLE_TYPES <- "extdata" |>
    system.file(
        "TABLE_TYPES.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "c"
    )

usethis::use_data(TABLE_TYPES, overwrite = TRUE)
