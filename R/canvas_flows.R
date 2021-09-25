#' Draw Flow Fields
#'
#' @description This function draws flow fields on a canvas.
#'
#' @usage canvas_flows(colors, background = "#fafafa", lines = 500, iterations = 100,
#'              angles = c("svm", "knn", "rf"), width = 100, height = 100)
#'
#' @param colors       a string specifying the color used for the artwork.
#' @param background   a character specifying the color used for the background.
#' @param lines        the number of lines to draw.
#' @param iterations   the maximum number of iterations for each line.
#' @param angles       method of setting the angles of the flow field. Possible options are \code{knn} and \code{svm}.
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
#' set.seed(1)
#'
#' # Simple example
#' canvas_flows(colors = colorPalette("dark2"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_flows <- function(colors, background = "#fafafa", lines = 500, iterations = 100,
                         angles = c("svm", "knn", "rf"), width = 100, height = 100) {
  angles <- match.arg(angles)
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
  angles <- .noise(dims = c(nrows, ncols), n = sample(100:300, size = 1), type = angles)
  plotData <- data.frame(x = numeric(), y = numeric(), z = numeric(), size = numeric(), color = numeric())
  for (j in 1:lines) {
    step <- stats::runif(1, min = 0, max = width * 0.01)
    rows <- iterate_flow(angles, j, iterations, left, right, top, bottom, step, width, height, resolution)
    rows$color <- sample(colors, size = 1)
    rows$size <- .fbmline(n = nrow(rows))
    plotData <- rbind(plotData, rows)
  }
  artwork <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y, group = factor(z))) +
    ggplot2::geom_path(size = plotData$size, color = plotData$color, lineend = "round", alpha = 1) +
    ggplot2::coord_cartesian(xlim = c(0, width), ylim = c(0, height))
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}

.fbmline <- function(n, sd = 1) {
  x <- cumsum(stats::rnorm(n = n, sd = sqrt(sd)))
  x <- abs(x / stats::sd(x) * 0.05)
  return(x)
}
