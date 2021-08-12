#' Paint Strokes on a Canvas
#'
#' @description This function creates an artwork that resembles paints strokes. The algorithm is based on the simple idea that each next point on the grid has a chance to take over the color of an adjacent colored point but also has a change of generating a new color.
#'
#' @usage canvas_strokes(colors, neighbors = 1, p = 0.01, iterations = 1, 
#'                width = 500, height = 500, side = FALSE)
#'
#' @param colors     a character (vector) specifying the colors used for the strokes.
#' @param neighbors  the number of neighbors a block considers when taking over a color. More neighbors fades the artwork.
#' @param p          the probability of selecting a new color at each block. A higher probability adds more noise to the artwork.
#' @param iterations the number of iterations on the artwork. More iterations fade the artwork.
#' @param width      the width of the artwork in pixels.
#' @param height     the height of the artwork in pixels.
#' @param side       whether to turn the artwork on its side.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#' canvas_strokes(colors = colorPalette('tuscany3'))
#' }
#' 
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_strokes <- function(colors, neighbors = 1, p = 0.01, iterations = 1, 
                           width = 500, height = 500, side = FALSE) {
  x <- y <- z <- NULL
  if (neighbors < 1)
	stop("Neighbors must be equal to, or larger than, one.")
  if (width != height)
	stop("This artwork can only handle a square canvas.")
  if (length(colors) == 1)
    colors <- c("#fafafa", colors)
  neighborsLocations <- expand.grid(-(neighbors):neighbors,-(neighbors):neighbors)
  colnames(neighborsLocations) <- c("x", "y")
  canvas <- matrix(0, nrow = height, ncol = width)
  for (i in 1:iterations) {
    canvas <- iterate_strokes(X = canvas, neighbors = neighborsLocations, s = length(colors), p = p) 
  }
  full_canvas <- reshape2::melt(canvas)
  colnames(full_canvas) <- c("y", "x", "z")
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = colors) +
    ggplot2::scale_y_continuous(expand = c(0,0)) + 
    ggplot2::scale_x_continuous(expand = c(0,0))
  if (side)
    artwork <- artwork + ggplot2::coord_flip()
  artwork <- themeCanvas(artwork, background = NULL)
  return(artwork)
}
