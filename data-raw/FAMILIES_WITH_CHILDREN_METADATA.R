## code to prepare `FAMILIES_WITH_CHILDREN_METADATA` dataset goes here

FAMILIES_WITH_CHILDREN_METADATA <- "extdata" |>
    system.file(
        "families_with_children_b11003.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ccicll"
    )

usethis::use_data(FAMILIES_WITH_CHILDREN_METADATA, overwrite = TRUE)
