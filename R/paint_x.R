#' Paint Strokes on a Canvas
#'
#' @description This function creates a painting that resembles paints strokes. The algorithm is based on the simple idea that each next point on the grid has a chance to take over the color of an adjacent colored point but also has a change of generating a new color.
#'
#' @usage paint_x(colors, background = '#fafafa', ratio = 0.1, iterations = 500, 
#'         alpha = 0.75, size = 0.5, width = 500, height = 500)
#'
#' @param colors     a character (vector) specifying the colors used for the strokes.
#' @param iterations the number of iterations on the painting.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' set.seed(1)
#' paint_x(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'))
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

paint_x <- function(colors, background = '#fafafa', ratio = 0.5, iterations = 1000, 
                    alpha = NULL, width = 500, height = 500){
  painting <- ggplot2::ggplot() +
    ggplot2::xlim(c(0, width)) +
    ggplot2::ylim(c(0, height))
  if(is.null(alpha)) {
    alphas <- seq(from = 1, to = 0.1, length.out = length(colors))
  } else {
    alphas <- rep(alpha, length(colors))
  }
  for(i in 1:length(colors)){
    mat <- iterate_x(matrix(NA, nrow = iterations, ncol = 2), ratio, iterations, width, height)
    painting <- painting + ggplot2::geom_polygon(data = data.frame(x = mat[, 1], y = mat[, 2]), mapping = ggplot2::aes(x = x, y = y), 
                                                 fill = colors[i], color = background, size = 0.5, alpha = alphas[i])
  }
  painting <- painting + ggplot2::theme(axis.title = ggplot2::element_blank(),
                                        axis.text = ggplot2::element_blank(),
                                        axis.ticks = ggplot2::element_blank(),
                                        axis.line = ggplot2::element_blank(),
                                        legend.position = "none",
                                        panel.background = ggplot2::element_rect(fill = background, colour = background),
                                        panel.border = ggplot2::element_blank(),
                                        panel.grid = ggplot2::element_blank(),
                                        plot.margin = ggplot2::unit(c(0,0,0,0), "cm"),
                                        plot.background = ggplot2::element_rect(fill = background, colour = background),
                                        strip.background = ggplot2::element_blank(),
                                        strip.text = ggplot2::element_blank())
  return(painting)
}