# Copyright (C) 2021-2022 Koen Derks

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Draw Recaman's Sequence
#'
#' @description This function draws Recaman's sequence on a canvas. The algorithm takes increasingly large steps backward on the positive number line, but if it is unable to it takes a step forward.
#'
#' @usage canvas_recaman(colors, background = "#fafafa", iterations = 100, start = 0,
#'                increment = 1, curvature = 1, angle = 0, size = 0.1,
#'                closed = FALSE)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background.
#' @param iterations     the number of iterations of the algorithm.
#' @param start          the starting point of the algorithm.
#' @param increment      the increment of each step.
#' @param curvature      the curvature of each line.
#' @param angle          the angle at which to place the artwork.
#' @param size           the size of the lines.
#' @param closed         logical. Whether to plot a curve from the end of the sequence back to the starting point.
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

canvas_recaman <- function(colors, background = "#fafafa", iterations = 100, start = 0,
                           increment = 1, curvature = 1, angle = 0, size = 0.1,
                           closed = FALSE) {
  .checkUserInput(background = background, iterations = iterations)
  if (!(angle %in% c(0, 45))) {
    stop("'angle' must be either 0 or 45 degrees")
  }
  iterations <- max(2, iterations)
  if (start < 0) {
    stop("'start' must be a single number >= 0")
  }
  if (increment < 1) {
    stop("'increment' must be a single integer >= 0")
  }
  x <- iterate_recaman(iterations, start, increment)
  if (closed) {
    xend <- c(x[-1], x[1])
  } else {
    xend <- x[-1]
    x <- x[-length(x)]
  }
  canvas <- data.frame(z = 1:length(x), x = x, xend = xend)
  canvas$y <- x * sin(angle %% 360)
  canvas$yend <- canvas$y[match(canvas$xend, canvas$x)]
  minx <- apply(canvas[, 2:3], 1, min, na.rm = TRUE)
  maxx <- apply(canvas[, 2:3], 1, max, na.rm = TRUE)
  miny <- apply(canvas[, 4:5], 1, min, na.rm = TRUE)
  maxy <- apply(canvas[, 4:5], 1, max, na.rm = TRUE)
  for (i in 1:nrow(canvas)) {
    if (i %% 2 == 1) {
      canvas[i, 2:5] <- c(minx[i], maxx[i], miny[i], maxy[i])
    } else {
      canvas[i, 2:5] <- c(maxx[i], minx[i], maxy[i], miny[i])
    }
  }
  if (!closed && angle == 45) {
    canvas <- canvas[-nrow(canvas), ]
  }
  artwork <- ggplot2::ggplot() +
    ggplot2::geom_curve(
      mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, color = z),
      data = canvas, curvature = curvature, ncp = 25, size = size
    ) +
    ggplot2::scale_color_gradientn(colors = colors)
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}
