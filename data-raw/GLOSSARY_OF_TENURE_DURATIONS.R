## Copyright (C) 2026 by Higher Expectations for Racine County

.tmp <- hercacstables::METADATA_FOR_ACS_VARIABLES |>
    hercacstables::hoist_table_glossary(
        "B25128",
        c("Tenure",
          "Age",
          "Date")
    ) |>
    dplyr::filter(
        !is.na(.data$Date),
        .data$Dataset == "ACS1"
    ) |>
    dplyr::mutate(
        Date = .data$Date |>
            stringr::str_replace(
                "(\\d+) or later",
                paste("\\1 to", hercacstables::most_recent_vintage("acs",
                                                                   "acs1"))
            ) |>
            stringr::str_replace(
                "(\\d+) or earlier", "1790 to \\1"
            )
    )

.latest_year <- max(hercacstables:::extract_left_side_of_range(.tmp$Date)) + 1L

GLOSSARY_OF_TENURE_DURATIONS <- .tmp |>
    dplyr::bind_cols(
        hercacstables::extract_range(.tmp$Age, "Age")
    ) |>
    dplyr::bind_cols(
        hercacstables::extract_range(.tmp$Date, "Years")
    ) |>
    dplyr::mutate(
        dplyr::across(tidyselect::ends_with("Years"),
                      \(.) dplyr::if_else(. > .latest_year,
                                          0L,
                                          .latest_year - .))
    ) |>
    dplyr::select(
        "Group",
        "Index",
        "Variable",
        "Tenure",
        "Lower Age",
        "Upper Age",
        "Shortest Duration" = "Upper Years",
        "Longest Duration" = "Lower Years"
    )

usethis::use_data(GLOSSARY_OF_TENURE_DURATIONS, overwrite = TRUE)

pillar::glimpse(GLOSSARY_OF_TENURE_DURATIONS)
