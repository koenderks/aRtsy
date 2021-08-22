#' Paint a gemstone on a canvas
#'
#' @description This function creates an artwork from randomly generated data by running a k-nearest neighbors regression algorithm to predict the color of each pixel on the canvas.
#'
#' @usage canvas_gemstone(colors, maxk = 1, n = 1000, resolution = 500)
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
#' canvas_gemstone(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'))
#' }
#' 
#' @keywords artwork canvas
#'
#' @export
#' @importFrom stats predict

canvas_gemstone <- function(colors, maxk = 1, n = 1000, resolution = 500) {
  x <- y <- z <- NULL
  train <- data.frame(x = stats::runif(n, 0, 1), 
                      y = stats::runif(n, 0, 1), 
                      z = stats::runif(n, 0, 1))
  fit <- kknn::train.kknn(formula = z ~ x + y, data = train)
  canvas <- expand.grid(seq(0, 1, length = resolution), seq(0, 1, length = resolution))
  colnames(canvas) <- c("x", "y")
  z <- predict(fit, newdata = canvas)
  full_canvas <- data.frame(x = canvas$x, y = canvas$y, z = z)
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, 1)) +
    ggplot2::ylim(c(0, 1)) +
    ggplot2::scale_fill_gradientn(colours = colors)
  artwork <- aRtsy::themeCanvas(artwork, background = NULL)
  return(artwork)
}
