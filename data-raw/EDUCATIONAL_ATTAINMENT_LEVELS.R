## Copyright (C) 2025 by Higher Expectations for Racine County

EDUCATIONAL_ATTAINMENT_LEVELS <- "extdata" |>
    system.file(
        "educational_attainment_levels.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        show_col_types = FALSE
    ) |>
    dplyr::mutate(
        dplyr::across(tidyselect::everything(),
                      forcats::fct_inorder)
    )

usethis::use_data(EDUCATIONAL_ATTAINMENT_LEVELS, overwrite = TRUE)
