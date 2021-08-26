#' Paint Langton's Ant on a Canvas
#'
#' @description This function paints Langton's Ant. Langton's ant is a two-dimensional universal Turing machine with a very simple set of rules but complex emergent behavior.
#'
#' @usage canvas_ant(colors, background = '#fafafa', iterations = 1e7,
#'            width = 200, height = 200)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#'
#' @references \url{https://en.wikipedia.org/wiki/Langtons_ant}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#' palette <- colorPalette('random', n = 10)
#' canvas_ant(colors = palette)
#' }
#' 
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_ant <- function(colors, background = '#fafafa', iterations = 1e7, 
                       width = 200, height = 200) {
  if (length(background) > 1)
    stop("Can only take one background value.")
  x <- y <- z <- NULL # Global variables
  palette <- c(background, colors)
  sequence <- rep(c(0:1), length(colors)) # Create a sequence of 0 (L) and 1 (R) positions
  pos <- expand.grid(sequence, sequence) # Create a matrix that holds all possible combinations of 0 (L) and 1 (R)
  pos[2:nrow(pos), ] <- pos[sample(2:nrow(pos)), ] # Mix the possible positions randomly
  pos <- pos[1:length(colors), ] # Select only as many positions as there are colors given by the user
  canvas <- matrix(0, nrow = height, ncol = width) # Empty canvas
  full_canvas <- draw_ant(canvas, iterations, ceiling(height / 2), ceiling(width / 2), pos[, 1], pos[, 2])  
  full_canvas <- reshape2::melt(full_canvas) # Convert 2D matrix to data frame
  colnames(full_canvas) <- c("y", "x", "z")
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = palette)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
