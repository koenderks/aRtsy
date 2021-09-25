#' Paint a Random Turmite on a Canvas
#'
#' @description This function paints a turmite. A turmite is a Turing machine which has an orientation in addition to a current state and a "tape" that consists of a two-dimensional grid of cells. The algorithm is simple: 1) turn on the spot (left, right, up, down) 2) change the color of the square 3) move forward one square.
#'
#' @usage canvas_turmite(colors, background = '#fafafa', p = 0.5, iterations = 1e7,
#'                width = 1500, height = 1500, noise = FALSE)
#'
#' @param colors       a character specifying the color used for the artwork. The number of colors determines the number of turmites.
#' @param background  a character specifying the color used for the background.
#' @param p           a value specifying the probability of a state switch within the turmite.
#' @param iterations  a positive integer specifying the number of iterations of the algorithm.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#' @param noise       logical. Whether to add k-nn noise to the artwork. Caution, adding noise increases computation time significantly in large dimensions.
#'
#' @references \url{https://en.wikipedia.org/wiki/Turmite}
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
#' canvas_turmite(colors = colorPalette("dark2"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_turmite <- function(colors, background = "#fafafa", p = 0.5, iterations = 1e7,
                           width = 1500, height = 1500, noise = FALSE) {
  x <- y <- z <- NULL
  if (length(background) > 1) {
    stop("This artwork can only take one background value.")
  }
  palette <- c(background, colors)
  canvas <- matrix(0, nrow = height, ncol = width)
  for (i in 1:length(colors)) {
    k <- sample(0:1, size = 1)
    row <- 0
    col <- 0
    if (k == 1) {
      col <- sample(0:(width - 1), size = 1)
    }
    if (k == 0) {
      row <- sample(0:(height - 1), size = 1)
    }
    turmite <- draw_turmite(matrix(0, nrow = height, ncol = width), iterations, row, col, p = p)
    if (noise) {
      turmite[which(turmite == 0)] <- NA
      turmite <- turmite - .noise(dims = c(height, width))
      turmite[which(is.na(turmite))] <- 0
    }
    canvas <- canvas + turmite
  }
  full_canvas <- .unraster(canvas, names = c("x", "y", "z")) # Convert 2D matrix to data frame
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE, alpha = 0.9) +
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = palette) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::scale_x_continuous(expand = c(0, 0))
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
