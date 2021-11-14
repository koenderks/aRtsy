test_that("colorPalette()", {
  set.seed(1)
  palette <- colorPalette(name = "random", n = 4)
  expect_equal(length(palette), 4)
})

test_that("canvas_strokes()", {
  set.seed(1)
  artwork <- canvas_strokes(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_ribbons()", {
  set.seed(1)
  artwork <- canvas_ribbons(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_turmite()", {
  set.seed(1)
  artwork <- canvas_turmite(color = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_ant()", {
  set.seed(1)
  artwork <- canvas_ant(colors = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_planet()", {
  set.seed(1)
  artwork <- canvas_planet(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_squares()", {
  set.seed(1)
  artwork <- canvas_squares(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_circlemap()", {
  set.seed(1)
  artwork <- canvas_circlemap(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_function()", {
  set.seed(1)
  artwork <- canvas_function(color = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_polylines()", {
  set.seed(1)
  artwork <- canvas_polylines(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_diamonds()", {
  set.seed(1)
  artwork <- canvas_diamonds(colors = c("black", "gray", "white"), radius = 50)
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_segments()", {
  set.seed(1)
  artwork <- canvas_segments(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_mandelbrot()", {
  set.seed(1)
  artwork <- canvas_mandelbrot(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_collatz()", {
  set.seed(1)
  artwork <- canvas_collatz(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_mosaic()", {
  set.seed(1)
  artwork <- canvas_mosaic(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_forest()", {
  set.seed(1)
  artwork <- canvas_forest(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_gemstone()", {
  set.seed(1)
  artwork <- canvas_gemstone(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_blacklight()", {
  set.seed(1)
  artwork <- canvas_blacklight(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_stripes()", {
  set.seed(1)
  artwork <- canvas_stripes(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_nebula()", {
  set.seed(1)
  artwork <- canvas_nebula(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_watercolors()", {
  set.seed(1)
  artwork <- canvas_watercolors(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_flow()", {
  set.seed(1)
  artwork <- canvas_flow(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_maze()", {
  set.seed(1)
  artwork <- canvas_maze(color = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_recaman()", {
  set.seed(1)
  artwork <- canvas_recaman(colors = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_phyllotaxis()", {
  set.seed(1)
  artwork <- canvas_phyllotaxis(colors = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_cobweb()", {
  set.seed(1)
  artwork <- canvas_cobweb(colors = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_chladni()", {
  set.seed(1)
  artwork <- canvas_chladni(colors = "black")
  expect_equal(!is.null(artwork), TRUE)
})
