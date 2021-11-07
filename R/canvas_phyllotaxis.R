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
  x = numeric(iterations)
  y = numeric(iterations)
  for (i in 1:iterations) {
    skip <- sample(c(FALSE, TRUE), size = 1, prob = c(p, 1-p))
    if (skip) {
      next
    }
    theta = (angle%%360)* i
    x[i] = sqrt(i) * cos(theta)
    y[i] = sqrt(i) * sin(theta)
  }
  canvas <- data.frame(x = x, y = y)
  canvas <- canvas[which(canvas$x != 0 & canvas$y != 0), ]
  canvas$id <- 1:nrow(canvas)
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, color = id)) +
    ggplot2::geom_point(size = size, alpha = alpha) +
    ggplot2::scale_color_gradientn(colors = colors)
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}
