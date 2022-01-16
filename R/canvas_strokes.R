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

#' Draw Strokes
#'
#' @description This function creates an artwork that resembles paints strokes. The algorithm is based on the simple idea that each next point on the grid has a chance to take over the color of an adjacent colored point but also has a change of generating a new color.
#'
#' @usage canvas_strokes(colors, neighbors = 1, p = 0.01, iterations = 1,
#'                resolution = 500, side = FALSE)
#'
#' @param colors     a string or character vector specifying the color(s) used for the artwork.
#' @param neighbors  a positive integer specifying the number of neighbors a block considers when taking over a color. More neighbors fades the artwork.
#' @param p          a value specifying the probability of selecting a new color at each block. A higher probability adds more noise to the artwork.
#' @param iterations a positive integer specifying the number of iterations of the algorithm. More iterations generally apply more fade to the artwork.
#' @param resolution resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#' @param side       logical. Whether to put the artwork on its side.
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
#' canvas_strokes(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_strokes <- function(colors, neighbors = 1, p = 0.01, iterations = 1,
                           resolution = 500, side = FALSE) {
  .checkUserInput(
    resolution = resolution, iterations = iterations
  )
  if (neighbors < 1 || neighbors %% 1 != 0 || length(neighbors) != 1) {
    stop("'neighbors' must be a single integer >= 1")
  }
  if (length(colors) == 1) {
    colors <- c("#fafafa", colors)
  }
  neighborsLocations <- expand.grid(-(neighbors):neighbors, -(neighbors):neighbors)
  colnames(neighborsLocations) <- c("x", "y")
  canvas <- matrix(0, nrow = resolution, ncol = resolution)
  for (i in 1:iterations) {
    canvas <- draw_strokes(X = canvas, neighbors = neighborsLocations, s = length(colors), p = p)
  }
  full_canvas <- .unraster(canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::xlim(c(0, resolution + 1)) +
    ggplot2::ylim(c(0, resolution + 1)) +
    ggplot2::scale_fill_gradientn(colours = colors)
  if (side) {
    artwork <- artwork + ggplot2::coord_flip()
  }
  artwork <- theme_canvas(artwork)
  return(artwork)
}
