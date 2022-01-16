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

#' Draw Diamonds
#'
#' @description This function draws diamonds on a canvas and (optionally) places two lines behind them. The diamonds can be transparent or have a random color sampled from the input.
#'
#' @usage canvas_diamonds(colors, background = "#fafafa", col.line = "black",
#'                 radius = 10, alpha = 1, p = 0.2, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param col.line    a character specifying the color of the diamond borders.
#' @param radius      a positive value specifying the radius of the diamonds.
#' @param alpha       a value specifying the transparency of the diamonds. If \code{NULL} (the default), added layers become increasingly more transparent.
#' @param p           a value specifying the probability of drawing an empty diamond.
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
#' canvas_diamonds(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_diamonds <- function(colors, background = "#fafafa", col.line = "black",
                            radius = 10, alpha = 1, p = 0.2, resolution = 500) {
  .checkUserInput(background = background, resolution = resolution)
  x <- seq(from = resolution / 5, to = resolution / 5 * 4, by = radius)
  top <- seq(from = resolution / 2 + radius, to = resolution / 5 * 4, by = radius)
  top <- c(top, top[length(top)] + radius)
  top <- c(top, seq(from = top[length(top)] - radius, to = resolution / 2 + radius, by = -radius))
  bottom <- seq(from = resolution / 2 - radius, to = resolution / 5, by = -radius)
  bottom <- c(bottom, bottom[length(bottom)] - radius)
  bottom <- c(bottom, seq(from = bottom[length(bottom)] + radius, to = resolution / 2 - radius, by = radius))
  locs <- data.frame(x = x, bottom = bottom, top = top)
  palette <- NULL
  full_canvas <- data.frame(x = numeric(), y = numeric(), type = numeric())
  for (j in 1:nrow(locs)) {
    rs <- ceiling((top[j] - bottom[j]) / (radius * 2)) # required squares
    for (i in 1:rs) {
      xvec <- c(locs$x[j], locs$x[j] + radius, locs$x[j], locs$x[j] - radius, locs$x[j])
      yvec <- c(locs$top[j] - radius * ((i - 1) * 2), (locs$top[j] - radius * ((i - 1) * 2)) - radius, (locs$top[j] - radius * ((i - 1) * 2)) - (radius * 2), (locs$top[j] - radius * ((i - 1) * 2)) - radius, locs$top[j] - radius * ((i - 1) * 2))
      col <- sample(c(NA, sample(colors, size = 1)), size = 1, prob = c(p, 1 - p))
      if (!(col %in% palette)) {
        palette <- c(palette, col)
      }
      diamond <- data.frame(x = xvec, y = yvec, type = paste0(j, i), col = col)
      full_canvas <- rbind(full_canvas, diamond)
    }
  }
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, group = type)) +
    ggplot2::xlim(c(0, resolution)) +
    ggplot2::ylim(c(0, resolution)) +
    ggplot2::geom_curve(
      data = data.frame(x = 0, y = sample(0:resolution / 2, size = 1), xend = resolution, yend = sample((resolution / 2):resolution, size = 1), type = 999),
      mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      colour = col.line, size = stats::runif(1, 5, 15), curvature = stats::runif(1, 0, 0.5)
    ) +
    ggplot2::geom_curve(
      data = data.frame(x = 0, y = sample((resolution / 2):resolution, size = 1), xend = resolution, yend = sample(0:resolution / 2, size = 1), type = 999),
      mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      colour = col.line, size = stats::runif(1, 5, 15), curvature = stats::runif(1, -0.5, 0)
    ) +
    ggplot2::geom_polygon(fill = full_canvas$col, color = NA, alpha = alpha) +
    ggplot2::scale_fill_manual(values = palette)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
