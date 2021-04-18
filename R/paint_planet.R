#' Paint a Turmite on a Canvas
#'
#' @description This function paints a turmite. A turmite is a Turing machine which has an orientation in addition to a current state and a "tape" that consists of a two-dimensional grid of cells. The algorithm is simple: 1) turn on the spot (left, right, up, down) 2) change the color of the square 3) move forward one square.
#'
#' @usage paint_planet(color, background = '#fafafa', p = 0.5, iterations = 1e7, 
#'                      seed = 1, width = 1500, height = 1500)
#'
#' @param color   	  a character specifying the color used for the turmite.
#' @param background  a character specifying the color used for the background.
#' @param p           the probability of a state switch within the turmite.
#' @param seed        the seed for the painting.
#' @param iterations  the number of iterations of the turmite.
#' @param width       the width of the painting in pixels.
#' @param height      the height of the painting in pixels.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_strokes}} \code{\link{paint_function}} \code{\link{paint_ant}} \code{\link{paint_mondriaan}}
#'
#' @examples
#' paint_turmite(color = "#000000", background = "#fafafa")
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

paint_planet <- function(colors, radius = NULL, center.x = NULL, center.y = NULL, threshold = 3, iterations = 10, seed = 1, width = 500, height = 500){
  x <- y <- z <- NULL
  palette <- c('#000000', colors)
  canvas <- matrix(0, nrow = height, ncol = width)
  if(is.null(radius))
    radius <- ceiling(width / 2 / 1.5)
  if(is.null(center.x))
    center.x <- ceiling(width / 2)
  if(is.null(center.y))
    center.y <- ceiling(height / 2)
  planets <- length(radius)
  for(i in 1:planets){
    canvas <- iterate_planet(canvas, radius[i], center.x[i], center.y[i], threshold, iterations, seed + i, length(palette)) 
  }
  full_canvas <- reshape2::melt(canvas)
  colnames(full_canvas) <- c("y", "x", "z")
  painting <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = palette) +
    ggplot2::scale_y_continuous(expand = c(0,0)) + 
    ggplot2::scale_x_continuous(expand = c(0,0)) +
    ggplot2::theme(axis.title = ggplot2::element_blank(), 
                   axis.text = ggplot2::element_blank(), 
                   axis.ticks = ggplot2::element_blank(), 
                   axis.line = ggplot2::element_blank(), 
                   legend.position = "none", 
                   panel.border = ggplot2::element_blank(), 
                   panel.grid = ggplot2::element_blank(), 
                   plot.margin = ggplot2::unit(rep(-1.25,4),"lines"), 
                   strip.background = ggplot2::element_blank(), 
                   strip.text = ggplot2::element_blank())
  return(painting)
}
