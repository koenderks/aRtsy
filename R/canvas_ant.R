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

#' Draw Langton's Ant
#'
#' @description This function draws Langton's Ant on a canvas. Langton's ant is a two-dimensional universal Turing machine with a very simple set of rules. These simple rules can lead to complex emergent behavior.
#'
#' @usage canvas_ant(colors, background = "#fafafa", iterations = 50000,
#'            resolution = 500)
#'
#' @param colors      a character (vector) specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @details The algorithm for Langton's Ant involves repeating the following rules: 1) on a non-colored block: turn 90 degrees clockwise, un-color the block, move forward one block; 2)
#'          On a colored block: turn 90 degrees counter-clockwise, color the block, move forward one block; 3) If a certain number of iterations has passed, choose a different color which corresponds to a different combination of these rules.
#'
#' @references \url{https://en.wikipedia.org/wiki/Langtons_ant}
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
#' canvas_ant(colors = colorPalette("house"))
#' }
#'
#' @export

canvas_ant <- function(colors, background = "#fafafa", iterations = 50000,
                       resolution = 500) {
  .checkUserInput(
    background = background, resolution = resolution, iterations = iterations
  )
  if (iterations < length(colors)) {
    stop(paste0("'iterations' must be >= ", length(colors)))
  }
  palette <- c(background, colors)
  directions <- .ant_directions(length(colors))
  canvas <- matrix(0, nrow = resolution, ncol = resolution)
  full_canvas <- draw_ant(
    X = canvas, iters = iterations, ncolors = length(colors),
    x = sample(ceiling(resolution * 0.05):ceiling(resolution * 0.95), size = 1),
    y = sample(ceiling(resolution * 0.05):ceiling(resolution * 0.95), size = 1),
    dx = directions[, 1], dy = directions[, 2]
  )
  full_canvas <- .unraster(full_canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::xlim(c(0, resolution + 1)) +
    ggplot2::ylim(c(0, resolution + 1)) +
    ggplot2::scale_fill_gradientn(colours = palette)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}

.ant_directions <- function(n) {
  sequence <- rep(0:1, n) # Create a sequence of 0 (L) and 1 (R) positions
  pos <- expand.grid(sequence, sequence) # Create a matrix that holds all possible combinations of 0 (L) and 1 (R)
  pos <- pos[which(pos[, 1] == pos[, 2]), ]
  pos[2:nrow(pos), ] <- pos[sample(2:nrow(pos)), ] # Mix the possible positions randomly
  pos <- pos[1:n, ] # Select only as many positions as there are colors given by the user
  return(pos)
}
