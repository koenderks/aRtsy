#' Draw a Circle Map
#'
#' @description This function draws a circle map on the canvas. A circle map models the dynamics of a physical system consisting of two rotors or disks, one free to spin, and anotther attached to a motor, with a long (weak) spring connecting the two.
#'
#' @usage canvas_circlemap(colors, left = 0, right = 12.56, bottom = 0, top = 1,
#'                  iterations = 10, width = 1500, height = 1500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param left        a value specifying the minimum location on the x-axis.
#' @param right       a value specifying the maximum location on the x-axis.
#' @param bottom      a value specifying the minimum location on the y-axis.
#' @param top         a value specifying the maximum location on the y-axis.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/Arnold_tongue}
#' @references \url{https://linas.org/art-gallery/circle-map/circle-map.html}
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords artwork canvas
#'
#' @seealso \code{colorPalette}
#'
#' @examples
#' \donttest{
#' canvas_circlemap(colors = colorPalette("dark2"))
#' }
#'
#' @export

canvas_circlemap <- function(colors, left = 0, right = 12.56, bottom = 0, top = 1,
                             iterations = 10, width = 1500, height = 1500) {
  .checkUserInput(width = width, height = height)
  canvas <- matrix(1, nrow = height, ncol = width)
  canvas <- draw_circlemap(
    X = canvas, left = left, right = right,
    bottom = bottom, top = top, iters = iterations
  )
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
