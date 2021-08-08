test_that("colorPalette()", {
  palette <- aRtsy::colorPalette(name = 'random', n = 4)
  expect_equal(length(palette), 4)
})

test_that("canvas_strokes()", {
  artwork <- aRtsy::canvas_strokes(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_ribbons()", {
  artwork <- aRtsy::canvas_ribbons(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_turmite()", {
  artwork <- aRtsy::canvas_turmite(color = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_ant()", {
  artwork <- aRtsy::canvas_ant(colors = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_planet()", {
  artwork <- aRtsy::canvas_planet(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_mondriaan()", {
  artwork <- aRtsy::canvas_mondriaan(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_circlemap()", {
  artwork <- aRtsy::canvas_circlemap(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_function()", {
  artwork <- aRtsy::canvas_function(color = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_arcs()", {
  artwork <- aRtsy:::canvas_arcs(colors = c("black", "gray", "white"), n = 9)
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_polylines()", {
  artwork <- aRtsy::canvas_polylines(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("canvas_diamonds()", {
  artwork <- aRtsy::canvas_diamonds(colors = c("black", "gray", "white"), radius = 50)
  expect_equal(!is.null(artwork), TRUE)
})