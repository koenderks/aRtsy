#' Draw Functions
#'
#' @description This function paints functions with random parameters on a canvas.
#'
#' @usage canvas_function(color, background = "#fafafa", formula = NULL)
#'
#' @param color       a string specifying the color used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param formula     optional, a named list with 'x''and 'y' as structured in the example. If \code{NULL} (default), chooses a function with random parameters.
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
#' set.seed(1)
#'
#' # Simple example
#' canvas_function(color = "navyblue")
#'
#' # Advanced example
#' formula <- list(
#'   x = quote(x_i^2 - sin(y_i^2)),
#'   y = quote(y_i^3 - cos(x_i^2))
#' )
#' canvas_function(color = "firebrick", formula = formula)
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_function <- function(color, background = "#fafafa", formula = NULL) {
  .checkUserInput(background = background)
  if (length(color) > 1) {
    stop("Can only take one color value.")
  }
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
      x = quote(runif(1, -1, 1) * x_i^2 - sin(y_i^2)),
      y = quote(runif(1, -1, 1) * y_i^3 - cos(x_i^2))
    )
    painting_formula <- painting_formulas[[sample(1:length(painting_formulas), 1)]]
  } else {
    if (length(formula) != 2) {
      stop("'formula' should be a list with 'x' and 'y'")
    }
    painting_formula <- formula
  }
  full_canvas <- expand.grid(x_i = seq(from = -pi, to = pi, by = 0.01), y_i = seq(from = -pi, to = pi, by = 0.01)) %>% dplyr::mutate(!!!painting_formula)
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20, color = color) +
    ggplot2::coord_fixed() +
    ggplot2::coord_polar()
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
