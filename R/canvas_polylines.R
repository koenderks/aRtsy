#' Draw Polygons and Lines
#'
#' @description This function draws many points on the canvas and connects these points into a polygon. After repeating this for all the colors, the edges of all polygons are drawn on top of the artwork.
#'
#' @usage canvas_polylines(colors, background = "#fafafa", ratio = 0.5, iterations = 1000,
#'                  alpha = NULL, size = 0.1, width = 500, height = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the lines.
#' @param ratio       a positive value specifying the width of the polygons. Larger ratios cause more overlap.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param alpha       a value specifying the transparency of the polygons. If \code{NULL} (the default), added layers become increasingly more transparent.
#' @param size        a positive value specifying the size of the borders.
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
#' canvas_polylines(colors = colorPalette("retro1"))
#' }
#'
#' @export

canvas_polylines <- function(colors, background = "#fafafa", ratio = 0.5, iterations = 1000,
                             alpha = NULL, size = 0.1, width = 500, height = 500) {
  .checkUserInput(width = width, height = height, iterations = iterations)
  if (is.null(alpha)) {
    alphas <- seq(from = 1, to = 0.1, length.out = length(colors))
  } else {
    alphas <- rep(alpha, length(colors))
  }
  full_canvas <- data.frame(x = numeric(), y = numeric(), type = character())
  for (i in 1:length(colors)) {
    mat <- draw_polylines(matrix(NA, nrow = iterations, ncol = 2), ratio, iterations, height, width)
    polygon <- data.frame(x = mat[, 1], y = mat[, 2], type = rep(colors[i], iterations))
    full_canvas <- rbind(full_canvas, polygon)
  }
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, fill = type)) +
    ggplot2::xlim(c(0, width)) +
    ggplot2::ylim(c(0, height)) +
    ggplot2::geom_polygon(color = NA, alpha = rep(alphas, each = iterations)) +
    ggplot2::geom_path(color = background, size = size) +
    ggplot2::scale_fill_manual(values = colors)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
