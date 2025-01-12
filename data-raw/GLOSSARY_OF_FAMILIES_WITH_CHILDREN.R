## Copyright (C) 2024 by Higher Expectations for Racine County

GLOSSARY_OF_FAMILIES_WITH_CHILDREN <- "extdata" |>
    system.file(
        "families_with_children_b11003.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ccicll"
    )

usethis::use_data(GLOSSARY_OF_FAMILIES_WITH_CHILDREN, overwrite = TRUE)
