test_that("raggedness is handled", {
    bo <- list(
        One = list(A = 1:3, B = letters[1:2], C = 0.0, D = exp(1)),
        Two = list(A = 1:2, B = letters[20], D = exp(2)),
        Three = list(A = 1:3, B = letters[3:4], C = 0.0, D = exp(3))
    )
    peep <- ragged_list_to_tibble(bo)
    expect_equal(peep$id, c("One", "Two", "Three"))
    expect_equal(peep$A, list(1:3, 1:2, 1:3))
    expect_equal(peep$D, exp(1:3), tolerance = 1e-7)
})
