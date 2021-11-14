#' Draw a Phyllotaxis
#'
#' @description This function draws a phyllotaxis which resembles the arrangement of leaves on a plant stem.
#'
#' @usage canvas_phyllotaxis(colors, background = '#fafafa', iterations = 10000, 
#'                angle = 137.5, size = 0.01, alpha = 1, p = 0.5)
#'
#' @param colors         a string or character vector specifying the color(s) used for the artwork.
#' @param background     a character specifying the color used for the background.
#' @param iterations     the number of iterations of the algorithm.
#' @param angle          the angle at which to place the artwork.
#' @param size           the size of the lines.
#' @param alpha          transparency of the points.
#' @param p              probability of drawing a point on each iteration.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/Phyllotaxis}
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords artwork canvas
#'
#' @seealso \code{colorPalette}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#'
#' # Simple example
#' canvas_phyllotaxis(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_phyllotaxis <- function(colors, background = '#fafafa', iterations = 10000, 
                               angle = 137.5, size = 0.01, alpha = 1, p = 0.5) { 
  .checkUserInput(background = background, iterations = iterations)
  canvas <- iterate_phyllotaxis(iterations, angle, p)
  canvas$z <- 1:nrow(canvas)
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, color = z)) +
    ggplot2::geom_point(size = size, alpha = alpha) +
    ggplot2::scale_color_gradientn(colors = colors)
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}
