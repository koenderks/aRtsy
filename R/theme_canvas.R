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

#' Canvas Theme for ggplot2 Objects
#'
#' @description Add a canvas theme to the plot. The canvas theme by default has no margins and fills any empty canvas with a background color.
#'
#' @usage theme_canvas(x, background = NULL, margin = 0)
#'
#' @param x            a ggplot2 object.
#' @param background   a character specifying the color used for the empty canvas.
#' @param margin       margins of the canvas.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords canvas theme
#'
#' @export

theme_canvas <- function(x, background = NULL, margin = 0) {
  x <- x + ggplot2::theme(
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    legend.position = "none",
    plot.background = ggplot2::element_rect(fill = background, colour = background),
    panel.border = ggplot2::element_blank(),
    panel.grid = ggplot2::element_blank(),
    plot.margin = ggplot2::unit(rep(margin, 4), "lines"),
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_blank()
  )
  if (is.null(background)) {
    x <- x + ggplot2::theme(panel.background = ggplot2::element_blank())
  } else {
    x <- x + ggplot2::theme(panel.background = ggplot2::element_rect(fill = background, colour = background))
  }
  return(x)
}
