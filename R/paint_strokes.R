#' Paint Strokes on a Canvas
#'
#' @description This function creates a painting that resembles paints strokes. The algorithm is based on the simple idea that each next point on the grid has a chance to take over the color of an adjacent colored point but also has a change of generating a new color.
#'
#' @usage paint_strokes(colors = '#000000', neighbors = 1, p = 0.01, seed = 1, 
#'                      iterations = 1, width = 500, height = 500, side = FALSE)
#'
#' @param colors     a vector of colors for the painting.
#' @param neighbors  the number of neighbors a block considers when taking over a color. More neighbors fades the painting.
#' @param p          the probability of selecting a new color at each block. A higher probability adds more noise to the painting.
#' @param seed       the seed for the painting.
#' @param iterations the number of iterations on the painting. More iterations fade the painting.
#' @param width      the width of the painting in pixels.
#' @param height     the height of the painting in pixels.
#' @param side       whether to turn the painting on its side.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_turmite}} \code{\link{paint_function}} \code{\link{paint_ant}}
#'
#' @examples
#' paint_strokes(colors = c('#fafafa', '#000000'), neighbors = 1, p = 0.01,
#'               seed = 1, side = FALSE, iterations = 1, 
#'               width = 1500, height = 1500)
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

paint_strokes <- function(colors = '#000000', neighbors = 1, p = 0.01, seed = 1, 
                          iterations = 1, width = 500, height = 500, side = FALSE){
  if(length(colors) == 1)
    colors <- c("#fafafa", colors)
  set.seed(seed)
  df <- matrix(0, nrow = height, ncol = width)
  neighborsLocations <- expand.grid(-(neighbors):neighbors,-(neighbors):neighbors)
  colnames(neighborsLocations) <- c("x", "y")
  df <- matrix(0, nrow = height, ncol = width)
  for (i in 1:iterations){
    df <- iterate_strokes(X = df, neighbors = neighborsLocations, s = length(colors), p = p) 
  }
  df <- reshape2::melt(df)
  x <- y <- z <- NULL
  df <- data.frame(y = df[, 1], x = df[, 2], z = df[, 3])
  painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = colors) +
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
  if(side)
    painting <- painting + ggplot2::coord_flip()
  return(painting)
}
