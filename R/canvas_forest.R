#' Draw a Random Forest
#'
#' @description This function draws the predictions from a random forest algorithm trained on randomly generated categorical data.
#'
#' @usage canvas_forest(colors, n = 1000, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/Random_forest}
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
#' canvas_forest(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_forest <- function(colors, n = 1000, resolution = 500) {
  .checkUserInput(resolution = resolution)
  train <- data.frame(
    x = stats::runif(n, 0, 1),
    y = stats::runif(n, 0, 1),
    z = factor(sample(colors, size = n, replace = TRUE))
  )
  fit <- randomForest::randomForest(formula = z ~ x + y, data = train)
  sequence <- seq(0, 1, length = resolution)
  canvas <- expand.grid(sequence, sequence)
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
