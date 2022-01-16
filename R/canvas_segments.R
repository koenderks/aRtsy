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

#' Draw Segments
#'
#' @description This function draws line segments on a canvas. The length and direction of the line segments is determined randomly.
#'
#' @usage canvas_segments(colors, background = "#fafafa", n = 250,
#'                 p = 0.5, H = 0.1, size = 0.2)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param n           a positive integer specifying the number of line segments to draw.
#' @param p           a value specifying the probability of drawing a vertical line segment.
#' @param H           a positive value specifying the scaling factor for the line segments.
#' @param size        a positive value specifying the size of the line segments.
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
#' set.seed(1)
#'
#' # Simple example
#' canvas_segments(colors = colorPalette("dark1"))
#' }
#'
#' @export

canvas_segments <- function(colors, background = "#fafafa", n = 250,
                            p = 0.5, H = 0.1, size = 0.2) {
  .checkUserInput(background = background)
  full_canvas <- data.frame(
    x = numeric(), xend = numeric(),
    y = numeric(), yend = numeric()
  )
  for (i in 1:n) {
    x <- 0.8 * stats::runif(1, 0, 1) + 0.1
    y <- 0.8 * stats::runif(1, 0, 1) + 0.1
    k <- H * (1 - sqrt(stats::runif(1, 0, 1)))
    if (stats::runif(1, 0, 1) > p) {
      row <- data.frame(x = x - k, xend = x + k, y = y, yend = y, col = sample(colors, size = 1))
    } else {
      row <- data.frame(x = x, xend = x, y = y - k, yend = y + k, col = sample(colors, size = 1))
    }
    full_canvas <- rbind(full_canvas, row)
  }
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend)) +
    ggplot2::xlim(c(0, 1)) +
    ggplot2::ylim(c(0, 1)) +
    ggplot2::geom_segment(color = full_canvas$col, size = size)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
