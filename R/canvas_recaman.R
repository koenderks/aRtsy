#' Draw Recaman's Sequence
#'
#' @description This function draws Recaman's sequence on a canvas. The algorithm takes increasingly large steps backward on the positive number line, but if it is unable to it takes a step forward.
#'
#' @usage canvas_recaman(colors, background = "#fafafa", n = 100, start = 0,
#'                increment = 1, curvature = 1, angle = 0)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background.
#' @param n              the number of steps to make in the sequence.
#' @param start          the starting point of the algorithm.
#' @param increment      the increment of each step.
#' @param curvature      the curvature of each line.
#' @param angle          the angle at which to place the artwork.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://mathworld.wolfram.com/RecamansSequence.html}
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
#' canvas_recaman(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_recaman <- function(colors, background = "#fafafa", n = 100, start = 0,
                           increment = 1, curvature = 1, angle = 0) {
  .checkUserInput(background = background)
  if (!(angle %in% c(0, 45))) {
    stop("'angle' must be either 0 or 45 degrees")
  }
  if (n < 2) {
    stop("'n' must be a single number >= 2")
  }
  if (start < 0) {
    stop("'start' must be a single number >= 0")
  }
  if (increment < 1) {
    stop("'increment' must be a single integer >= 0")
  }
  inc <- 0
  x <- xlist <- start
  for (i in 2:n) {
    inc <- inc + increment
    if ((x[i - 1] - inc) %in% xlist || (x[i - 1] - inc) <= 0) {
      x[i] <- x[i - 1] + inc
      xlist <- c(xlist, x[i - 1] + inc)
    } else {
      x[i] <- x[i - 1] - inc
      xlist <- c(xlist, x[i - 1] - inc)
    }
  }
  canvas <- data.frame(id = 1:length(x), x = x, xend = c(x[-1], x[1]))
  canvas$y <- x * sin(angle%%360)
  canvas$yend <- canvas$y[match(canvas$xend, canvas$x)]
  minx <- apply(canvas[, 2:3], 1, min)
  maxx <- apply(canvas[, 2:3], 1, max)
  miny <- apply(canvas[, 4:5], 1, min)
  maxy <- apply(canvas[, 4:5], 1, max)
  for (i in 1:nrow(canvas)) {
    if (i %% 2 == 1) {
      canvas[i, 2:5] <- c(minx[i], maxx[i], miny[i], maxy[i])
    } else {
      canvas[i, 2:5] <- c(maxx[i], minx[i], maxy[i], miny[i])
    }
  }
  artwork <- ggplot2::ggplot() +
    ggplot2::geom_curve(
      mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, color = id),
      data = canvas, curvature = curvature, ncp = 25, size = 0.1
    ) +
    ggplot2::scale_color_gradientn(colors = colors)
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}
