## Copyright (C) 2025 by Higher Expectations for Racine County

TYPES_OF_VARIABLE <- "extdata" |>
    system.file(
        "TYPES_OF_VARIABLE.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "c"
    )

usethis::use_data(TYPES_OF_VARIABLE, overwrite = TRUE)
