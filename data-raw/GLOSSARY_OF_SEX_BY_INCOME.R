## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_SEX_BY_INCOME <- METADATA_FOR_ACS_VARIABLES |>
    hoist_table_glossary(
        "B19325",
        c("Sex",
          "Employment",
          "Earner",
          "Range")
    ) |>
    dplyr::mutate(
        Range = stringr::str_remove(.data$Range, "or .+$")
    ) |>
    tidyr::separate_wider_delim(
        cols = "Range",
        delim = " to ",
        names = c("Lower Bound", "Upper Bound"),
        too_few = "align_start"
    ) |>
    dplyr::mutate(
        dplyr::across(tidyselect::ends_with("Bound"),
                      readr::parse_number),
        `Lower Bound` = dplyr::case_match(
            .data$Earner,
            "No income" ~ 0.0,
            "With income" ~ dplyr::coalesce(.data$`Lower Bound`, 1.0),
            .default = dplyr::coalesce(.data$`Lower Bound`, 0.0)
        ),
        `Upper Bound` = dplyr::case_match(
            .data$Earner,
            "No income" ~ 0.0,
            .default = dplyr::coalesce(.data$`Upper Bound`, Inf)
        ),
        `Full-time` = .data$Employment == "Worked full-time, year-round in the past 12 months"
    ) |>
    dplyr::select(
        "Index",
        "Sex",
        "Full-time",
        "Lower Bound",
        "Upper Bound"
    ) |>
    dplyr::distinct() |>
    dplyr::arrange(
        .data$Index
    )

usethis::use_data(GLOSSARY_OF_SEX_BY_INCOME, overwrite = TRUE)
