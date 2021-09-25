#' Draw the Mandelbrot Set
#'
#' @description This function draws the Mandelbrot set on the canvas.
#'
#' @usage canvas_mandelbrot(colors, iterations = 100, zoom = 1, left = -1.7, right = -0.2,
#'                    bottom = -0.2999, top = 0.8001, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param zoom        a positive value specifying the amount of zoom to apply.
#' @param left        a value specifying the minimum location on the x-axis.
#' @param right       a value specifying the maximum location on the x-axis.
#' @param bottom      a value specifying the minimum location on the y-axis.
#' @param top         a value specifying the maximum location on the y-axis.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/Mandelbrot_set}
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords artwork canvas
#'
#' @seealso \code{colorPalette}
#'
#' @examples
#' \donttest{
#' canvas_mandelbrot(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_mandelbrot <- function(colors, iterations = 100, zoom = 1, left = -1.7, right = -0.2,
                              bottom = -0.2999, top = 0.8001, resolution = 500) {
  .checkUserInput(resolution = resolution, iterations = iterations)
  if (zoom > 1) {
    for (i in 1:(zoom - 1)) {
      xmin_tmp <- left
      xmax_tmp <- right
      ymin_tmp <- bottom
      ymax_tmp <- top
      left <- xmin_tmp + abs(xmin_tmp - xmax_tmp) / 4
      right <- xmax_tmp - abs(xmin_tmp - xmax_tmp) / 4
      bottom <- ymin_tmp + abs(ymin_tmp - ymax_tmp) / 4
      top <- ymax_tmp - abs(ymin_tmp - ymax_tmp) / 4
    }
  }
  x <- seq(left, right, length.out = resolution)
  y <- seq(bottom, top, length.out = resolution)
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
    ggplot2::xlim(c(0, resolution + 1)) +
    ggplot2::ylim(c(0, resolution + 1)) +
    ggplot2::scale_fill_gradientn(colours = colors)
  artwork <- theme_canvas(artwork)
  return(artwork)
}
