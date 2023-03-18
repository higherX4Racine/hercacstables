## code to prepare `METADATA_ACS5` dataset goes here

.YEAR <- lubridate::year(lubridate::today())

.GROUPS_METADATA <- NULL

while (is.null(.GROUPS_METADATA) && .YEAR > 2003L) {
    tryCatch(
        .GROUPS_METADATA <<- fetch_metadata_table("groups",
                                                  .YEAR,
                                                  5L),
        error = function(e){.YEAR <<- .YEAR - 1}
    )
}

.VARIABLES_METADATA <- fetch_metadata_table("variables",
                                            .YEAR,
                                            5L)

.GEOGRAPHY_METADATA <- fetch_metadata_table("geography",
                                            .YEAR,
                                            5L)

METADATA_ACS5 <- list(
    geography = .GEOGRAPHY_METADATA,
    groups = .GROUPS_METADATA,
    variables = .VARIABLES_METADATA
)

usethis::use_data(METADATA_ACS5, overwrite = TRUE)
