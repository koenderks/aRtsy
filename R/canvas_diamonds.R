#' Paint Random Diamonds on a Canvas
#'
#' @description This function draws many diamonds on the canvas and places two lines behind them. The diamonds can be transparent or have a random color sampled from the input.
#'
#' @usage canvas_diamonds(colors, background = '#fafafa', col.line = 'black',
#'                 radius = 10, alpha = 1, p = 0.2,
#'                 width = 500, height = 500)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param col.line    a character specifying the color of the diamond borders.
#' @param radius      a positive value specifying the radius of the diamonds.
#' @param alpha       a value specifying the transparency of the diamonds. If \code{NULL} (the default), added layers become increasingly more transparent.
#' @param p           a value specifying the probability of drawing an empty diamond.
#' @param width       a positive integer specifying the width of the artwork in pixels.
#' @param height      a positive integer specifying the height of the artwork in pixels.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(5)
#' palette <- colorPalette("random", n = 5)
#' canvas_diamonds(colors = palette, radius = 10)
#' }
#'
#' @keywords artwork canvas
#'
#' @export

canvas_diamonds <- function(colors, background = "#fafafa", col.line = "black",
                            radius = 10, alpha = 1, p = 0.2,
                            width = 500, height = 500) {
  x <- y <- xend <- yend <- type <- col <- NULL
  x <- seq(from = width / 5, to = width / 5 * 4, by = radius)
  ymax <- seq(from = height / 2 + radius, to = height / 5 * 4, by = radius)
  ymax <- c(ymax, ymax[length(ymax)] + radius)
  ymax <- c(ymax, seq(from = ymax[length(ymax)] - radius, to = height / 2 + radius, by = -radius))
  ymin <- seq(from = height / 2 - radius, to = height / 5, by = -radius)
  ymin <- c(ymin, ymin[length(ymin)] - radius)
  ymin <- c(ymin, seq(from = ymin[length(ymin)] + radius, to = height / 2 - radius, by = radius))
  locs <- data.frame(x = x, ymin = ymin, ymax = ymax)
  palette <- NULL
  full_canvas <- data.frame(x = numeric(), y = numeric(), type = numeric())
  for (j in 1:nrow(locs)) {
    rs <- ceiling((ymax[j] - ymin[j]) / (radius * 2)) # required squares
    for (i in 1:rs) {
      xvec <- c(locs$x[j], locs$x[j] + radius, locs$x[j], locs$x[j] - radius, locs$x[j])
      yvec <- c(locs$ymax[j] - radius * ((i - 1) * 2), (locs$ymax[j] - radius * ((i - 1) * 2)) - radius, (locs$ymax[j] - radius * ((i - 1) * 2)) - (radius * 2), (locs$ymax[j] - radius * ((i - 1) * 2)) - radius, locs$ymax[j] - radius * ((i - 1) * 2))
      col <- sample(c(NA, sample(colors, size = 1)), size = 1, prob = c(p, 1 - p))
      if (!(col %in% palette)) {
        palette <- c(palette, col)
      }
      diamond <- data.frame(x = xvec, y = yvec, type = paste0(j, i), col = col)
      full_canvas <- rbind(full_canvas, diamond)
    }
  }
  artwork <- ggplot2::ggplot(data = full_canvas, mapping = ggplot2::aes(x = x, y = y, group = type)) +
    ggplot2::xlim(c(0, width)) +
    ggplot2::ylim(c(0, height)) +
    ggplot2::geom_curve(
      data = data.frame(x = 0, y = sample(0:height / 2, size = 1), xend = width, yend = sample((height / 2):height, size = 1), type = 999),
      mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      colour = col.line, size = stats::runif(1, 5, 15), curvature = stats::runif(1, 0, 0.5)
    ) +
    ggplot2::geom_curve(
      data = data.frame(x = 0, y = sample((height / 2):height, size = 1), xend = width, yend = sample(0:height / 2, size = 1), type = 999),
      mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      colour = col.line, size = stats::runif(1, 5, 15), curvature = stats::runif(1, -0.5, 0)
    ) +
    ggplot2::geom_polygon(fill = full_canvas$col, color = NA, alpha = alpha) +
    ggplot2::scale_fill_manual(values = palette)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}
