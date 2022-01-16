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

#' Draw a Circle Map
#'
#' @description This function draws a circle map on the canvas. A circle map models the dynamics of a physical system consisting of two rotors or disks, one free to spin, and another one attached to a motor, with a long (weak) spring connecting the two.
#'
#' @usage canvas_circlemap(colors, left = 0, right = 12.56, bottom = 0, top = 1,
#'                  iterations = 10, resolution = 1500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param left        a value specifying the minimum location on the x-axis.
#' @param right       a value specifying the maximum location on the x-axis.
#' @param bottom      a value specifying the minimum location on the y-axis.
#' @param top         a value specifying the maximum location on the y-axis.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/Arnold_tongue}
#' @references \url{https://linas.org/art-gallery/circle-map/circle-map.html}
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords artwork canvas
#'
#' @seealso \code{colorPalette}
#'
#' @examples
#' \donttest{
#' canvas_circlemap(colors = colorPalette("dark2"))
#' }
#'
#' @export

canvas_circlemap <- function(colors, left = 0, right = 12.56, bottom = 0, top = 1,
                             iterations = 10, resolution = 1500) {
  .checkUserInput(resolution = resolution)
  canvas <- matrix(1, nrow = resolution, ncol = resolution)
  canvas <- draw_circlemap(
    X = canvas, left = left, right = right,
    bottom = bottom, top = top, iters = iterations
  )
  canvas <- (canvas / iterations) / length(colors)
  full_canvas <- .unraster(canvas, names = c("y", "x", "z"))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::xlim(c(0, resolution + 1)) +
    ggplot2::ylim(c(0, resolution + 1)) +
    ggplot2::scale_fill_gradientn(colours = colors)
  artwork <- theme_canvas(artwork)
  return(artwork)
}
