#' Draw Moisaics
#'
#' @description This function draws the predictions from a k-nearest neighbors algorithm trained on randomly generated categorical data.
#'
#' @usage canvas_mosaic(colors, n = 1000, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm}
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords artwork canvas
#'
#' @seealso \code{colorPalette}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#'
#' # Simple example
#' canvas_mosaic(colors = colorPalette("retro2"))
#' }
#'
#' @export

canvas_mosaic <- function(colors, n = 1000, resolution = 500) {
  .checkUserInput(resolution = resolution)
  train <- data.frame(
    x = stats::runif(n, 0, 1),
    y = stats::runif(n, 0, 1),
    z = factor(sample(colors, size = n, replace = TRUE))
  )
  fit <- kknn::train.kknn(formula = z ~ x + y, data = train, kmax = 1)
  sequence <- seq(0, 1, length = resolution)
  canvas <- expand.grid(sequence, sequence)
  colnames(canvas) <- c("x", "y")
  z <- predict(fit, newdata = canvas)
  canvas <- matrix(z, nrow = resolution, ncol = resolution)
  canvas <- .unraster(canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, resolution)) +
    ggplot2::ylim(c(0, resolution)) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- theme_canvas(artwork)
  return(artwork)
}
