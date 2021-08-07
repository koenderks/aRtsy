test_that("paint_strokes()", {
  artwork <- aRtsy::paint_strokes(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_ribbons()", {
  artwork <- aRtsy::paint_ribbons(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_turmite()", {
  artwork <- aRtsy::paint_turmite(color = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_ant()", {
  artwork <- aRtsy::paint_ant(colors = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_planet()", {
  artwork <- aRtsy::paint_planet(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_mondriaan()", {
  artwork <- aRtsy::paint_mondriaan(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_circlemap()", {
  artwork <- aRtsy::paint_circlemap(colors = c("black", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_function()", {
  artwork <- aRtsy::paint_function(color = "black")
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_arcs()", {
  artwork <- aRtsy:::paint_arcs(colors = c("black", "gray", "white"), n = 9)
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_polylines()", {
  artwork <- aRtsy::paint_polylines(colors = c("black", "gray", "white"))
  expect_equal(!is.null(artwork), TRUE)
})

test_that("paint_diamonds()", {
  artwork <- aRtsy::paint_diamonds(colors = c("black", "gray", "white"), radius = 50)
  expect_equal(!is.null(artwork), TRUE)
})