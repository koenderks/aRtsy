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

#' Draw Split Lines
#'
#' @description This function draws split lines.
#'
#' @usage canvas_splits(colors, background = "#fafafa", iterations = 6,
#'               sd = 0.2, lwd = 0.05, alpha = 0.5)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background (and the hole).
#' @param iterations     a positive integer specifying the number of iterations of the algorithm.
#' @param sd             a numeric value specifying the standard deviation of the angle noise.
#' @param lwd            a numeric value specifying the width of the lines.
#' @param alpha          a numeric value specifying the transparency of the lines.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords artwork canvas
#'
#' @seealso \code{colorPalette}
#'
#' @examples
#' \donttest{
#' set.seed(2)
#'
#' # Simple example
#' canvas_splits(colors = "black", sd = 0)
#'
#' # Simple example
#' canvas_splits(colors = colorPalette("dark2"), background = "black", sd = 1)
#' }
#'
#' @export

canvas_splits <- function(colors, background = "#fafafa", iterations = 6,
                          sd = 0.2, lwd = 0.05, alpha = 0.5) {
  .checkUserInput(iterations = iterations, background = background)
  if (sd < 0) {
    stop("'sd' must be >= 0")
  }
  line <- data.frame(
    x = c(0, 1, 1, 0), xend = c(1, 1, 0, 0),
    y = c(0, 0, 1, 1), yend = c(0, 1, 1, 0),
    col = sample(1:length(colors), size = 4, replace = TRUE)
  )
  canvas <- draw_splits(line$x, line$xend, line$y, line$yend, line$col, sd, length(colors), iterations)
  breaks <- range(c(canvas$x, canvas$xend, canvas$y, canvas$yend))
  p <- ggplot2::ggplot(data = canvas) +
    ggplot2::geom_segment(mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, col = factor(col)), size = lwd, alpha = alpha) +
    ggplot2::scale_x_continuous(limits = breaks) +
    ggplot2::scale_y_continuous(limits = breaks) +
    ggplot2::scale_color_manual(values = colors)
  p <- theme_canvas(p, background = background)
  return(p)
}
