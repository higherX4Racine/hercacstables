.TABLE_NAME <- "C23002A"
.YEAR       <- 2019
.ACS_TYPE   <- 5
.ROWS       <- c(5, 7, 8, 9, 12, 13, 14, 18, 20, 21, 22, 25, 26, 27)
.VARS <- paste0(paste0(.TABLE_NAME, "_",
                       stringr::str_pad(.ROWS, 3, pad = "0")),
                rep(c("E", "M"),
                    each=length(.VARS)))
.DISTRICT   <- 12360
.STATE_FIPS <- 55

.BASE_URL <- paste0("https://api.census.gov/data/",
                    .YEAR,
                    "/acs/acs",
                    .ACS_TYPE)

.QUERY_DISTRICT <- paste0("school%20district%20(unified):",
                          .DISTRICT)

.QUERY_STATE <- paste0("state:",
                       .STATE_FIPS)

.QUERY_VARS <- paste("NAME",
                     paste0(.VARS, collapse = ","),
                     sep = ",")

.QUERY <- paste0("get=",
                 .QUERY_VARS,
                 "&for=",
                 .QUERY_DISTRICT,
                 "&in=",
                 .QUERY_STATE)

.URL <- paste0(.BASE_URL,
               "?",
               .QUERY)

.JSON <- readr::read_file(.URL)
.LIST <- jsonlite::parse_json(.JSON)
.DATA <- acs_counts_list_to_tibble(.LIST,
                                   .TABLE_NAME)

rusd_c23002a <- list(
    url  = .URL,
    json = .JSON,
    list = .LIST,
    data = .DATA
)

usethis::use_data(rusd_c23002a, overwrite = TRUE)
