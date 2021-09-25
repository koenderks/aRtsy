#' Draw Moisaics
#'
#' @description This function draws mosaics by running a k-nearest neighbors classification algorithm on randomly generated data to predict the color of each pixel on the canvas.
#'
#' @usage canvas_mosaic(colors, n = 1000, width = 500, height = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#'
#' @references \url{https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#'
#' # Simple example
#' canvas_mosaic(colors = colorPalette("retro2"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @importFrom stats predict

canvas_mosaic <- function(colors, n = 1000, width = 500, height = 500) {
  .checkUserInput(width = width, height = height)
  train <- data.frame(
	x = stats::runif(n, 0, 1),
	y = stats::runif(n, 0, 1),
	z = factor(sample(colors, size = n, replace = TRUE))
  )
  fit <- kknn::train.kknn(formula = z ~ x + y, data = train, kmax = 1)
  xsequence <- seq(0, 1, length = width)
  ysequence <- seq(0, 1, length = height)
  canvas <- expand.grid(xsequence, ysequence)
  colnames(canvas) <- c("x", "y")
  z <- predict(fit, newdata = canvas)
  canvas <- matrix(z, nrow = height, ncol = width)
  canvas <- .unraster(canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, width)) +
    ggplot2::ylim(c(0, height)) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
