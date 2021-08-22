#' Paint a mosaic on a canvas
#'
#' @description This function paints a mosaic from randomly generated data by running a k-nearest neighbors classification algorithm to predict the color of each pixel on the canvas. Low values of \code{maxk} produce a mosaic like artwork, while higher values produce a more smooth decision boundary.
#'
#' @usage canvas_mosaic(colors, maxk = 10, n = 1000, resolution = 500)
#'
#' @param colors   	  a character (vector) specifying the colors for the artwork.
#' @param maxk        the maximum number of nearest neighbors to consider.
#' @param n           number of data points to generate.
#' @param resolution  the number of pixels (width and height) of the artwork.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#' canvas_mosaic(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'))
#' }
#' 
#' @keywords artwork canvas
#'
#' @export

canvas_mosaic <- function(colors, maxk = 10, n = 1000, resolution = 500) {
  x <- y <- z <- NULL
  train <- data.frame(x = stats::runif(n, 0, 1), 
                      y = stats::runif(n, 0, 1), 
                      z = factor(sample(colors, size = n, replace = T)))
  fit <- kknn::train.kknn(formula = z ~ x + y, data = train, ks = maxk)
  canvas <- expand.grid(seq(0, 1, length = resolution), seq(0, 1, length = resolution))
  colnames(canvas) <- c("x", "y")
  z <- kknn:::predict.train.kknn(fit, newdata = canvas)
  full_canvas <- data.frame(x = canvas$x, y = canvas$y, z = z)
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, 1)) +
    ggplot2::ylim(c(0, 1)) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- aRtsy::themeCanvas(artwork, background = NULL)
  return(artwork)
}
