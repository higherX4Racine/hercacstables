# Copyright (C) 2024 by Higher Expectations for Racine County

TYPES_OF_SUBJECT <- "extdata" |>
    system.file(
        "TYPES_OF_SUBJECT.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ic"
    ) |>
    dplyr::mutate(
        `Subject Number` = sprintf("%02d", .data$`Subject Number`)
    )

usethis::use_data(TYPES_OF_SUBJECT, overwrite = TRUE)
