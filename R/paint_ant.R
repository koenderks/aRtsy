#' Paint Langton's Ant
#'
#' @description This function paints Langton's Ant. Langton's ant is a two-dimensional universal Turing machine with a very simple set of rules but complex emergent behavior.
#'
#' @usage paint_ant(color = '#000000', background = '#fafafa', seed = 1, 
#'           width = 200, height = 200)
#'
#' @param color   	  the color of the turmite.
#' @param background  the color of the background.
#' @param seed        the seed for the painting.
#' @param width       the width of the painting.
#' @param height      the height of the painting.
#'
#' @references \url{https://en.wikipedia.org/wiki/Langton\%27s_ant}
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_strokes}} \code{\link{paint_shape}} \code{\link{paint_turmite}}
#'
#' @examples
#' paint_ant(color = '#000000', background = '#fafafa', seed = 1,
#'           width = 200, height = 200)
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

paint_ant <- function(color = '#000000', background = '#fafafa', seed = 1, 
                      iterations = 1e7, width = 1500, height = 1500){
  set.seed(seed)
  palette <- c(background, color)
  row <- ceiling(height / 2)
  col <- ceiling(width / 2)
  df <- iterate_ant(matrix(0, nrow = height, ncol = width), iterations, row, col)  
  df <- reshape2::melt(df)
  colnames(df) <- c("y","x","z")
  painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y, fill = z)) +
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
