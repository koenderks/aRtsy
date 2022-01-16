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

#' Draw Squares and Rectangles
#'
#' @description This function paints random squares and rectangles. It works by repeatedly cutting into the canvas at random locations and coloring the area that these cuts create.
#'
#' @usage canvas_squares(colors, background = "#000000", cuts = 50, ratio = 1.618,
#'                resolution = 200, noise = FALSE)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the borders of the squares.
#' @param cuts        a positive integer specifying the number of cuts to make.
#' @param ratio       a value specifying the \code{1:1} ratio for each cut.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#' @param noise       logical. Whether to add k-nn noise to the artwork. Note that adding noise increases computation time significantly in large dimensions.
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
#' canvas_squares(colors = colorPalette("retro2"))
#' }
#'
#' @export

canvas_squares <- function(colors, background = "#000000", cuts = 50, ratio = 1.618,
                           resolution = 200, noise = FALSE) {
  .checkUserInput(resolution = resolution, background = background)
  if (cuts <= 1) {
    stop("'cuts' must be a single value >= 1")
  }
  palette <- c(background, colors)
  neighbors <- expand.grid(-1:1, -1:1)
  colnames(neighbors) <- c("x", "y")
  canvas <- matrix(0, nrow = resolution, ncol = resolution)
  full_canvas <- draw_squares(canvas, neighbors, length(colors), cuts, ratio)
  if (noise) {
    full_canvas <- full_canvas - .noise(dims = c(resolution, resolution))
  }
  full_canvas <- .unraster(full_canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = FALSE, alpha = 1) +
    ggplot2::xlim(c(0, resolution + 1)) +
    ggplot2::ylim(c(0, resolution + 1)) +
    ggplot2::scale_fill_gradientn(colours = palette)
  artwork <- theme_canvas(artwork)
  return(artwork)
}
