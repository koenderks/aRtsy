#' Paint a Mondriaan on a Canvas
#'
#' @description This function paints a Mondriaan.
#'
#' @usage paint_mondriaan(colors, background = '#000000', cuts = 50, ratio = 1.618,
#'                 width = 100, height = 100)
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
#' paint_mondriaan(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'))
#' 
#' @keywords paint
#'
#' @export

paint_mondriaan <- function(colors, background = '#000000', cuts = 50, ratio = 1.618, 
                            width = 100, height = 100){
  x <- y <- z <- NULL
  if(length(colors) <= 1)
	stop("You must specify more than one color.")
  if(length(background) > 1)
    stop("Can only take one background value.")
  if(cuts <= 1)
    stop("Cuts must be higher than 1.")
  palette <- c(background, colors)
  neighbors <- expand.grid(-1:1,-1:1)
  colnames(neighbors) <- c("x", "y")
  canvas <- matrix(0, nrow = height, ncol = width)  
  full_canvas <- iterate_mondriaan(canvas, neighbors, length(colors), cuts, ratio)
  full_canvas <- reshape2::melt(full_canvas)
  colnames(full_canvas) <- c("y", "x", "z")
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = FALSE, alpha = 1) + 
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
  return(artwork) 
}
