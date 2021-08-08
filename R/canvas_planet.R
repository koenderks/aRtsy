#' Paint a Planet on a Canvas
#'
#' @description This function paints one or multiple planets.
#'
#' @usage canvas_planet(colors, threshold = 4, iterations = 200, 
#'               starprob = 0.01, fade = 0.2,
#'               radius = NULL, center.x = NULL, center.y = NULL, 
#'               light.right = TRUE, width = 1500, height = 1500)
#'
#' @param colors   	  a character specifying the colors used for the planet(s). Can also be a list where each entry is a vector of colors for each planet.
#' @param threshold   a character specifying the threshold for a color take.
#' @param starprob    the probability of drawing a star in outer space.
#' @param fade        the fading factor.
#' @param iterations  the number of iterations of the planets
#' @param radius      a numeric (vector) specifying the radius of the planet(s).
#' @param center.x    the x-axis coordinate(s) for the center(s) of the planet(s).
#' @param center.y    the y-axis coordinate(s) for the center(s) of the planet(s).
#' @param light.right whether to draw the light from the right or the left.
#' @param width       the width of the artwork in pixels.
#' @param height      the height of the artwork in pixels.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' # Sun behind Earth and Moon
#' set.seed(1)
#' colors <- list(c("khaki1", "lightcoral", "lightsalmon"),
#'                c("dodgerblue", "forestgreen", "white"), 
#'                c("gray", "darkgray", "beige"))
#' canvas_planet(colors, radius = c(800, 400, 150), 
#'               center.x = c(1, 500, 1100),
#'               center.y = c(1400, 500, 1000), 
#'               starprob = 0.005)
#' 
#' @keywords artwork canvas
#'
#' @export

canvas_planet <- function(colors, threshold = 4, iterations = 200, starprob = 0.01, fade = 0.2,
                          radius = NULL, center.x = NULL, center.y = NULL, light.right = TRUE,
                          width = 1500, height = 1500) {
  x <- y <- z <- NULL
  palette <- list()
  for (i in 1:length(colors)) {
    palette[[i]] <- c('#000000', '#787878', '#fafafa', colors[[i]])
  }
  canvas <- matrix(0, nrow = height, ncol = width)
  if (is.null(radius))
    radius <- ceiling(width / 2 / 1.5)
  if (is.null(center.x))
    center.x <- ceiling(width / 2)
  if (is.null(center.y))
    center.y <- ceiling(height / 2)
  if (length(unique(c(length(radius), length(center.y), length(center.x)))) != 1)
    stop("Radius, center.y, and center.x do not have equal length.")
  if (light.right) {
    lightright = 1
  } else {
    lightright = 0
  }
  planets <- length(radius)
  colorsused <- 0
  for (i in 1:planets) {
    canvas <- iterate_planet(X = canvas, 
                             radius = radius[i], 
                             xcenter = center.x[i], 
                             ycenter = center.y[i], 
                             threshold = threshold, 
                             iterations = ceiling(iterations / i), 
                             starprob = starprob, 
                             ncolors = length(palette[[i]]), 
                             colorsused = colorsused, 
                             fade = fade,
                             lightright = lightright)
    colorsused <- colorsused + length(colors[[i]]) 
  }
  full_canvas <- reshape2::melt(canvas)
  colnames(full_canvas) <- c("y", "x", "z")
  full_palette <- c('#000000', '#787878', '#fafafa', unlist(colors))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = full_palette) +
    ggplot2::scale_y_continuous(expand = c(0,0)) + 
    ggplot2::scale_x_continuous(expand = c(0,0))
  artwork <- themeCanvas(artwork, background = NULL)
  return(artwork)
}
