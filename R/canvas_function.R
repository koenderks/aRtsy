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

#' Draw Functions
#'
#' @description This function paints functions with random parameters on a canvas.
#'
#' @usage canvas_function(colors, background = "#fafafa", by = 0.01,
#'                polar = TRUE, formula = NULL)
#'
#' @param colors      a string specifying the color used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param by          a value specifying the step size between consecutive points.
#' @param polar       logical. Whether to draw the function with polar coordinates.
#' @param formula     optional, a named list with 'x' and 'y' as structured in the example. If \code{NULL} (default), chooses a function with random parameters.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://github.com/cutterkom/generativeart}
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords artwork canvas
#'
#' @seealso \code{colorPalette}
#'
#' @examples
#' \donttest{
#' set.seed(10)
#'
#' # Simple example
#' canvas_function(colors = colorPalette("tuscany1"))
#'
#' # Advanced example
#' formula <- list(
#'   x = quote(x_i^2 - sin(y_i^2)),
#'   y = quote(y_i^3 - cos(x_i^2))
#' )
#' canvas_function(colors = "firebrick", formula = formula)
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_function <- function(colors, background = "#fafafa", by = 0.01,
                            polar = TRUE, formula = NULL) {
  .checkUserInput(background = background)
  if (is.null(formula)) {
    painting_formulas <- list()
    painting_formulas[[1]] <- list(
      x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1)) * runif(1, -100, 100)),
      y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(1:6, 1) + runif(1, -100, 100))
    )
    painting_formulas[[2]] <- list(
      x = quote(runif(1, -1, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1))),
      y = quote(runif(1, -1, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(c(0.5, 1:6), 1))
    )
    painting_formulas[[3]] <- list(
      x = quote(runif(1, -5, 5) * x_i^sample(1:5, 1) - sin(y_i^sample(1:5, 1))),
      y = quote(runif(1, -5, 5) * y_i^sample(1:5, 1) - cos(x_i^sample(1:5, 1)))
    )
    painting_formula <- painting_formulas[[sample(1:length(painting_formulas), 1)]]
  } else {
    if (!is.list(formula) || !("x" %in% names(formula)) || !("y" %in% names(formula))) {
      stop("'formula' must be a named list containing 'x' and 'y'")
    }
    painting_formula <- list(x = formula[["x"]], y = formula[["y"]])
  }
  grid <- expand.grid(x_i = seq(from = -pi, to = pi, by = by), y_i = seq(from = -pi, to = pi, by = by))
  x_i <- grid$x_i
  y_i <- grid$y_i
  full_canvas <- data.frame(x = eval(painting_formula$x), y = eval(painting_formula$y))
  z <- y_i[stats::complete.cases(full_canvas)]
  full_canvas <- full_canvas[stats::complete.cases(full_canvas), ]
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, color = z)) +
    ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20) +
    ggplot2::scale_color_gradientn(colors = colors)
  if (polar) {
    artwork <- artwork + ggplot2::coord_polar()
  }
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
