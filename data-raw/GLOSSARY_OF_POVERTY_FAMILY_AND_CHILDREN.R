## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_POVERTY_FAMILY_AND_CHILDREN <- "extdata" |>
    system.file(
        "poverty_family_children_b17006.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "cicllllii"
    )

usethis::use_data(GLOSSARY_OF_POVERTY_FAMILY_AND_CHILDREN, overwrite = TRUE)

pillar::glimpse(
    GLOSSARY_OF_POVERTY_FAMILY_AND_CHILDREN
)
