#' Paint the Mandelbrot Set on Canvas
#'
#' @description This function draws the Mandelbrot set on the canvas.
#'
#' @usage canvas_mandelbrot(colors, n = 100, xmin = -1.7, xmax = -0.2, ymin = -0.2999, 
#'                    ymax = 0.8001, zoom = 1, width = 500, height = 500)
#'
#' @param colors    a character (vector) specifying the colors used for the artwork.
#' @param n         the number of iterations.
#' @param xmin      the minimum x value.
#' @param xmax      the maximum x value.
#' @param ymin      the minimum y value.
#' @param ymax      the maximum y value.
#' @param zoom      the amount of zoom to apply.
#' @param width     the width of the artwork in pixels.
#' @param height    the height of the artwork in pixels.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#' canvas_mandelbrot(colors = colorPalette('dark1'), n = 100)
#' }
#' 
#' @keywords artwork canvas
#'
#' @export

canvas_mandelbrot <- function(colors, n = 100, xmin = -1.7, xmax = -0.2, ymin = -0.2999, 
                              ymax = 0.8001, zoom = 1, width = 500, height = 500) {
  x <- y <- z <- NULL
  if (zoom > 1) {
    for(i in 1:(zoom - 1)) {
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
  c <- outer(x, y * 1i, FUN = '+')
  z <- matrix(0, nrow = length(x), ncol = length(y))
  canvas <- matrix(0, nrow = length(x), ncol = length(y))
  for (rep in 1:n) { 
    index <- which(Mod(z) < 2)
    z[index] <- z[index]^2 + c[index]
    canvas[index] <- canvas[index] + 1
  }
  full_canvas <- reshape2::melt(canvas)
  colnames(full_canvas) <- c("x", "y", "z")
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = colors) +
    ggplot2::scale_y_continuous(expand = c(0,0)) + 
    ggplot2::scale_x_continuous(expand = c(0,0))
  artwork <- themeCanvas(artwork, background = NULL)
  return(artwork)
}