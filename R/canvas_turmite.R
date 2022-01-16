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

#' Draw Turmites
#'
#' @description This function paints a turmite. A turmite is a Turing machine which has an orientation in addition to a current state and a "tape" that consists of a two-dimensional grid of cells.
#'
#' @usage canvas_turmite(colors, background = "#fafafa", p = 0.5, iterations = 1e6,
#'                resolution = 500, noise = FALSE)
#'
#' @param colors       a character specifying the color used for the artwork. The number of colors determines the number of turmites.
#' @param background  a character specifying the color used for the background.
#' @param p           a value specifying the probability of a state switch within the turmite.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#' @param noise       logical. Whether to add k-nn noise to the artwork. Note that adding noise increases computation time significantly in large dimensions.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @details The turmite algorithm consists of the following steps: 1) turn on the spot (left, right, up, down) 2) change the color of the square 3) move forward one square.
#'
#' @references \url{https://en.wikipedia.org/wiki/Turmite}
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
#' canvas_turmite(colors = colorPalette("dark2"))
#' }
#'
#' @export

canvas_turmite <- function(colors, background = "#fafafa", p = 0.5, iterations = 1e6,
                           resolution = 500, noise = FALSE) {
  .checkUserInput(
    resolution = resolution, background = background, iterations = iterations
  )
  palette <- c(background, colors)
  canvas <- matrix(0, nrow = resolution, ncol = resolution)
  for (i in 1:length(colors)) {
    k <- sample(0:1, size = 1)
    row <- 0
    col <- 0
    if (k == 1) {
      col <- sample(0:(resolution - 1), size = 1)
    }
    if (k == 0) {
      row <- sample(0:(resolution - 1), size = 1)
    }
    turmite <- draw_turmite(matrix(0, nrow = resolution, ncol = resolution), iterations, row, col, p = p)
    if (noise) {
      turmite[which(turmite == 0)] <- NA
      turmite <- turmite - .noise(dims = c(resolution, resolution))
      turmite[which(is.na(turmite))] <- 0
    }
    canvas <- canvas + turmite
  }
  full_canvas <- .unraster(canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::xlim(c(0, resolution + 1)) +
    ggplot2::ylim(c(0, resolution + 1)) +
    ggplot2::scale_fill_gradientn(colours = palette)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
