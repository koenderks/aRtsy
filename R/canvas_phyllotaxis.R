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

#' Draw a Phyllotaxis
#'
#' @description This function draws a phyllotaxis which resembles the arrangement of leaves on a plant stem.
#'
#' @usage canvas_phyllotaxis(colors, background = '#fafafa', iterations = 10000,
#'                angle = 137.5, size = 0.01, alpha = 1, p = 0.5)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background.
#' @param iterations     the number of iterations of the algorithm.
#' @param angle          the angle at which to place the artwork.
#' @param size           the size of the lines.
#' @param alpha          transparency of the points.
#' @param p              probability of drawing a point on each iteration.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/Phyllotaxis}
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
#' canvas_phyllotaxis(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_phyllotaxis <- function(colors, background = "#fafafa", iterations = 10000,
                               angle = 137.5, size = 0.01, alpha = 1, p = 0.5) {
  .checkUserInput(background = background, iterations = iterations)
  canvas <- iterate_phyllotaxis(iterations, angle, p)
  canvas$z <- 1:nrow(canvas)
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, color = z)) +
    ggplot2::geom_point(size = size, alpha = alpha) +
    ggplot2::scale_color_gradientn(colors = colors)
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}
