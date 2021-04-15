#' Paint shapes
#'
#' @description This function paints shapes.
#'
#'
#' @usage paint_shape(color = '#000000', background = '#fafafa', seed = 1)
#'
#' @param color   	  the color of the shape.
#' @param background  the color of the background.
#' @param seed        the seed for the painting.
#'
#' @references https://github.com/cutterkom/generativeart
#'
#' @return A \code{ggplot} object with the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_strokes}} \code{\link{paint_turmite}}
#'
#' @examples
#' bg <- sample(c('#fafafa', '#cc7722', '#a9d2c3', '#fc7c7c'), size = 1)
#' 
#' paint_shape(color = '#000000', background = bg)
#' 
#' @keywords paint
#'
#' @export
#' @importFrom dplyr %>%

paint_shape <- function(color = '#000000', background = '#fafafa', seed = 1){
  set.seed(seed)
  painting_formulas <- list()
  painting_formulas[[1]] <- list( 
    x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1)) * runif(1, -100, 100)),
    y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(1:6, 1) + runif(1, -100, 100))
  )
  painting_formulas[[2]] <- list(
    x = quote(runif(1, -1, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1))),
    y = quote(runif(1, -1, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(c(0.5, 1:6), 1))
  )
  painting_formula <- painting_formulas[[sample(1:length(painting_formulas), 1)]]
  df <- seq(from = -pi, to = pi, by = 0.01) %>% expand.grid(x_i = ., y_i = .) %>% dplyr::mutate(!!!painting_formula)
  painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y)) + 
    ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20, color = color) + 
    ggplot2::theme_void() + 
    ggplot2::coord_fixed() + 
    ggplot2::coord_polar() + 
    ggplot2::theme(axis.title = ggplot2::element_blank(), 
                   axis.text = ggplot2::element_blank(), 
                   axis.ticks = ggplot2::element_blank(), 
                   axis.line = ggplot2::element_blank(), 
                   legend.position = "none", 
                   panel.background = ggplot2::element_rect(fill = background, colour = background), 
                   panel.border = ggplot2::element_blank(), 
                   panel.grid = ggplot2::element_blank(), 
                   plot.background = ggplot2::element_rect(fill = background, colour = background), 
                   plot.margin = ggplot2::unit(rep(-1.25,4),"lines"), 
                   strip.background = ggplot2::element_blank(), 
                   strip.text = ggplot2::element_blank())
  return(painting) 
}
