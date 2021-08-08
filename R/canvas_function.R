#' Paint Functions on a Canvas
#'
#' @description This function paints functions with random parameters and mimics the functionality of the \code{generativeart} package.
#'
#' @usage canvas_function(color, background = '#fafafa')
#'
#' @param color   	  a character specifying the color used for the function shape.
#' @param background  a character specifying the color used for the background.
#'
#' @references \url{https://github.com/cutterkom/generativeart}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' set.seed(10)
#' canvas_function(color = '#000000', background = '#fafafa')
#' 
#' @keywords artwork canvas
#'
#' @export
#' @importFrom dplyr %>%

canvas_function <- function(color, background = '#fafafa') {
  x <- y <- z <- NULL
  if (length(color) > 1)
    stop("Can only take one color value.")
  if (length(background) > 1)
    stop("Can only take one background value.")
  painting_formulas <- list()
  painting_formulas[[1]] <- list( 
    x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1)) * runif(1, -100, 100)),
    y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(1:6, 1) + runif(1, -100, 100))
  )
  painting_formulas[[2]] <- list(
    x = quote(runif(1, -1, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1))),
    y = quote(runif(1, -1, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(c(0.5, 1:6), 1))
  )
  painting_formulas[[3]] <- list(x = quote(runif(1, -1, 1) * x_i^2 -sin(y_i^2)),
                                 y = quote(runif(1, -1, 1) * y_i^3-cos(x_i^2)))
  painting_formula <- painting_formulas[[sample(1:length(painting_formulas), 1)]]
  full_canvas <- expand.grid(x_i = seq(from = -pi, to = pi, by = 0.01), y_i = seq(from = -pi, to = pi, by = 0.01)) %>% dplyr::mutate(!!!painting_formula)
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y)) + 
    ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20, color = color) + 
    ggplot2::coord_fixed() + 
    ggplot2::coord_polar()
  artwork <- themeCanvas(artwork, background)
  return(artwork) 
}
