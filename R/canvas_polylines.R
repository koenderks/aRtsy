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

#' Draw Polygons and Lines
#'
#' @description This function draws many points on the canvas and connects these points into a polygon. After repeating this for all the colors, the edges of all polygons are drawn on top of the artwork.
#'
#' @usage canvas_polylines(colors, background = "#fafafa", ratio = 0.5, iterations = 1000,
#'                  size = 0.1, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the lines.
#' @param ratio       a positive value specifying the width of the polygons. Larger ratios cause more overlap.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param size        a positive value specifying the size of the borders.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
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
#' canvas_polylines(colors = colorPalette("retro1"))
#' }
#'
#' @export

canvas_polylines <- function(colors, background = "#fafafa", ratio = 0.5, iterations = 1000,
                             size = 0.1, resolution = 500) {
  .checkUserInput(resolution = resolution, iterations = iterations)
  alphas <- seq(from = 1, to = 0.1, length.out = length(colors))
  full_canvas <- data.frame(x = numeric(), y = numeric(), type = character())
  for (i in 1:length(colors)) {
    mat <- draw_polylines(matrix(NA, nrow = iterations, ncol = 2), ratio, iterations, resolution, resolution)
    polygon <- data.frame(x = mat[, 1], y = mat[, 2], type = rep(colors[i], iterations))
    full_canvas <- rbind(full_canvas, polygon)
  }
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = type)) +
    ggplot2::xlim(c(0, resolution)) +
    ggplot2::ylim(c(0, resolution)) +
    ggplot2::geom_polygon(color = NA, alpha = rep(alphas, each = iterations)) +
    ggplot2::geom_path(color = background, size = size) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
