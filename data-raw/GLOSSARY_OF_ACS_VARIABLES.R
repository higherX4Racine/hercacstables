## Copyright (C) 2024 by Higher Expectations for Racine County

GLOSSARY_OF_ACS_VARIABLES <- "variables" |>
    latest_acs_glossaries() |>
    dplyr::select(!"Concept")


usethis::use_data(GLOSSARY_OF_ACS_VARIABLES, overwrite = TRUE)
