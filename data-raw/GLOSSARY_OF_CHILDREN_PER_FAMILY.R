## Copyright (C) 2025 by Higher Expectations for Racine County

GLOSSARY_OF_CHILDREN_PER_FAMILY <- "extdata" |>
    system.file(
        "children_per_family_b09002.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ccicii"
    )

usethis::use_data(GLOSSARY_OF_CHILDREN_PER_FAMILY, overwrite = TRUE)
