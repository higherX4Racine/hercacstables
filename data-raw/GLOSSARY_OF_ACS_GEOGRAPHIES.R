## Copyright (C) 2025 by Higher Expectations for Racine County

GLOSSARY_OF_ACS_GEOGRAPHIES <- "geography" |>
    latest_acs_glossaries() |>
    dplyr::mutate(
        `Containing Geographies` = purrr::map_chr(
            .data$`Containing Geographies`,
            \(.) paste0(., collapse = ", ")
        )
    ) |>
    dplyr::summarize(
        dplyr::across(c("Containing Geographies", "Wildcard Option"),
                      \(.){
                          .a <- .[!is.na(.) & nchar(.) > 0]
                          .b <- paste0("{", .a, "}", collapse = "; ")
                          stringr::str_remove(.b, "\\{\\}")
                      }),
        .by = c("Geographic Level", "Dataset", "Reference Date")
    ) |>
    tidyr::pivot_wider(
        names_from = "Dataset",
        values_from = "Reference Date"
    )

usethis::use_data(GLOSSARY_OF_ACS_GEOGRAPHIES, overwrite = TRUE)
