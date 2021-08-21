#' Paint a forest on a canvas
#'
#' @description This function creates an artwork from randomly generated data by running a random forest classification algorithm to predict the color of each pixel on the canvas.
#'
#' @usage canvas_forest(colors, n = 1000, resolution = 500)
#'
#' @param colors   	  a character (vector) specifying the colors for the artwork.
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
#' canvas_forest(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'))
#' }
#' 
#' @keywords artwork canvas
#'
#' @export

canvas_forest <- function(colors, n = 1000, resolution = 500) {
  x <- y <- z <- NULL
  train <- data.frame(x = stats::runif(n, 0, 1), 
                      y = stats::runif(n, 0, 1), 
                      z = factor(sample(colors, size = n, replace = T)))
  fit <- randomForest::randomForest(formula = z ~ x + y, data = train)
  canvas <- expand.grid(seq(0, 1, length = resolution), seq(0, 1, length = resolution))
  colnames(canvas) <- c("x", "y")
  z <- predict(fit, newdata = canvas)
  full_canvas <- data.frame(x = canvas$x, y = canvas$y, z = z)
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, 1)) +
    ggplot2::ylim(c(0, 1)) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- aRtsy::themeCanvas(artwork, background = NULL)
  return(artwork)
}
