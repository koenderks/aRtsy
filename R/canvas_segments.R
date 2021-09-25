#' Draw Segments
#'
#' @description This function draws many random line segments on the canvas.
#'
#' @usage canvas_segments(colors, background = '#fafafa', n = 250,
#'                 p = 0.5, H = 0.1, size = 0.2)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param n           a positive integer specifying the number of line segments to draw.
#' @param p           a value specifying the probability of drawing a vertical line segment.
#' @param H           a positive value specifying the scaling factor for the line segments.
#' @param size        a positive value specifying the size of the line segments.
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
#' canvas_segments(colors = colorPalette("dark1"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_segments <- function(colors, background = "#fafafa", n = 250,
                            p = 0.5, H = 0.1, size = 0.2) {
  x <- y <- xend <- yend <- col <- NULL
  H <- 0.1
  full_canvas <- data.frame(
    x = numeric(),
    xend = numeric(),
    y = numeric(),
    yend = numeric()
  )
  for (i in 1:n) {
    x <- 0.8 * stats::runif(1, 0, 1) + 0.1
    y <- 0.8 * stats::runif(1, 0, 1) + 0.1
    k <- H * (1 - sqrt(stats::runif(1, 0, 1)))
    if (stats::runif(1, 0, 1) > p) {
      row <- data.frame(x = x - k, xend = x + k, y = y, yend = y, col = sample(colors, size = 1))
    } else {
      row <- data.frame(x = x, xend = x, y = y - k, yend = y + k, col = sample(colors, size = 1))
    }
    full_canvas <- rbind(full_canvas, row)
  }
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend)) +
    ggplot2::xlim(c(0, 1)) +
    ggplot2::ylim(c(0, 1)) +
    ggplot2::geom_segment(color = full_canvas$col, size = size)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
