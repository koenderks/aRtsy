#' Paint Squares on a Canvas
#'
#' @description This function paints a squares. It works by repeatedly cutting into the canvas at random locations and coloring the area that these cuts create.
#'
#' @usage canvas_squares(colors, background = '#000000', cuts = 50, ratio = 1.618,
#'                width = 100, height = 100)
#'
#' @param colors   	  a character vector specifying the colors used in the squares.
#' @param background  a character specifying the color used for the background (borders).
#' @param cuts        the number of cuts to make.
#' @param ratio       the \code{1:1} ratio for each cut.
#' @param width       the width of the artwork in pixels.
#' @param height      the height of the artwork in pixels.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' set.seed(6)
#' canvas_squares(colors = colorPalette('tuscany1'))
#' 
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_squares <- function(colors, background = '#000000', cuts = 50, ratio = 1.618, 
                           width = 100, height = 100) {
  x <- y <- z <- NULL
  if (length(colors) <= 1)
    stop("You must specify more than one color.")
  if (length(background) > 1)
    stop("Can only take one background value.")
  if (cuts <= 1)
    stop("Cuts must be higher than 1.")
  palette <- c(background, colors)
  neighbors <- expand.grid(-1:1,-1:1)
  colnames(neighbors) <- c("x", "y")
  canvas <- matrix(0, nrow = height, ncol = width)  
  full_canvas <- iterate_squares(canvas, neighbors, length(colors), cuts, ratio)
  full_canvas <- reshape2::melt(full_canvas)
  colnames(full_canvas) <- c("y", "x", "z")
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = FALSE, alpha = 1) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = palette) +
    ggplot2::scale_y_continuous(expand = c(0,0)) + 
    ggplot2::scale_x_continuous(expand = c(0,0))
  artwork <- themeCanvas(artwork, background = NULL)
  return(artwork) 
}
