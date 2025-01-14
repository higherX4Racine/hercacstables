## Copyright (C) 2025 by Higher Expectations for Racine County

GLOSSARY_OF_CHILDREN_IN_POVERTY <- "extdata" |>
    system.file(
        "children_in_poverty_b05010.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ccinncii"
    )

usethis::use_data(GLOSSARY_OF_CHILDREN_IN_POVERTY, overwrite = TRUE)
