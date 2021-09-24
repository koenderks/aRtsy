#' Paint Flows on a Canvas
#'
#' @description This function paints watercolors on a canvas.
#'
#' @usage canvas_flows(colors, background = "#fafafa", lines = 100,
#'              iterations = 500, width = 100, height = 100)
#'
#' @param colors       a string specifying the color used for the artwork.
#' @param background   a character specifying the color used for the background.
#' @param lines        the number of lines to draw.
#' @param iterations   the maximum number of iterations for each line.
#' @param width        a positive integer specifying the width of the artwork in pixels.
#' @param height       a positive integer specifying the height of the artwork in pixels.
#'
#' @references \url{https://tylerxhobbs.com/essays/2020/flow-fields}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(10)
#' canvas_flows(colors = colorPalette("tuscany1"), lines = 500)
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_flows <- function(colors, background = "#fafafa", lines = 100,
                         iterations = 500, width = 100, height = 100) {
  x <- y <- z <- NULL
  resolution <- round(width * 0.01)
  xsequence <- seq(0, width, length = width)
  ysequence <- seq(0, height, length = height)
  grid <- expand.grid(xsequence, ysequence)
  grid <- data.frame(x = grid[, 1], y = grid[, 2], z = 0)
  left <- width * -0.5
  right <- width * 1.5
  bottom <- height * -0.5
  top <- height * 1.5
  ncols <- (right - left) / resolution
  nrows <- (top - bottom) / resolution
  angles <- .angles(dims = c(nrows, ncols), n = sample(100:300, size = 1))
  plotData <- data.frame(x = numeric(), y = numeric(), z = numeric(), size = numeric(), color = numeric())
  for (j in 1:lines) {
    step <- stats::runif(1, min = 0, max = width * 0.01)
    rows <- iterate_flow(angles, j, iterations, left, right, top, bottom, step, width, height, resolution)
    rows$color <- sample(colors, size = 1)
    size <- cumsum(stats::rnorm(n = nrow(rows), sd = sqrt(1)))
    rows$size <- abs(size / sd(size) * 0.05)
    plotData <- rbind(plotData, rows)
  }
  artwork <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y, group = factor(z))) +
    ggplot2::geom_path(size = plotData$size, color = plotData$color, lineend = "round", alpha = 1) +
    ggplot2::coord_cartesian(xlim = c(0, width), ylim = c(0, height))
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}

.angles <- function(dims, n) {
  train <- data.frame(
    x = stats::runif(n, -3, 3),
    y = stats::runif(n, -3, 3),
    z = stats::runif(n, -3, 3)
  )
  s <- sample(0:1, size = 1)
  if (s == 1) {
    fit <- kknn::train.kknn(formula = z ~ x + y, data = train)
  } else {
    fit <- e1071::svm(formula = z ~ x + y, data = train)
  }
  xsequence <- seq(-3, 3, length = dims[1])
  ysequence <- seq(-3, 3, length = dims[2])
  canvas <- expand.grid(xsequence, ysequence)
  colnames(canvas) <- c("x", "y")
  z <- predict(fit, newdata = canvas)
  angles <- matrix(z, nrow = dims[1], ncol = dims[2])
}
