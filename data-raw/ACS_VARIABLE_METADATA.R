## Copyright (C) 2024 by Higher Expectations for Racine County

ACS_VARIABLE_METADATA <- "variables" |>
    latest_acs_metadata() |>
    dplyr::select(!"Concept")


usethis::use_data(ACS_VARIABLE_METADATA, overwrite = TRUE)
