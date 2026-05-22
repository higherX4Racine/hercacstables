## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_AGGREGATE_HOUSEHOLD_INCOME <- "extdata" |>
    system.file(
        "aggregate_household_income.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = list(
            Group = "c",
            Index = "i",
            `Race/Ethnicity` = "c",
            Source = "c",
            Public = "l",
            `Lower Age` = "i",
            `Upper Age` = "i",
            Subtotal = "c",
            Atomic = "l"
        )
    )

usethis::use_data(GLOSSARY_OF_AGGREGATE_HOUSEHOLD_INCOME, overwrite = TRUE)
