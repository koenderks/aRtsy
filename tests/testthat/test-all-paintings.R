test_that("Paint strokes", {
  painting <- aRtsy::paint_strokes(colors = c('#fafafa', '#000000'))
  expect_equal(!is.null(painting), TRUE)
})

test_that("Paint ribbons", {
  painting <- aRtsy::paint_ribbons(colors = c('#fafafa', '#000000'))
  expect_equal(!is.null(painting), TRUE)
})