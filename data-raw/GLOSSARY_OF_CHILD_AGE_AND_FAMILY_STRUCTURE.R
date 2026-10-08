## Copyright (C) 2026 by Higher Expectations for Racine County

GLOSSARY_OF_CHILD_AGE_AND_FAMILY_STRUCTURE <- tibble::tribble(
    ~ Group,  ~ Index, ~ Variable,    ~ Married, ~ `Sex of Householder`, ~ `Lower Age`, ~ `Upper Age`,
    "B09002",      1L, "B09002_001E",        NA, NA,                                0L,           17L,
    "B09002",      2L, "B09002_002E",      TRUE, NA,                                0L,           17L,
    "B09002",      3L, "B09002_003E",      TRUE, NA,                                0L,            3L,
    "B09002",      4L, "B09002_004E",      TRUE, NA,                                3L,            4L,
    "B09002",      5L, "B09002_005E",      TRUE, NA,                                5L,            5L,
    "B09002",      6L, "B09002_006E",      TRUE, NA,                                6L,           11L,
    "B09002",      7L, "B09002_007E",      TRUE, NA,                               12L,           17L,
    "B09002",      8L, "B09002_008E",     FALSE, NA,                                0L,           17L,
    "B09002",      9L, "B09002_009E",     FALSE, "Male",                            0L,           17L,
    "B09002",     10L, "B09002_010E",     FALSE, "Male",                            0L,            3L,
    "B09002",     11L, "B09002_011E",     FALSE, "Male",                            3L,            4L,
    "B09002",     12L, "B09002_012E",     FALSE, "Male",                            5L,            5L,
    "B09002",     13L, "B09002_013E",     FALSE, "Male",                            6L,           11L,
    "B09002",     14L, "B09002_014E",     FALSE, "Male",                           12L,           17L,
    "B09002",     15L, "B09002_015E",     FALSE, "Female",                          0L,           17L,
    "B09002",     16L, "B09002_016E",     FALSE, "Female",                          0L,            3L,
    "B09002",     17L, "B09002_017E",     FALSE, "Female",                          3L,            4L,
    "B09002",     18L, "B09002_018E",     FALSE, "Female",                          5L,            5L,
    "B09002",     19L, "B09002_019E",     FALSE, "Female",                          6L,           11L,
    "B09002",     20L, "B09002_020E",     FALSE, "Female",                         12L,           17L
)

usethis::use_data(GLOSSARY_OF_CHILD_AGE_AND_FAMILY_STRUCTURE, overwrite = TRUE)

pillar::glimpse(GLOSSARY_OF_CHILD_AGE_AND_FAMILY_STRUCTURE)
