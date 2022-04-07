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

#' Draw Petri Dish Colonies
#'
#' @description This function uses a space colony algorithm to draw Petri dish colonies.
#'
#' @usage canvas_petri(colors, background = "#fafafa", dish = "black",
#'              attractors = 1000, iterations = 15, hole = 0)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background (and the hole).
#' @param dish           a character specifying the color used for the Petri dish.
#' @param attractors     an integer specifying the number of attractors.
#' @param iterations     a positive integer specifying the number of iterations of the algorithm.
#' @param hole           a value between 0 and 0.9 specifying the hole size in proportion to the dish.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://medium.com/@jason.webb/space-colonization-algorithm-in-javascript-6f683b743dc5}
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
#' canvas_petri(colors = colorPalette("origami"))
#'
#' # Advanced example
#' canvas_petri(colors = "white", hole = 0.8, attractors = 5000)
#' }
#'
#' @export

canvas_petri <- function(colors, background = "#fafafa", dish = "black",
                         attractors = 1000, iterations = 15, hole = 0) {
  .checkUserInput(iterations = iterations)
  if (hole < 0 || hole > 0.9 || length(hole) != 1 || !is.numeric(hole)) {
    stop("'hole' must be a single value > 0 and < 0.9")
  }
  attraction_distance <- pi * (1 + hole)
  kill_distance <- attraction_distance / 50
  nodes <- length(colors)
  r <- pi * sqrt(stats::runif(attractors, min = hole, max = 1))
  theta <- stats::runif(attractors) * 2 * pi
  attractor_data <- data.frame(x = r * cos(theta), y = r * sin(theta))
  r <- pi * sqrt(stats::runif(nodes, min = hole * 1.01, max = 0.99))
  theta <- stats::runif(nodes) * 2 * pi
  node_data <- data.frame(x = r * cos(theta), y = r * sin(theta), z = 1:nodes, t = 0)
  node_data$xend <- node_data$x # Node x-location
  node_data$yend <- node_data$y # Node y-location
  for (i in 1:iterations) {
    closest_nodes <- get_closest_node(attractor_data$x, attractor_data$y, node_data$xend, node_data$yend, attraction_distance)
    if (all(closest_nodes == 0)) {
      break
    }
    directions <- get_directions(attractor_data$x, attractor_data$y, node_data$xend, node_data$yend, closest_nodes)
    directions$xend <- (directions$xend / sqrt(sum(directions$xend^2, na.rm = TRUE))) / 1.5
    directions$yend <- (directions$yend / sqrt(sum(directions$yend^2, na.rm = TRUE))) / 1.5
    new_nodes <- data.frame(
      x = node_data$xend, y = node_data$yend,
      z = node_data$z, t = i,
      xend = node_data$xend + directions$xend,
      yend = node_data$yend + directions$yend
    )
    new_nodes <- new_nodes[stats::complete.cases(new_nodes), ]
    node_data[nrow(node_data) + 1:nrow(new_nodes), ] <- new_nodes
    attractor_data <- kill_attractors(attractor_data$x, attractor_data$y, node_data$x, node_data$y, kill_distance)
    if (nrow(attractor_data) < 1) {
      break
    }
  }
  circle_points <- draw_circle(center_x = 0, center_y = 0, diameter = 2 * pi, n = 100)
  hole_points <- draw_circle(center_x = 0, center_y = 0, diameter = 2 * pi * hole, n = 100)
  limits <- range(pretty(c(node_data$x, node_data$xend, node_data$y, node_data$yend, circle_points$x, circle_points$y)))
  node_data$size <- (max(node_data$t) - node_data$t) / max(node_data$t)
  artwork <- ggplot2::ggplot(data = node_data, mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = factor(z))) +
    ggplot2::geom_polygon(data = circle_points, mapping = ggplot2::aes(x = x, y = y), inherit.aes = FALSE, fill = dish) +
    ggplot2::geom_polygon(data = hole_points, mapping = ggplot2::aes(x = x, y = y), inherit.aes = FALSE, fill = background) +
    ggplot2::geom_segment(mapping = ggplot2::aes(color = factor(z)), size = node_data$size, linejoin = "round", lineend = "round") +
    ggplot2::scale_color_manual(values = colors) +
    ggplot2::coord_equal(xlim = limits, ylim = limits)
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}
