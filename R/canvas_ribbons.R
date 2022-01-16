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

#' Draw Ribbons
#'
#' @description This function paints random ribbons and (optionally) a triangle in the middle.
#'
#' @usage canvas_ribbons(colors, background = "#fdf5e6", triangle = TRUE)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork. The number of colors determines the number of ribbons.
#' @param background  a character specifying the color of the background.
#' @param triangle    logical. Whether to draw the triangle that breaks the ribbon polygons.
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
#' canvas_ribbons(colors = colorPalette("retro1"))
#' }
#'
#' @export

canvas_ribbons <- function(colors, background = "#fdf5e6", triangle = TRUE) {
  .checkUserInput(background = background)
  # Create an empty figure
  artwork <- ggplot2::ggplot() +
    ggplot2::xlim(c(0, 100)) +
    ggplot2::ylim(0, 100)
  # Determine points on the triangle
  y_max_top <- 75 - 7
  tpl <- data.frame(x = 16:49, y = seq(from = 16, to = 75, length.out = 34))
  tpl <- tpl[which(tpl$y < y_max_top), ]
  tpr <- data.frame(x = 51:84, y = seq(from = 74, to = 16, length.out = 34))
  tpr <- tpr[which(tpr$y < y_max_top), ]
  for (i in 1:length(colors)) {
    # Determine points on left side of triangle
    bpb <- data.frame(x = 0, y = sample(10:90, size = 1))
    fpb <- tpl[sample(1:nrow(tpl), size = 1), ]
    spb <- tpr[sample(1:nrow(tpr), size = 1), ]
    epb <- data.frame(x = 100, y = sample(10:90, size = 1))
    # Determine points on right side of triangle
    bpt <- data.frame(x = 0, y = bpb$y + 5)
    fpt <- data.frame(x = fpb$x + 2.5, y = fpb$y + 5)
    spt <- data.frame(x = spb$x - 2.5, y = spb$y + 5)
    ept <- data.frame(x = 100, y = epb$y + 5)
    # Combine polygon points
    polygon <- rbind(bpb, fpb, spb, epb, ept, spt, fpt, bpt)
    artwork <- artwork + ggplot2::geom_polygon(
      data = polygon, mapping = ggplot2::aes(x = x, y = y),
      fill = colors[i], color = NA,
      stat = "identity", alpha = 1
    )
  }
  # (Optionally) draw the triangle
  if (triangle) {
    artwork <- artwork + ggplot2::geom_polygon(
      data = data.frame(x = c(15, 50, 85), y = c(15, 75, 15)), mapping = ggplot2::aes(x = x, y = y),
      fill = NA, color = "black",
      stat = "identity", size = 1
    )
  }
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
