## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_TENURE_BY_AGE <- hercacstables::METADATA_FOR_ACS_VARIABLES |>
    dplyr::filter(
        .data$Dataset == "ACS5"
    ) |>
    hercacstables::hoist_table_glossary(
        "B25007",
        c("Tenure", "Age Bracket")
    ) |>
    dplyr::select(
        !"Dataset"
    ) |>
    tidyr::separate_wider_regex(
        "Age Bracket",
        patterns = c(
            "Householder ",
            `Lower Age` = "\\d+",
            "\\D+",
            `Upper Age` = "\\d*",
            "\\D*"
        )
    ) |>
    dplyr::mutate(
        Tenure = .data$Tenure |>
            stringr::str_extract("(Own|Rent)er") |>
            dplyr::coalesce("All"),
        dplyr::across(c("Lower Age", "Upper Age"),
                      as.integer),
        `Lower Age` = dplyr::coalesce(.data$`Lower Age`,
                                      min(.data$`Lower Age`, na.rm = TRUE)),
        `Upper Age` = dplyr::coalesce(.data$`Upper Age`,
                                      999)
    )

GLOSSARY_OF_TENURE_BY_AGE |> pillar::glimpse()

usethis::use_data(GLOSSARY_OF_TENURE_BY_AGE, overwrite = TRUE)
