## Copyright (C) 2024 by Higher Expectations for Racine County

.RAW_ACS_GROUP_METADATA <- "groups" |>
    latest_acs_metadata() |>
    dplyr::mutate(
        Description = stringr::str_remove(
            .data$Description,
            " \\(in \\d{4} Inflation-Adjusted Dollars\\)"
        )
    )

.GROUPS_WHEN_THEY_OCCUR <- .RAW_ACS_GROUP_METADATA |>
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

.LONGEST_DESCRIPTIONS <- .RAW_ACS_GROUP_METADATA |>
    dplyr::summarize(
        dplyr::across(c("Description", "Universe"),
                      \(.s) dplyr::last(.s, order_by = nchar(.s))
                      ),
        .by = "Group"
    )

ACS_GROUP_METADATA <- .GROUPS_WHEN_THEY_OCCUR |>
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

usethis::use_data(ACS_GROUP_METADATA, overwrite = TRUE)
