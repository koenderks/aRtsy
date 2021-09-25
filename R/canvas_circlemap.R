#' Paint a Circle Map on a Canvas
#'
#' @description This function draws a circle map on the canvas.
#'
#' @usage canvas_circlemap(colors, xmin = 0, xmax = 12.56, ymin = 0, ymax = 1,
#'                  iterations = 10, width = 1500, height = 1500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param xmin        a value specifying the minimum location on the x-axis.
#' @param xmax        a value specifying the maximum location on the x-axis.
#' @param ymin        a value specifying the minimum location on the y-axis.
#' @param ymax        a value specifying the maximum location on the y-axis.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#'
#' @references \url{https://en.wikipedia.org/wiki/Arnold_tongue}
#' @references \url{https://linas.org/art-gallery/circle-map/circle-map.html}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' canvas_circlemap(colors = colorPalette("dark2"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_circlemap <- function(colors, xmin = 0, xmax = 12.56, ymin = 0, ymax = 1,
                             iterations = 10, width = 1500, height = 1500) {
  x <- y <- z <- NULL
  canvas <- matrix(1, nrow = height, ncol = width)
  canvas <- draw_circlemap(canvas, xmin, xmax, ymin, ymax, iterations)
  canvas <- (canvas / iterations) / length(colors)
  full_canvas <- .unraster(canvas, names = c("y", "x", "z")) # Convert 2D matrix to data frame
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = colors) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::scale_x_continuous(expand = c(0, 0))
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
