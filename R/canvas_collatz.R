#' Paint the Collatz Conjecture on Canvas
#'
#' @description This function draws the Collatz conjecture on the canvas.
#'
#' @usage canvas_collatz(colors, background = '#fafafa', n = 200, 
#'                 angle.even = 0.007, angle.odd = 0.013)
#'
#' @param colors     a character (vector) specifying the colors used for the artwork.
#' @param background a character specifying the color used for the background.
#' @param n          the number of numbers to sample for the lines. Can also be a vector of numbers to use.
#' @param angle.even the angle (radials) to use after odd numbers.
#' @param angle.odd  the angle (radials) to use after even numbers.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' set.seed(1)
#' canvas_collatz(colors = colorPalette('dark1'), n = 100)
#' 
#' @keywords artwork canvas
#'
#' @export

canvas_collatz <- function(colors, background = '#fafafa', n = 200, 
                           angle.even = 0.007, angle.odd = 0.014) {
  canvas <- data.frame(x = numeric(), y = numeric(), col = numeric(), type = numeric())
  if (length(n) == 1)
    n <- sample(1:100000000, size = n, replace = F)
  for (i in n) {
    series <- rev(iterate_collatz(i))
    line <- matrix(0, nrow = length(series), ncol = 2)
    line <- draw_line(line, series, angle.even, angle.odd)
    line <- data.frame(x = line[, 1], y = line[, 2], col = rep(sample(colors, size = 1), nrow(line)), type = i, 
                       size = nrow(line), alpha = nrow(line))
    canvas <- rbind(canvas, line)
  }
  canvas$type <- as.factor(canvas$type)
  canvas$size <- 1 - (canvas$size / max(canvas$size))
  canvas$alpha <- 1 - canvas$size
  artwork <- ggplot2::ggplot(data = canvas, mapping = ggplot2::aes(x = x, y = y, group = type)) +
    ggplot2::geom_path(size = canvas$size, color = canvas$col, alpha = canvas$alpha, lineend = "round",) +
    ggplot2::xlim(range(canvas$x)) +
    ggplot2::ylim(range(canvas$y)) +
    ggplot2::coord_flip()
  artwork <- aRtsy::themeCanvas(artwork, background)
  return(artwork)
}
