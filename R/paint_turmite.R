#' Paint a Turmite on a Canvas
#'
#' @description This function paints a turmite. A turmite is a Turing machine which has an orientation in addition to a current state and a "tape" that consists of a two-dimensional grid of cells. The algorithm is simple: 1) turn on the spot (left, right, up, down) 2) change the color of the square 3) move forward one square.
#'
#' @usage paint_turmite(color, background = '#fafafa', p = 0.5, iterations = 1e7, 
#'               width = 1500, height = 1500)
#'
#' @param color   	  a character specifying the color used for the turmite.
#' @param background  a character specifying the color used for the background.
#' @param p           the probability of a state switch within the turmite.
#' @param iterations  the number of iterations of the turmite.
#' @param width       the width of the artwork in pixels.
#' @param height      the height of the artwork in pixels.
#'
#' @references \url{https://en.wikipedia.org/wiki/Turmite}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' set.seed(1)
#' paint_turmite(color = "#000000", background = "#fafafa")
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

paint_turmite <- function(color, background = '#fafafa', p = 0.5, iterations = 1e7, 
                          width = 1500, height = 1500){
  x <- y <- z <- NULL
  if(length(color) > 1)
    stop("Can only take one color value.")
  if(length(background) > 1)
    stop("Can only take one background value.")
  palette <- c(background, color)
  k <- sample(0:1, size = 1)
  row <- 0
  col <- 0
  if(k == 1)
    col <- sample(0:(width-1), size = 1)
  if(k == 0)
    row <- sample(0:(height-1), size = 1) 
  df <- iterate_turmite(matrix(0, nrow = height, ncol = width), iterations, row, col, p = p)  
  df <- reshape2::melt(df)
  colnames(df) <- c("y", "x", "z")
  artwork <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y, fill = z)) +
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
  return(artwork)
}
