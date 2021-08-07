#' Paint Polygons and Lines on Canvas
#'
#' @description This function draws many points on the canvas and connects these points into a polygon. After repeating this for all the colors, the edges of all polygons are drawn on top of the artwork.
#'
#' @usage canvas_polylines(colors, background = '#fafafa', ratio = 0.5, iterations = 1000, 
#'                  alpha = NULL, size = 0.1, width = 500, height = 500)
#'
#' @param colors      a character (vector) specifying the colors used for the strokes.
#' @param background  a character specifying the color used for the borders.
#' @param ratio       width of the polygons. Larger ratios cause more overlap.
#' @param iterations  the number of points for each polygon.
#' @param alpha       transparency of the polygons. If \code{NULL}, added layers become increasingly more transparent.
#' @param size        size of the borders.
#' @param width       the width of the artwork in pixels.
#' @param height      the height of the artwork in pixels.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' set.seed(1)
#' canvas_polylines(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'))
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_polylines <- function(colors, background = '#fafafa', ratio = 0.5, iterations = 1000, 
                     alpha = NULL, size = 0.1, width = 500, height = 500){
  x <- y <- type <- NULL
  if(is.null(alpha)) {
    alphas <- seq(from = 1, to = 0.1, length.out = length(colors))
  } else {
    alphas <- rep(alpha, length(colors))
  }
  d <- data.frame(x = numeric(), y = numeric(), type = character())
  for(i in 1:length(colors)){
    mat <- iterate_polylines(matrix(NA, nrow = iterations, ncol = 2), ratio, iterations, height, width)
    d_tmp <- data.frame(x = mat[, 1], y = mat[, 2], type = rep(colors[i], iterations))
    d <- rbind(d, d_tmp)
  }
  artwork <- ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = x, y = y, fill = type)) +
    ggplot2::xlim(c(0, width)) +
    ggplot2::ylim(c(0, height)) + 
    ggplot2::geom_polygon(color = NA, alpha = rep(alphas, each = iterations)) +
    ggplot2::geom_path(color = background, size = size) +
    ggplot2::scale_fill_manual(values = colors) +
    ggplot2::theme(axis.title = ggplot2::element_blank(),
                                        axis.text = ggplot2::element_blank(),
                                        axis.ticks = ggplot2::element_blank(),
                                        axis.line = ggplot2::element_blank(),
                                        legend.position = "none",
                                        panel.background = ggplot2::element_rect(fill = background, colour = background),
                                        panel.border = ggplot2::element_blank(),
                                        panel.grid = ggplot2::element_blank(),
                                        plot.margin = ggplot2::unit(rep(-1.25,4),"lines"),
                                        plot.background = ggplot2::element_rect(fill = background, colour = background),
                                        strip.background = ggplot2::element_blank(),
                                        strip.text = ggplot2::element_blank())
  return(artwork)
}