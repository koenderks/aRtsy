#' Paint the Mandelbrot Set on a Canvas
#'
#' @description This function draws the Mandelbrot set on the canvas.
#'
#' @usage canvas_mandelbrot(colors, iterations = 100, zoom = 1, xmin = -1.7, xmax = -0.2,
#'                    ymin = -0.2999, ymax = 0.8001, width = 500, height = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param zoom        a positive value specifying the amount of zoom to apply.
#' @param xmin        a value specifying the minimum location on the x-axis.
#' @param xmax        a value specifying the maximum location on the x-axis.
#' @param ymin        a value specifying the minimum location on the y-axis.
#' @param ymax        a value specifying the maximum location on the y-axis.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#'
#' @references \url{https://en.wikipedia.org/wiki/Mandelbrot_set}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' canvas_mandelbrot(colors = colorPalette("tuscany1"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_mandelbrot <- function(colors, iterations = 100, zoom = 1, xmin = -1.7, xmax = -0.2,
                              ymin = -0.2999, ymax = 0.8001, width = 500, height = 500) {
  x <- y <- z <- NULL
  if (zoom > 1) {
    for (i in 1:(zoom - 1)) {
      xmin_tmp <- xmin
      xmax_tmp <- xmax
      ymin_tmp <- ymin
      ymax_tmp <- ymax
      xmin <- xmin_tmp + abs(xmin_tmp - xmax_tmp) / 4
      xmax <- xmax_tmp - abs(xmin_tmp - xmax_tmp) / 4
      ymin <- ymin_tmp + abs(ymin_tmp - ymax_tmp) / 4
      ymax <- ymax_tmp - abs(ymin_tmp - ymax_tmp) / 4
    }
  }
  x <- seq(xmin, xmax, length.out = width)
  y <- seq(ymin, ymax, length.out = height)
  c <- outer(x, y * 1i, FUN = "+")
  z <- matrix(0, nrow = length(x), ncol = length(y))
  canvas <- matrix(0, nrow = length(x), ncol = length(y))
  for (rep in 1:iterations) {
    index <- which(Mod(z) < 2)
    z[index] <- z[index]^2 + c[index]
    canvas[index] <- canvas[index] + 1
  }
  full_canvas <- .unraster(canvas, names = c("x", "y", "z")) # Convert 2D matrix to data frame
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = colors) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::scale_x_continuous(expand = c(0, 0))
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
