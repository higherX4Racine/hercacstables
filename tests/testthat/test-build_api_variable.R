test_that("acs detailed table works", {
    expect_equal(
        build_api_variable("B01001", 1),
        "B01001_001E"
    )
    expect_equal(
        build_api_variable("B01001", 1, "H"),
        "B01001H_001E"
    )
    expect_equal(
        build_api_variable(
            c("B01001", "B01001", "B11001"),
            1:3,
            c("", "H", "I"),
            separator = c("%", "", "_"),
            suffix = c("E", "MA", "M")
        ),
        c("B01001%001E",
          "B01001H002MA",
          "B11001I_003M")
    )
})

test_that("decennial population table works", {
    expect_equal(
        build_api_variable("P1", c(1, 3, 4), suffix = "N"),
        c("P1_001N", "P1_003N", "P1_004N")
    )
})
