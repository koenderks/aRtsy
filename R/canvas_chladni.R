#' Draw Chladni Figures
#'
#' @description This function draws Chladni figures on a canvas.
#'
#' @usage canvas_chladni(colors, waves = 5, resolution = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param waves       a character specifying the number of randomly sampled waves, or an integer vector of waves to be summed.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
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
#' canvas_chladni(colors = colorPalette("lava"))
#'
#' # Advanced example
#' canvas_chladni(colors = colorPalette("lava"), waves = c(1, 2, 3, 9))
#' }
#'
#' @export

canvas_chladni <- function(colors, waves = 5, resolution = 500) {
  .checkUserInput(resolution = resolution)
  if (length(waves) == 1) {
    waves <- sample(1:50, size = waves, replace = TRUE)
  }
  canvas <- matrix(0, nrow = resolution, ncol = resolution)
  f <- pi / (2 * resolution)
  canvas <- iterate_chladni(canvas, waves, f)
  full_canvas <- .unraster(x = canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE) +
    ggplot2::scale_fill_gradientn(colours = colors)
  artwork <- theme_canvas(artwork)
  return(artwork)
}
