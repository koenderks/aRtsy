#' Paint a Nebula on a Canvas
#'
#' @description This function creates an artwork from randomly generated noise. Currently it is only capable of generating k-nearest neighbors noise. Sometimes, the noise resembles a nebula.
#'
#' @usage canvas_nebula(colors, k = 50, n = 500, resolution = 2000)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param k           a positive integer specifying the number of nearest neighbors to consider.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param resolution  a positive integer specifying the number of pixels (resolution x resolution) of the artwork.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(1)
#'
#' # Simple example
#' canvas_nebula(colors = colorPalette("tuscany1"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_nebula <- function(colors, k = 50, n = 500, resolution = 2000) {
  x <- y <- z <- NULL
  dims <- c(resolution, resolution)
  canvas <- noise(dims = dims, k, n)
  canvas <- unraster(canvas, c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster() +
    ggplot2::scale_fill_gradientn(colors = colors)
  artwork <- aRtsy::theme_canvas(artwork)
  return(artwork)
}
