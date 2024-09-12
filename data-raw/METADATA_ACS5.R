## code to prepare `METADATA_ACS5` dataset goes here

METADATA_ACS5 <- NULL

.YEAR <- lubridate::year(lubridate::today())

while (.YEAR > 2003L) {
    status_code <- "groups" |>
        build_info_url(.YEAR, 5L) |>
        httr::HEAD() |>
        httr::status_code()

    if (status_code == 200L) {
        METADATA_ACS5 <- c("geography", "groups", "variables") |>
            rlang::set_names() |>
            purrr::map(fetch_metadata_table,
                       .year = .YEAR,
                       .year_span = 5L)
        break
    }
    .YEAR <- .YEAR - 1L
}

usethis::use_data(METADATA_ACS5, overwrite = TRUE)
