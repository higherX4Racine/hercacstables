## Copyright (C) 2024 by Higher Expectations for Racine County

METADATA_FOR_ACS_VARIABLES <- "variables" |>
    latest_acs_metadata() |>
    dplyr::select(!"Concept")


usethis::use_data(METADATA_FOR_ACS_VARIABLES, overwrite = TRUE)
