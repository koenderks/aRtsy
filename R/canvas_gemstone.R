#' Draw Gemstones
#'
#' @description This function draws the predictions from a k-nearest neighbors algorithm trained on randomly generated continuous data.
#'
#' @usage canvas_gemstone(colors, n = 1000, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param n           a positive integer specifying the number of random data points to generate.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm}
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
#' canvas_gemstone(colors = colorPalette("dark3"))
#' }
#'
#' @export

canvas_gemstone <- function(colors, n = 1000, resolution = 500) {
  .checkUserInput(resolution = resolution)
  canvas <- .noise(dims = c(resolution, resolution), n = n, type = "knn")
  canvas <- .unraster(canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_tile() +
    ggplot2::xlim(c(0, resolution)) +
    ggplot2::ylim(c(0, resolution)) +
    ggplot2::scale_fill_gradientn(colours = colors)
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
