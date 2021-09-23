#' Paint Random Squares on a Canvas
#'
#' @description This function paints random squares. It works by repeatedly cutting into the canvas at random locations and coloring the area that these cuts create.
#'
#' @usage canvas_squares(colors, background = '#000000', cuts = 50, ratio = 1.618,
#'                width = 200, height = 200, noise = FALSE)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the borders of the squares.
#' @param cuts        a positive integer specifying the number of cuts to make.
#' @param ratio       a value specifying the \code{1:1} ratio for each cut.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#' @param noise       logical. Whether to add k-nn noise to the artwork. Caution, adding noise increases computation time significantly in large dimensions.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(14)
#' palette <- colorPalette("random", n = 4)
#' canvas_squares(colors = palette)
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_squares <- function(colors, background = "#000000", cuts = 50, ratio = 1.618,
                           width = 200, height = 200, noise = FALSE) {
  x <- y <- z <- NULL
  if (length(colors) <= 1) {
    stop("You must specify more than one color.")
  }
  if (length(background) > 1) {
    stop("Can only take one background value.")
  }
  if (cuts <= 1) {
    stop("Cuts must be higher than 1.")
  }
  palette <- c(background, colors)
  neighbors <- expand.grid(-1:1, -1:1)
  colnames(neighbors) <- c("x", "y")
  canvas <- matrix(0, nrow = height, ncol = width)
  full_canvas <- draw_squares(canvas, neighbors, length(colors), cuts, ratio)
  if (noise) {
    full_canvas <- full_canvas - noise(dims = c(height, width))
  }
  full_canvas <- unraster(full_canvas, names = c("x", "y", "z")) # Convert 2D matrix to data frame
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = FALSE, alpha = 1) +
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = palette) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::scale_x_continuous(expand = c(0, 0))
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
