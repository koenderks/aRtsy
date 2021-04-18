#' Paint a Planet on a Canvas
#'
#' @description This function paints one or multiple planets.
#'
#' @usage paint_planet <- function(colors, threshold = 3, iterations = 10, starprob = 0.00001,
#'                      radius = NULL, center.x = NULL, center.y = NULL, 
#'                      seed = 1, width = 1500, height = 1500)
#'
#' @param colors   	  a character specifying the colors used for the planets
#' @param threshold   a character specifying the threshold for a color take.
#' @param starprob    the probability of drawing a star in outer space.
#' @param iterations  the number of iterations of the planets
#' @param radius      a numeric (vector) specifying the radius of the planet(s).
#' @param center.x    the x-axis coordinate(s) for the center(s) of the planet(s).
#' @param center.y    the y-axis coordinate(s) for the center(s) of the planet(s).
#' @param seed        the seed for the painting.
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
#' paint_planet(colors = c("dodgerblue", "forestgreen"))
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

paint_planet <- function(colors, threshold = 3, iterations = 10, starprob = 0.00001,
                         radius = NULL, center.x = NULL, center.y = NULL, 
                         seed = 1, width = 1500, height = 1500){
  x <- y <- z <- NULL
  palette <- c('#000000', '#FFFFFF', colors)
  canvas <- matrix(0, nrow = height, ncol = width)
  if(is.null(radius))
    radius <- ceiling(width / 2 / 1.5)
  if(is.null(center.x))
    center.x <- ceiling(width / 2)
  if(is.null(center.y))
    center.y <- ceiling(height / 2)
  if(length(unique(c(length(radius), length(center.y), length(center.x)))) != 1)
     stop("Radius, center.y, and center.x do not have equal length.")
  planets <- length(radius)
  for(i in 1:planets){
    canvas <- iterate_planet(canvas, radius[i], center.x[i], center.y[i], threshold, iterations + i, starprob, seed + i, length(palette)) 
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
