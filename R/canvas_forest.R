#' Draw a Random Forest
#'
#' @description This function creates an artwork from randomly generated data by running a random forest classification algorithm to predict the color of each pixel on the canvas.
#'
#' @usage canvas_forest(colors, n = 1000, width = 500, height = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
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
#' canvas_forest(colors = colorPalette("tuscany1"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @importFrom stats predict

canvas_forest <- function(colors, n = 1000, width = 500, height = 500) {
  train <- data.frame(
    x = stats::runif(n, 0, 1),
    y = stats::runif(n, 0, 1),
    z = factor(sample(colors, size = n, replace = TRUE))
  )
  fit <- randomForest::randomForest(formula = z ~ x + y, data = train)
  xsequence <- seq(0, 1, length = width)
  ysequence <- seq(0, 1, length = height)
  canvas <- expand.grid(xsequence, ysequence)
  colnames(canvas) <- c("x", "y")
  z <- predict(fit, newdata = canvas)
  full_canvas <- data.frame(x = canvas$x, y = canvas$y, z = z)
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, 1)) +
    ggplot2::ylim(c(0, 1)) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
