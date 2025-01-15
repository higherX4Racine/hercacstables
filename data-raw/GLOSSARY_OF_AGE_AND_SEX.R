# Copyright (C) 2024 by Higher Expectations for Racine County

GLOSSARY_OF_AGE_AND_SEX <- "extdata" |>
    system.file(
        "age_and_sex_b01001.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ciccii"
    )

usethis::use_data(GLOSSARY_OF_AGE_AND_SEX, overwrite = TRUE)
