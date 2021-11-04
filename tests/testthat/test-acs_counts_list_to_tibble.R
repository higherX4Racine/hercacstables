test_that("TBD: ACS-style lists get turned into tidy tibbles.", {
    data("rusd_c23002a")
    expect_equal(rusd_c23002a$list %>% acs_counts_list_to_tibble("C23002A"),
                 rusd_c23002a$data)
})
