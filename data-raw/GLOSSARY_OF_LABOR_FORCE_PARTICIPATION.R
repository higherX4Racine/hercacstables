# Copyright (C) 2025 by Higher Expectations for Racine County

GLOSSARY_OF_LABOR_FORCE_PARTICIPATION <- METADATA_FOR_ACS_VARIABLES |>
    hoist_table_glossary(
        "B23001",
        c("Sex",
          "Age Range",
          "Labor Force",
          "Civilian",
          "Employed")
    ) |>
    dplyr::filter(
        !is.na(.data$Employed) |
            .data$`Labor Force` == "Not in labor force" |
            .data$Civilian == "In Armed Forces"
    ) |>
    tidyr::separate_wider_regex(
        "Age Range",
        patterns = c("Lower Age" = "\\d+",
                     "\\D+",
                     "Upper Age" = "\\d+",
                     "\\D*"),
        too_few = "align_start"
    ) |>
    dplyr::mutate(
        `Lower Age` = as.integer(.data$`Lower Age`),
        `Upper Age` = dplyr::coalesce(as.integer(.data$`Upper Age`),
                                      999L),
        `Labor Force` = dplyr::case_match(.data$`Labor Force`,
                                          "In labor force" ~ TRUE,
                                          .default = FALSE),
        Civilian = dplyr::case_match(.data$Civilian,
                                     "In Armed Forces" ~ FALSE,
                                     .default = TRUE),
        Employed = dplyr::coalesce(.data$Employed == "Employed",
                                   .data$`Labor Force`)
    )


usethis::use_data(GLOSSARY_OF_LABOR_FORCE_PARTICIPATION, overwrite = TRUE)
