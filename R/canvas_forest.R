#' Paint a Random Forest on a Canvas
#'
#' @description This function creates an artwork from randomly generated data by running a random forest classification algorithm to predict the color of each pixel on the canvas.
#'
#' @usage canvas_forest(colors, n = 1000, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param resolution  a positive integer specifying the number of pixels (resolution x resolution) of the artwork.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(6)
#' palette <- colorPalette("random", n = 5)
#' canvas_forest(colors = palette)
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @importFrom stats predict

canvas_forest <- function(colors, n = 1000, resolution = 500) {
  x <- y <- z <- NULL # Global variables
  train <- data.frame(
    x = stats::runif(n, 0, 1), # Create a training data set with x (predictor), y (predictor), z (response)
    y = stats::runif(n, 0, 1),
    z = factor(sample(colors, size = n, replace = T))
  )
  fit <- randomForest::randomForest(formula = z ~ x + y, data = train) # Fit random forest model to training data
  sequence <- seq(0, 1, length = resolution) # Create a sequence of pixels
  canvas <- expand.grid(sequence, sequence) # Create all combinations of pixels
  colnames(canvas) <- c("x", "y")
  z <- predict(fit, newdata = canvas) # Predict each pixel using the fitted model
  full_canvas <- data.frame(x = canvas$x, y = canvas$y, z = z)
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, 1)) +
    ggplot2::ylim(c(0, 1)) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
