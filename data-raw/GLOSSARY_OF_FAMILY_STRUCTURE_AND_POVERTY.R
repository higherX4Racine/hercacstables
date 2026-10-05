## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_FAMILY_STRUCTURE_AND_POVERTY <- "extdata" |>
    system.file(
        "family_structure_and_poverty_b17010.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "illlll"
    )

usethis::use_data(GLOSSARY_OF_FAMILY_STRUCTURE_AND_POVERTY,
                  overwrite = TRUE)

pillar::glimpse(GLOSSARY_OF_FAMILY_STRUCTURE_AND_POVERTY)
