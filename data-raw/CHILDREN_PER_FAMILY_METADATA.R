## code to prepare `CHILDREN_PER_FAMILY_METADATA` dataset goes here

CHILDREN_PER_FAMILY_METADATA <- "extdata" |>
    system.file(
        "children_per_family_b09002.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ccicii"
    )

usethis::use_data(CHILDREN_PER_FAMILY_METADATA, overwrite = TRUE)
