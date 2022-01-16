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

#' Draw Planets
#'
#' @description This function paints one or multiple planets and uses a cellular automata to fill their surfaces.
#'
#' @usage canvas_planet(colors, threshold = 4, iterations = 200,
#'               starprob = 0.01, fade = 0.2,
#'               radius = NULL, center.x = NULL, center.y = NULL,
#'               light.right = TRUE, resolution = 1500)
#'
#' @param colors      a character specifying the colors used for a single planet. Can also be a list where each entry is a vector of colors for a planet.
#' @param threshold   a character specifying the threshold for a color take.
#' @param starprob    a value specifying the probability of drawing a star in outer space.
#' @param fade        a value specifying the amount of fading to apply.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param radius      a numeric (vector) specifying the radius of the planet(s).
#' @param center.x    the x-axis coordinate(s) for the center(s) of the planet(s).
#' @param center.y    the y-axis coordinate(s) for the center(s) of the planet(s).
#' @param light.right whether to draw the light from the right or the left.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @references \url{https://fronkonstin.com/2021/01/02/neighborhoods-experimenting-with-cyclic-cellular-automata/}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#'
#' # Simple example
#' canvas_planet(colors = colorPalette("retro3"))
#'
#' # Advanced example
#' colors <- list(
#'   c("khaki1", "lightcoral", "lightsalmon"),
#'   c("dodgerblue", "forestgreen", "white"),
#'   c("gray", "darkgray", "beige")
#' )
#' canvas_planet(colors,
#'   radius = c(800, 400, 150),
#'   center.x = c(1, 500, 1100),
#'   center.y = c(1400, 500, 1000),
#'   starprob = 0.005
#' )
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_planet <- function(colors, threshold = 4, iterations = 200, starprob = 0.01, fade = 0.2,
                          radius = NULL, center.x = NULL, center.y = NULL, light.right = TRUE,
                          resolution = 1500) {
  .checkUserInput(resolution = resolution, iterations = iterations)
  if (is.list(colors)) {
    palette <- list()
    for (i in 1:length(colors)) {
      palette[[i]] <- c("#000000", "#787878", "#fafafa", colors[[i]])
    }
  } else {
    palette <- list(c("#000000", "#787878", "#fafafa", colors))
    colors <- list(colors)
  }
  canvas <- matrix(0, nrow = resolution, ncol = resolution)
  if (is.null(radius)) {
    radius <- ceiling(resolution / 2 / 1.5)
  }
  if (is.null(center.x)) {
    center.x <- ceiling(resolution / 2)
  }
  if (is.null(center.y)) {
    center.y <- ceiling(resolution / 2)
  }
  if (length(unique(c(length(radius), length(center.y), length(center.x)))) != 1) {
    stop("Radius, center.y, and center.x do not have equal length.")
  }
  if (light.right) {
    lightright <- 1
  } else {
    lightright <- 0
  }
  planets <- length(radius)
  colorsused <- 0
  for (i in 1:planets) {
    canvas <- draw_planet(
      X = canvas,
      radius = radius[i],
      xcenter = center.x[i],
      ycenter = center.y[i],
      threshold = threshold,
      iterations = ceiling(iterations / i),
      starprob = starprob,
      ncolors = length(palette[[i]]),
      colorsused = colorsused,
      fade = fade,
      lightright = lightright
    )
    colorsused <- colorsused + length(colors[[i]])
  }
  full_canvas <- .unraster(canvas, names = c("y", "x", "z")) # Convert 2D matrix to data frame
  full_palette <- c("#000000", "#787878", "#fafafa", unlist(colors))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::xlim(c(0, resolution + 1)) +
    ggplot2::ylim(c(0, resolution + 1)) +
    ggplot2::scale_fill_gradientn(colours = full_palette)
  artwork <- theme_canvas(artwork)
  return(artwork)
}
