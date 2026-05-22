## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_WORK_STATUS <- hercacstables::METADATA_FOR_ACS_VARIABLES |>
    hercacstables::hoist_table_glossary(
        .group = "B23027",
        .fields = c("Age", "Employed", "Full Time")
    ) |>
    dplyr::filter(
        .data$Dataset == "ACS5"
    ) |>
    hiRx::only_informative_columns() |>
    dplyr::mutate(
        Age = .data$Age |>
            stringr::str_remove("years") |>
            stringr::str_replace("over", "999") |>
            stringr::str_replace("\\s+(and|to)\\s+", ",") |>
            stringr::str_squish()
    ) |>
    tidyr::separate_wider_delim(
        cols = "Age",
        delim = ",",
        names = c("Lower Age", "Upper Age"),
        too_few = "align_start"
    ) |>
    dplyr::mutate(
        dplyr::across(c("Lower Age", "Upper Age"), as.integer),
        `Lower Age` = dplyr::coalesce(.data$`Lower Age`, 0),
        `Upper Age` = dplyr::coalesce(.data$`Upper Age`, 999),
        Employed = stringr::str_detect(.data$Employed, "not", negate = TRUE),
        `Full Time` = stringr::str_detect(.data$`Full Time`, "less", negate = TRUE),
        Employment = dplyr::case_when(
            !.data$`Full Time` ~ "Part Time",
            .data$`Full Time` ~ "Full Time",
            !.data$Employed ~ "Unemployed",
            .default = NA
        )
    )

usethis::use_data(GLOSSARY_OF_WORK_STATUS, overwrite = TRUE)
