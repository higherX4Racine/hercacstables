CENSUS_API_SCHEME <- "https"
CENSUS_API_HOSTNAME <- "api.census.gov"
CENSUS_API_PATHROOT <- "data"

usethis::use_data(
    CENSUS_API_HOSTNAME,
    CENSUS_API_PATHROOT,
    CENSUS_API_SCHEME,
    internal = TRUE,
    overwrite = TRUE
)
