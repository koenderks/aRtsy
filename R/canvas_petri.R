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

#' Draw Petri-dish Colonies
#'
#' @description This function uses a space colony algorithm.
#'
#' @usage canvas_petri(colors, background = "#fafafa", circle = "black",
#'                 attractors = 1000, hole = 0)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background.
#' @param circle         a character specifying the color used for the circle.
#' @param attractors     a numeric value larger than 1000 specifying the number of attractors.
#' @param hole           a value between 0 and 0.9 specifying the hole width.
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
#' set.seed(2)
#'
#' # Simple example
#' canvas_petri(colors = colorPalette("origami"))
#'
#' # Advanced example
#' canvas_petri(colors = "black", hole = 0.8)
#' }
#'
#' @export

canvas_petri <- function(colors, background = "#fafafa", circle = "black",
                         attractors = 1000, hole = 0) {
  if (hole < 0 || hole > 0.9) {
    stop("'hole' must be between 0 and 0.9")
  }
  attraction_distance <- pi * (1 + hole)
  kill_distance <- 0.05
  nodes <- length(colors)
  # 1. Place a set of attractors and nodes
  r <- pi * sqrt(stats::runif(attractors, min = hole, max = 1))
  theta <- stats::runif(attractors) * 2 * pi
  attractor_data <- data.frame(x = r * cos(theta), y = r * sin(theta))
  r <- pi * sqrt(stats::runif(nodes, min = hole * 1.1, max = 0.99))
  theta <- stats::runif(nodes) * 2 * pi
  node_data <- data.frame(x = r * cos(theta), y = r * sin(theta), z = 1:nodes, t = 0)
  node_data$xend <- node_data$x # xend is the node's x location
  node_data$yend <- node_data$y # yend is the node's y location
  t <- 0
  while (nrow(attractor_data) > attractors / 3) {
    distances <- list()
    closest_nodes <- list()
    for (i in 1:nrow(attractor_data)) {
      # 2. Associate each attractor with the single closest node within the pre-defined attraction distance.
      distances[[i]] <- sqrt(abs(attractor_data$x[i] - node_data$xend)^2 + abs(attractor_data$y[i] - node_data$yend)^2)
      names(distances[[i]]) <- 1:nrow(node_data)
      closest_nodes[[i]] <- as.numeric(names(which.min(distances[[i]][which(distances[[i]] < attraction_distance)])))
    }
    if (all(lengths(closest_nodes) == 0)) {
      break
    }

    directions <- data.frame(x = numeric(nrow(node_data)), y = numeric(nrow(node_data)))
    for (i in 1:nrow(node_data)) {
      # 3. For each node, calculate the average direction towards all of the attractors influencing it.
      use_nodes <- which(sapply(seq_along(closest_nodes), function(x) {
        i %in% closest_nodes[[x]]
      }))
      directions$xend[i] <- mean(attractor_data$x[use_nodes] - node_data$xend[i])
      directions$yend[i] <- mean(attractor_data$y[use_nodes] - node_data$yend[i])
    }

    # 4. Calculate the positions of new nodes by normalizing this average direction to a unit vector, then scaling it by a pre-defined segment length.
    directions$xend <- (directions$xend / sqrt(sum(directions$xend^2, na.rm = TRUE))) / (1 + hole)
    directions$yend <- (directions$yend / sqrt(sum(directions$yend^2, na.rm = TRUE))) / (1 + hole)
    t <- t + 1
    new_nodes <- data.frame(
      xend = node_data$xend + directions$xend,
      yend = node_data$yend + directions$yend,
      z = node_data$z, t = t
    )
    new_nodes$x <- node_data$xend
    new_nodes$y <- node_data$yend
    new_nodes <- new_nodes[stats::complete.cases(new_nodes), ]

    # 5. Place nodes at the calculated positions.
    node_data <- rbind(node_data, new_nodes)

    # 6. Check if any nodes are inside any attractors kill zones.
    kills <- numeric()
    for (i in 1:nrow(attractor_data)) {
      if (any(abs(sqrt((attractor_data$x[i] - node_data$x)^2 + (attractor_data$y[i] - node_data$y)^2)) < kill_distance)) {
        kills[length(kills) + 1] <- i
      }
    }

    # 7. Attractors are pruned as soon as any node enters its kill distance.
    if (length(kills) != 0) {
      attractor_data <- attractor_data[-kills, ]
    }
    #cat("Attractors left: ", nrow(attractor_data), "\n")
    # 8. Begin the process over again from step 2
  }
  circle_data <- .circle_points(center = c(0, 0), diameter = 2 * pi, npoints = 100)
  circle_data2 <- .circle_points(center = c(0, 0), diameter = 2 * pi * hole, npoints = 100)
  limits <- range(pretty(c(node_data$x, node_data$xend, node_data$y, node_data$yend, circle_data$x, circle_data$y)))
  node_data$size <- (max(node_data$t) - node_data$t) / max(node_data$t)
  artwork <- ggplot2::ggplot(data = node_data, mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = factor(z))) +
    ggplot2::geom_polygon(data = circle_data, mapping = ggplot2::aes(x = x, y = y), inherit.aes = FALSE, fill = circle) +
    ggplot2::geom_polygon(data = circle_data2, mapping = ggplot2::aes(x = x, y = y), inherit.aes = FALSE, fill = background) +
    ggplot2::geom_segment(mapping = ggplot2::aes(color = factor(z)), size = node_data$size, linejoin = "round", lineend = "round") +
    ggplot2::scale_color_manual(values = colors) +
    ggplot2::coord_equal(xlim = limits, ylim = limits)
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}

.circle_points <- function(center = c(0, 0), diameter = 1, npoints = 100) {
  r <- diameter / 2
  tt <- seq(0, 2 * pi, length.out = npoints)
  xx <- center[1] + r * cos(tt)
  yy <- center[2] + r * sin(tt)
  return(data.frame(x = xx, y = yy))
}
