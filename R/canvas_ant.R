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
#' @references \url{https://en.wikipedia.org/wiki/Langton\%27s_ant}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' canvas_ant(colors = '#000000', background = '#fafafa')
#' 
#' @keywords artwork canvas
#'
#' @export

canvas_ant <- function(colors, background = '#fafafa', iterations = 1e7, 
                       width = 200, height = 200){
  x <- y <- z <- NULL
  if(length(background) > 1)
    stop("Can only take one background value.")
  palette <- c(background, colors)
  row <- ceiling(height / 2)
  col <- ceiling(width / 2)
  canvas <- expand.grid(rep(c(0:1), length(colors)), rep(c(0:1), length(colors)))
  canvas[2:nrow(canvas), ] <- canvas[sample(2:nrow(canvas)), ]
  canvas <- canvas[1:length(colors), ]
  colnames(canvas) <- c("x", "y")
  full_canvas <- iterate_ant(matrix(0, nrow = height, ncol = width), iterations, row, col, c = canvas)  
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
