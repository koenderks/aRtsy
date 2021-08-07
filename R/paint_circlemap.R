#' Paint a Circle Map on a Canvas
#'
#' @description This function is my attempt at a circle map.
#'
#' @usage paint_circlemap(colors, x_min = 0, x_max = 12.56, y_min = 0, y_max = 1, 
#'                 iterations = 10, width = 1500, height = 1500)
#'
#' @param colors   	  a character (vector) specifying the colors used for the artwork.
#' @param x_min   	  a numeric value specifying the minimum value for the x-axis.
#' @param x_max   	  a numeric value specifying the maximum value for the x-axis.
#' @param y_min   	  a numeric value specifying the minimum value for the y-axis.
#' @param y_max   	  a numeric value specifying the maximum value for the y-axis.
#' @param iterations  the number of iterations.
#' @param colors   	  a character specifying the color used for the function shape.
#' @param width       the width of the artwork in pixels.
#' @param height      the height of the artwork in pixels.
#'
#' @references \url{https://linas.org/art-gallery/circle-map/circle-map.html}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' paint_circlemap(colors = c('forestgreen', 'firebrick', 'goldenrod', 'navyblue'))
#' 
#' @keywords paint
#'
#' @export
#' @importFrom dplyr %>%

paint_circlemap <- function(colors, x_min = 0, x_max = 12.56, y_min = 0, y_max = 1, 
							              iterations = 10, width = 1500, height = 1500) {
  x <- y <- z <- NULL
  canvas <- matrix(1, nrow = height, ncol = width)
  canvas <- iterate_circlemap(canvas, x_min, x_max, y_min, y_max, iterations)
  canvas <- (canvas / iterations) / length(colors)
  full_canvas <- reshape2::melt(canvas)
  colnames(full_canvas) <- c("y", "x", "z")
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
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
  return(artwork) 
}