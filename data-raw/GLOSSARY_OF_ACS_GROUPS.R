## Copyright (C) 2024 by Higher Expectations for Racine County

.GLOSSARY_OF_RAW_ACS_GROUP <- "groups" |>
    latest_acs_glossaries() |>
    dplyr::mutate(
        Description = stringr::str_remove(
            .data$Description,
            " \\(in \\d{4} Inflation-Adjusted Dollars\\)"
        )
    )

.GROUPS_WHEN_THEY_OCCUR <- .GLOSSARY_OF_RAW_ACS_GROUP |>
    dplyr::count(
        .data$Group,
        .data$Dataset,
        name = "Count"
    ) |>
    dplyr::mutate(
        Count = as.logical(.data$Count)
    ) |>
    tidyr::pivot_wider(
        names_from = "Dataset",
        values_from = "Count",
        values_fill = FALSE
    )

.LONGEST_DESCRIPTIONS <- .GLOSSARY_OF_RAW_ACS_GROUP |>
    dplyr::summarize(
        dplyr::across(c("Description", "Universe"),
                      \(.s) dplyr::last(.s, order_by = nchar(.s))
                      ),
        .by = "Group"
    )

GLOSSARY_OF_ACS_GROUPS <- .GROUPS_WHEN_THEY_OCCUR |>
    dplyr::inner_join(
        .LONGEST_DESCRIPTIONS,
        by = "Group"
    ) |>
    dplyr::select(
        "Group",
        "Universe",
        "Description",
        "ACS1",
        "ACS5"
    )

usethis::use_data(GLOSSARY_OF_ACS_GROUPS, overwrite = TRUE)
