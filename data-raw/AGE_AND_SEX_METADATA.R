# Copyright (C) 2024 by Higher Expectations for Racine County

AGE_AND_SEX_METADATA <- "extdata" |>
    system.file(
        "age_and_sex_b01001.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ciccii"
    )

usethis::use_data(AGE_AND_SEX_METADATA, overwrite = TRUE)
