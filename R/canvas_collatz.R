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

#' Draw Collatz Sequences
#'
#' @description This function draws the Collatz conjecture on the canvas.
#'
#' @usage canvas_collatz(colors, background = "#fafafa", n = 200,
#'                 angle.even = 0.0075, angle.odd = 0.0145, side = FALSE)
#'
#' @param colors     a string or character vector specifying the color(s) used for the artwork.
#' @param background a character specifying the color used for the background.
#' @param n          a positive integer specifying the number of random starting integers to use for the lines. Can also be a vector of numbers to use as starting numbers.
#' @param angle.even a value specifying the angle (in radials) to use in bending the sequence at each odd number.
#' @param angle.odd  a value specifying the angle (in radials) to use in bending the sequence at each even number.
#' @param side       logical. Whether to put the artwork on its side.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://nl.wikipedia.org/wiki/Collatz_Conjecture}
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
#' canvas_collatz(colors = colorPalette("tuscany3"))
#' }
#'
#' @export

canvas_collatz <- function(colors, background = "#fafafa", n = 200,
                           angle.even = 0.0075, angle.odd = 0.0145, side = FALSE) {
  .checkUserInput(background = background)
  canvas <- data.frame(x = numeric(), y = numeric(), col = numeric(), z = numeric())
  if (length(n) == 1) {
    n <- sample(1:1000000, size = n, replace = F)
  }
  for (i in n) {
    series <- rev(get_collatz_sequence(i))
    line <- matrix(0, nrow = length(series), ncol = 2)
    line <- draw_collatz(line, series, angle.even, angle.odd)
    line <- data.frame(
      x = line[, 1],
      y = line[, 2],
      col = rep(sample(colors, size = 1), nrow(line)),
      z = i,
      size = nrow(line),
      alpha = nrow(line)
    )
    canvas <- rbind(canvas, line)
  }
  canvas$z <- as.factor(canvas$z)
  canvas$size <- 1 - (canvas$size / max(canvas$size))
  canvas$alpha <- 1 - canvas$size
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, group = z)) +
    ggplot2::geom_path(size = canvas$size, color = canvas$col, alpha = canvas$alpha, lineend = "round") +
    ggplot2::xlim(range(canvas$x)) +
    ggplot2::ylim(range(canvas$y))
  if (side) {
    artwork <- artwork + ggplot2::coord_flip()
  }
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
