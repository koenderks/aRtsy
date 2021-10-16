#' Draw A Flow Field
#'
#' @description This function draws flow fields on a canvas.
#'
#' @usage canvas_flow(colors, background = "#fafafa", lines = 500, lwd = 0.05,
#'             iterations = 100, stepmax = 1, angles = NULL)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background.
#' @param lines          the number of lines to draw.
#' @param lwd            expansion factor for the line width.
#' @param iterations     the maximum number of iterations for each line.
#' @param stepmax        the maximum proportion of the canvas covered in each iteration.
#' @param angles         optional, a 200 x 200 matrix containing the angles of the flow field . If \code{NULL} (default), angles are set according to the predictions of a supervised learning algorithm.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://tylerxhobbs.com/essays/2020/flow-fields}
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
#' canvas_flow(colors = colorPalette("dark2"))
#'
#' # Advanced example
#' angles <- matrix(rnorm(200 * 200), nrow = 200, ncol = 200)
#' canvas_flow(colors = colorPalette("tuscany1"), angles = angles)
#' }
#'
#' @export

canvas_flow <- function(colors, background = "#fafafa", lines = 500, lwd = 0.05,
                        iterations = 100, stepmax = 0.01, angles = NULL) {
  .checkUserInput(
    background = background, iterations = iterations
  )
  r <- round(100 * 0.01)
  sequence <- seq(0, 100, length = 100)
  grid <- expand.grid(sequence, sequence)
  grid <- data.frame(x = grid[, 1], y = grid[, 2], z = 0)
  left <- 100 * -0.5
  right <- 100 * 1.5
  bottom <- 100 * -0.5
  top <- 100 * 1.5
  ncols <- (right - left) / r
  nrows <- (top - bottom) / r
  if (is.null(angles)) {
    angles <- .noise(
      dims = c(nrows, ncols), n = sample(100:300, size = 1),
      type = sample(c("knn", "svm", "rf"), size = 1),
      limits = c(-pi, pi)
    )
  } else {
    if (!is.matrix(angles)) {
      stop("'angles' must be a matrix")
    }
    if (nrow(angles) != nrows || ncol(angles) != ncols) {
      stop(paste0("'angles' must be a ", nrows, " x ", ncols, " matrix"))
    }
  }
  plotData <- data.frame(x = numeric(), y = numeric(), z = numeric(), size = numeric(), color = numeric())
  for (j in 1:lines) {
    step <- stats::runif(1, min = 0, max = 100 * stepmax)
    rows <- iterate_flow(angles, j, iterations, left, right, top, bottom, step, r)
    rows$color <- sample(colors, size = 1)
    rows$size <- .bmline(n = nrow(rows), lwd)
    plotData <- rbind(plotData, rows)
  }
  artwork <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y, group = factor(z))) +
    ggplot2::geom_path(size = plotData$size, color = plotData$color, lineend = "round") +
    ggplot2::coord_cartesian(xlim = c(0, 100), ylim = c(0, 100))
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}

.bmline <- function(n, lwd) {
  x <- cumsum(stats::rnorm(n = n, sd = sqrt(1)))
  x <- abs(x / stats::sd(x) * lwd)
  return(x)
}
