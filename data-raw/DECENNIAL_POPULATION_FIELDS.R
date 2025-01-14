## Copyright (C) 2025 by Higher Expectations for Racine County

DECENNIAL_RACES <- tibble::tribble(
    ~ Index, ~ `Race/Ethnicity`,
    7L,      "American Indian and Alaska Native",
    8L,      "Asian",
    6L,      "Black or African American",
    2L,      "Hispanic or Latino",
    9L,      "Native Hawaiian and Other Pacific Islander",
    10L,     "Some other race",
    11L,     "Two or more races",
    5L,      "White",
    1L,      "All"
)

DECENNIAL_TABLES <- tibble::tribble(
    ~ Vintage, ~ Group, ~ Pad, ~ Suffix,
    2000L,     "PL002", "",    "",
    2010L,     "P002",  "",    "",
    2020L,     "P2",    "_",   "N"
)

DECENNIAL_POPULATION_FIELDS <- DECENNIAL_TABLES |>
    dplyr::cross_join(
        DECENNIAL_RACES
    ) |>
    dplyr::mutate(
        Variable = stringr::str_c(.data$Group,
                                  .data$Pad,
                                  stringr::str_pad(.data$Index,
                                                   width = 3L,
                                                   side = "left",
                                                   pad = 0L),
                                  .data$Suffix)
    ) |>
    dplyr::select(
        "Vintage",
        "Group",
        "Race/Ethnicity",
        "Index",
        "Variable"
    )

usethis::use_data(DECENNIAL_POPULATION_FIELDS, overwrite = TRUE)
