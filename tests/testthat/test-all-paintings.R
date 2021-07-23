test_that("paint_strokes()", {
  painting <- aRtsy::paint_strokes(colors = c("black", "white"))
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_ribbons()", {
  painting <- aRtsy::paint_ribbons(colors = c("black", "white"))
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_turmite()", {
  painting <- aRtsy::paint_turmite(color = "black")
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_ant()", {
  painting <- aRtsy::paint_ant(colors = "black")
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_planet()", {
  painting <- aRtsy::paint_planet(colors = c("black", "white"))
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_mondriaan()", {
  painting <- aRtsy::paint_mondriaan(colors = c("black", "white"))
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_circlemap()", {
  painting <- aRtsy::paint_circlemap(colors = c("black", "white"))
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_function()", {
  painting <- aRtsy::paint_function(color = "black")
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_arcs()", {
  painting <- aRtsy:::paint_arcs(colors = c("black", "gray", "white"), n = 9)
  expect_equal(!is.null(painting), TRUE)
})

test_that("paint_polylines()", {
  painting <- aRtsy::paint_polylines(colors = c("black", "gray", "white"))
  expect_equal(!is.null(painting), TRUE)
})