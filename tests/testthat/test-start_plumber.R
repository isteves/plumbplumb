context("test-start_plumber")

test_that("README examples work", {
    plumber_path <- system.file("plumber.R", package = "plumbplumb")
    trml <- start_plumber(plumber_path, 8484)
    withr::defer(kill_plumber(trml), envir = parent.frame())

    bar <- httr::GET("http://127.0.0.1:8484/random_praise?seed=2")
    expect_equal(httr::content(bar, encoding = "UTF8"),
                 "You are delightful!")

    foo <- httr::GET("http://127.0.0.1:8484/random_praise?seed=3")
    expect_equal(httr::content(foo, encoding = "UTF8"),
                 "You are dandy!")

    baz <- httr::GET("http://127.0.0.1:8484/random_data?seed=2")
    baz_cont <- httr::content(baz, encoding = "UTF8")
    expect_s3_class(baz_cont, "tbl")
    expect_equal(baz_cont$bar[1], 0.924, tolerance = 0.01)

    boo <- httr::GET("http://127.0.0.1:8484/random_data?seed=3")
    boo_cont <- httr::content(boo, encoding = "UTF8")
    expect_s3_class(boo_cont, "tbl")
    expect_equal(boo_cont$bar[1], 0.840, tolerance = 0.01)
})
