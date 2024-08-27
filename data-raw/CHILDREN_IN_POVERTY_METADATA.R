## code to prepare `CHILDREN_IN_POVERTY_METADATA` dataset goes here

CHILDREN_IN_POVERTY_METADATA <- "extdata" |>
    system.file(
        "children_in_poverty_b05010.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "ccinnii"
    )

usethis::use_data(CHILDREN_IN_POVERTY_METADATA, overwrite = TRUE)
