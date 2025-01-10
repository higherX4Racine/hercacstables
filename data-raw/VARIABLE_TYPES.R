## code to prepare `VARIABLE_TYPES` dataset goes here

VARIABLE_TYPES <- "extdata" |>
    system.file(
        "VARIABLE_TYPES.csv",
        package = "hercacstables"
    ) |>
    readr::read_csv(
        col_types = "c"
    )

usethis::use_data(VARIABLE_TYPES, overwrite = TRUE)
