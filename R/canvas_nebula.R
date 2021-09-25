#' Draw Nebulas
#'
#' @description This function creates an artwork from randomly generated k-nearest neighbors noise.
#'
#' @usage canvas_nebula(colors, k = 50, n = 500, width = 500, height = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param k           a positive integer specifying the number of nearest neighbors to consider.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#'
#' @return A \code{ggplot} object containing the artwork.
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
#' canvas_nebula(colors = colorPalette("tuscany1"))
#' }
#'
#' @export

canvas_nebula <- function(colors, k = 50, n = 500, width = 500, height = 500) {
  .checkUserInput(width = width, height = height)
  canvas <- .noise(dims = c(width, height), n = n, type = "artsy-knn", k = k)
  canvas <- .unraster(canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster() +
    ggplot2::xlim(c(0, width)) +
    ggplot2::ylim(c(0, height)) +
    ggplot2::scale_fill_gradientn(colors = colors)
  artwork <- aRtsy::theme_canvas(artwork)
  return(artwork)
}
