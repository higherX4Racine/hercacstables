parse_acs_table_variable <- function(.x, .y) {
    ACS_TABLE_REGEX <- "([[:alnum:]]+)_([[:digit:]]+)(.*)"

    .x %>%
        extract(Variable,
                c("Table",
                  "Row",
                  "Statistic Type"),
                ACS_TABLE_REGEX,
                convert = TRUE)
}
