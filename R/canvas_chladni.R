#' Draw Chladni Figures
#'
#' @description This function draws Chladni figures on a canvas.
#'
#' @usage canvas_chladni(colors, waves = 5, resolution = 500, 
#'                 warp = 1, angles = NULL, distances = NULL)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param waves       a character specifying the number of randomly sampled waves, or an integer vector of waves to be summed.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#' @param warp        the warp distance.
#' @param angles      the warp angles.
#' @param distances   the warp distances.
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

canvas_chladni <- function(colors, waves = 5, resolution = 500, warp = 1, angles = NULL, distances = NULL) {
  .checkUserInput(resolution = resolution)
  if (length(waves) == 1) {
    waves <- sample(1:50, size = waves, replace = TRUE)
  }
  x <- seq(0, 1, length.out = resolution)
  y <- seq(0, 1, length.out = resolution)
  canvas <- expand.grid(x, y)
  z <- .iterate_chladni(if (warp > 0) .warp(canvas, warp, resolution, angles, distances) else as.matrix(canvas), waves)
  full_canvas <- data.frame(x = canvas[, 1], y = canvas[, 2], z = z)
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE) +
    ggplot2::scale_fill_gradientn(colours = colors)
  artwork <- theme_canvas(artwork)
  return(artwork)
}

.iterate_chladni <- function(p, waves) { # Takes a point (x, y) and returns z
  z <- numeric(nrow(p))
  for (i in 1:length(waves)) {
    z <- abs(z + sin(waves[i] * p[, 1]) * sin(waves[i] * p[, 2]))
  }
  return(z)
}

# This function takes a point (x, y) and returns a warped point (x, y)
.warp <- function(p, warpDist = 1, resolution, angles = NULL, distances = NULL) {
  if (is.null(angles)) {
    angles <- .noise(c(resolution, resolution), type = "svm", limits = c(-pi, pi))
  }
  if (is.null(distances)) {
    distances <- .noise(c(resolution, resolution), type = "knn", n = 500, k = 100, limits = c(0, warpDist))
  }
  return(matrix(c(p[, 1] + c(cos(angles)) * c(distances), p[, 2] + c(sin(angles)) * c(distances)), ncol = 2))
}