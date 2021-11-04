.YEAR        <- 2019
.VINTAGE    <- 5
.TABLE_NAME  <- "C23002A"

.FIELD_NAMES <- c("Stat",
                  "Sex",
                  "Age",
                  "Workforce Status",
                  "Civilian Status",
                  "Employment Status")

.URL <- acs_groups_url(.YEAR,
                       .VINTAGE,
                       .TABLE_NAME)

.JSON <- readr::read_file(.URL)
.LIST <- jsonlite::parse_json(.JSON)
.DATA <- acs_groups_list_to_tibble(.LIST,
                                   .FIELD_NAMES)

c23002a_groups <- list(
    url    = .URL,
    json   = .JSON,
    list   = .LIST,
    fields = .FIELD_NAMES,
    data   = .DATA
)

usethis::use_data(c23002a_groups, overwrite = TRUE)
