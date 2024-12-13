## code to prepare `STANDARD_OF_LIVING_METADATA` dataset goes here

.STANDARD_OF_LIVING_TABLE <- "B17026"
STANDARD_OF_LIVING_METADATA <- hercacstables::ACS_VARIABLE_METADATA |>
    dplyr::filter(
        .data$Group == .STANDARD_OF_LIVING_TABLE
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

usethis::use_data(STANDARD_OF_LIVING_METADATA, overwrite = TRUE)
