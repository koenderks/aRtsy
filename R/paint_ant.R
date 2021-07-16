#' Paint Langton's Ant on a Canvas
#'
#' @description This function paints Langton's Ant. Langton's ant is a two-dimensional universal Turing machine with a very simple set of rules but complex emergent behavior.
#'
#' @usage paint_ant(colors, background = '#fafafa', iterations = 1e7,
#'           seed = 1, width = 200, height = 200)
#'
#' @param colors   	  a character (vector) specifying the colors for the ant.
#' @param background  a character specifying the color of the background.
#' @param iterations  the number of iterations of the ant.
#' @param seed        the seed for the painting.
#' @param width       the width of the painting in pixels.
#' @param height      the height of the painting in pixels.
#'
#' @references \url{https://en.wikipedia.org/wiki/Langton\%27s_ant}
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_strokes}} \code{\link{paint_function}} \code{\link{paint_turmite}} \code{\link{paint_mondriaan}}
#'
#' @examples
#' paint_ant(colors = '#000000', background = '#fafafa')
#' 
#' @keywords paint
#'
#' @export
#' @useDynLib ggart
#' @import Rcpp

paint_ant <- function(colors, background = '#fafafa', iterations = 1e7, 
                      seed = 1, width = 200, height = 200){
  x <- y <- z <- NULL
  if(length(background) > 1)
    stop("Can only take one background value.")
  set.seed(seed)
  palette <- c(background, colors)
  row <- ceiling(height / 2)
  col <- ceiling(width / 2)
  c <- expand.grid(rep(c(0:1), length(colors)), rep(c(0:1), length(colors)))
  c[2:nrow(c), ] <- c[sample(2:nrow(c)), ]
  c <- c[1:length(colors), ]
  colnames(c) <- c("x", "y")
  df <- iterate_ant(matrix(0, nrow = height, ncol = width), iterations, row, col, c = c, seed = seed)  
  df <- reshape2::melt(df)
  colnames(df) <- c("y", "x", "z")
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
