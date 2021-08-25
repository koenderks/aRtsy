#' Paint Langton's Ant on a Canvas
#'
#' @description This function paints Langton's Ant. Langton's ant is a two-dimensional universal Turing machine with a very simple set of rules but complex emergent behavior.
#'
#' @usage canvas_ant(colors, background = '#fafafa', iterations = 1e7,
#'            width = 200, height = 200)
#'
#' @param colors   	  a character (vector) specifying the colors for the ant.
#' @param background  a character specifying the color of the background.
#' @param iterations  the number of iterations of the ant.
#' @param width       the width of the artwork in pixels.
#' @param height      the height of the artwork in pixels.
#'
#' @references \url{https://en.wikipedia.org/wiki/Langtons_ant}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' canvas_ant(colors = '#000000', background = '#fafafa')
#' }
#' 
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_ant <- function(colors, background = '#fafafa', iterations = 1e7, 
                       width = 200, height = 200) {
  x <- y <- z <- NULL
  if (length(background) > 1)
    stop("Can only take one background value.")
  palette <- c(background, colors)
  sequence <- rep(c(0:1), length(colors))
  pos <- expand.grid(sequence, sequence) # Make matrix that holds combinations of 0 (L) and 1 (R)
  pos[2:nrow(pos), ] <- pos[sample(2:nrow(pos)), ] # Mix the possible positions
  pos <- pos[1:length(colors), ] # Select only as many positions as there are colors
  canvas <- matrix(0, nrow = height, ncol = width)
  full_canvas <- iterate_ant(canvas, iterations, ceiling(height / 2), ceiling(width / 2), pos[, 1], pos[, 2])  
  full_canvas <- reshape2::melt(full_canvas)
  colnames(full_canvas) <- c("y", "x", "z")
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = palette) +
    ggplot2::scale_y_continuous(expand = c(0,0)) + 
    ggplot2::scale_x_continuous(expand = c(0,0))
  artwork <- themeCanvas(artwork, background)
  return(artwork)
}
