## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_EDUCATION_AND_EMPLOYMENT <- hercacstables::METADATA_FOR_ACS_VARIABLES |>
    dplyr::filter(
        .data$Dataset == "ACS1"
    ) |>
    hercacstables::hoist_table_glossary(
        "B23006",
        c("Education",
          "Labor Force",
          "Civilian",
          "Employed")
    ) |>
    dplyr::select(
        !"Dataset"
    ) |>
    dplyr::mutate(
        Education = levels(hercacstables::EDUCATIONAL_ATTAINMENT_LEVELS$Broad)[
            dplyr::case_match(
                stringr::str_extract(.data$Education, "^\\S+"),
                "Bachelor's" ~ 4L,
                "High" ~ 2L,
                "Less" ~ 1L,
                "Some" ~ 3L,
                .default = 1L
            )
        ],
        `Labor Force` = stringr::str_starts(.data$`Labor Force`, "In"),
        Civilian = stringr::str_starts(.data$Civilian, "Civilian"),
        Employed = stringr::str_starts(.data$Employed, "Employed")
    )

pillar::glimpse(GLOSSARY_OF_EDUCATION_AND_EMPLOYMENT)

usethis::use_data(GLOSSARY_OF_EDUCATION_AND_EMPLOYMENT, overwrite = TRUE)
