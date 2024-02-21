## code to prepare `GEOGRAPHY_HIERARCHY_METADATA` dataset goes here

GEOGRAPHY_HIERARCHY_METADATA <- tibble::tribble(
    ~ Label,                   ~ Code, ~ Geography,                 ~ `Parent Geos`,
    "Block",                  "100",  "block",                     c("state", "county", "tract"),
    "Block Group",            "150",  "block group",               c("state", "county", "tract"),
    "Tract",                  "140",  "tract",                     c("state", "county"),
    "Subdivision",            "060",  "county subdivision",        c("state"),
    "Place",                  "160",  "place",                     c("state"),
    "Congressional District", "500",  "congressional district",    c("state"),
    "School District",        "970",  "school district (unified)", c("state"),
    "County",                 "050",  "county",                    c("state")
)

usethis::use_data(GEOGRAPHY_HIERARCHY_METADATA, overwrite = TRUE)
