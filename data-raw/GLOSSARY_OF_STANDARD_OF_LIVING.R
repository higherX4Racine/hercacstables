## Copyright (C) 2025 by Higher Expectations for Racine County

GLOSSARY_OF_STANDARD_OF_LIVING <- hercacstables::METADATA_FOR_ACS_VARIABLES |>
    dplyr::filter(
        .data$Group == "B17026",
        .data$Dataset == "ACS5"
    ) |>
    tidyr::separate_wider_regex(
        "Details",
        patterns = c(Lower = "\\d*\\.?\\d*",
                     "[^\\.\\d]*",
                     Upper = "\\d*\\.?\\d*")
    ) |>
    dplyr::mutate(
        dplyr::across(c("Lower", "Upper"),
                      ~ as.numeric(.)),
        Lower = dplyr::coalesce(.data$Lower,
                                -999),
        Upper = dplyr::coalesce(.data$Upper,
                                999),
        "Standard of Living" = dplyr::case_when(
            .data$Lower == -999 & .data$Upper == 999 ~ "Everyone",
            .data$Upper < 3 ~ "Unsustainable",
            .default = "Family-sustaining"
        ),
        Index = .data$Variable |>
            stringr::str_extract("(?<=_)\\d+(?=E)") |>
            as.integer()
    ) |>
    dplyr::select(
        "Group",
        "Variable",
        "Index",
        "Least Poverty Ratio" = "Lower",
        "Greatest Poverty Ratio" = "Upper",
        "Standard of Living"
    )

usethis::use_data(GLOSSARY_OF_STANDARD_OF_LIVING, overwrite = TRUE)
