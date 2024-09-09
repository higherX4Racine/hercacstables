US_RACE_ETHNICITY_POPS_2022 <- purrr::list_rbind(
    list(broad = "extdata" |>
             system.file(
                 "us_race_ethnicity_pops_broad_2022.csv",
                 package = "hercacstables"
             ) |>
             readr::read_csv(
                 col_types = "iciii"
             ),
         detailed = "extdata" |>
             system.file(
                 "us_race_ethnicity_pops_detailed_2022.csv",
                 package = "hercacstables"
             ) |>
             readr::read_csv(
                 col_types = "iciii"
             )
    ),
    names_to = "Detail Level"
)


usethis::use_data(US_RACE_ETHNICITY_POPS_2022, overwrite = TRUE)
