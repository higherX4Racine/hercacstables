# Copyright (C) 2024 by Higher Expectations for Racine County

SUBJECT_TYPES <- "extdata" |>
    system.file(
        "SUBJECT_TYPES.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ic"
    ) |>
    dplyr::mutate(
        `Subject Number` = sprintf("%02d", .data$`Subject Number`)
    )

usethis::use_data(SUBJECT_TYPES, overwrite = TRUE)
