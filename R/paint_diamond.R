#' Paint A Diamond on Canvas
#'
#' @description This function draws many points on the canvas and connects these points into a polygon. After repeating this for all the colors, the edges of all polygons are drawn on top of the painting.
#'
#' @usage paint_polylines(colors, background = '#fafafa', ratio = 0.5, iterations = 1000, 
#'                 alpha = NULL, size = 0.1, width = 500, height = 500)
#'
#' @param colors      a character (vector) specifying the colors used for the strokes.
#' @param background  a character specifying the color used for the borders.
#' @param ratio       width of the polygons. Larger ratios cause more overlap.
#' @param iterations  the number of points for each polygon.
#' @param alpha       transparency of the polygons. If \code{NULL}, added layers become increasingly more transparent.
#' @param size        size of the borders.
#' @param width       the width of the painting in pixels.
#' @param height      the height of the painting in pixels.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' set.seed(1)
#' paint_polylines(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'))
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

paint_diamond <- function(colors, background = '#fafafa', radius = 5, p = 0.5, width = 500, height = 500) {

  # painting <- ggplot2::ggplot() +
  #   ggplot2::xlim(c(0, width)) +
  #   ggplot2::ylim(c(0, height))
  
  x <- seq(from = width / 5, to = width / 5 * 4, by = radius)
  
  ymax <- seq(from = height / 2 + radius, to = height / 5 * 4, by = radius)
  ymax <- c(ymax, ymax[length(ymax)] + radius)
  ymax <- c(ymax, seq(from = ymax[length(ymax)] - radius, to = height / 2 + radius, by = -radius))
  
  ymin <- seq(from = height / 2 - radius, to = height / 5, by = -radius)
  ymin <- c(ymin, ymin[length(ymin)] - radius)
  ymin <- c(ymin, seq(from = ymin[length(ymin)] + radius, to = height / 2 - radius, by = radius))
  
  locs <- data.frame(x = x, ymin = ymin, ymax = ymax)
  
  for (j in 1:nrow(locs)){
    rs <- ceiling((ymax[j] - ymin[j]) / (radius * 2)) # required squares
    for (i in 1:rs) {
      xvec <- c(locs$x[j], locs$x[j] + radius, locs$x[j], locs$x[j] - radius, locs$x[j])
      yvec <- c(locs$ymax[j] - radius*((i-1)*2), (locs$ymax[j] - radius*((i-1)*2)) - radius, (locs$ymax[j] - radius*((i-1)*2)) - (radius*2), (locs$ymax[j] - radius*((i-1)*2)) - radius, locs$ymax[j] - radius*((i-1)*2))
      d <- data.frame(x = xvec, y = yvec, z = sample(c(background, sample(colors, size = 1)), size = 1, prob = c(p, 1 - p)))
      painting <- painting + 
        ggplot2::geom_polygon(data = d, mapping = ggplot2::aes(x = x, y = y, fill = z), color = NA, alpha = 1) +
        ggplot2::geom_path(data = d, mapping = ggplot2::aes(x = x, y = y), color = background, size = 1)
    }
  }
  painting <- painting +
    ggplot2::scale_fill_manual(values = c(background, colors)) +
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
  return(painting)
}