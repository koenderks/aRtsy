#' Draw Stripes
#'
#' @description This function creates a brownian motion on each row of the artwork and colors it according to the height of the motion.
#'
#' @usage canvas_stripes(colors, n = 300, H = 1, burnin = 1)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param n           a positive integer specifying the length of the brownian motion (effectively the width of the artwork).
#' @param H           a positive value specifying the square of the standard deviation of each step in the motion.
#' @param burnin      a positive integer specifying the number of steps to discard before filling each row.
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
#' canvas_stripes(colors = colorPalette("random", n = 10))
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_stripes <- function(colors, n = 300, H = 1, burnin = 1) {
  x <- y <- z <- NULL
  if (burnin < 1) {
    stop("The burnin parameter must be larger than, or equal to, one.")
  }
  mat <- matrix(NA, nrow = n, ncol = n)
  for (i in 1:nrow(mat)) {
    # Create brownian movement within each row
    t <- 1:(n + burnin)
    x <- stats::rnorm(n = length(t) - 1, sd = sqrt(H))
    x <- c(0, cumsum(x))
    mat[i, ] <- rev(x[-(1:burnin)])
  }
  canvas <- .unraster(mat, names = c("x", "y", "z")) # Convert 2D matrix to data frame
  artwork <- ggplot2::ggplot(data = canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = TRUE) +
    ggplot2::scale_fill_gradientn(colours = colors)
  artwork <- theme_canvas(artwork, background = NULL)
  return(artwork)
}
