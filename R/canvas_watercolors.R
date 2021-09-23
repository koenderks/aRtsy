#' Paint Watercolors on a Canvas
#'
#' @description This function paints watercolors on a canvas.
#'
#' @usage canvas_watercolors(colors, background = "#ebd5b3", layers = 20,
#'                    depth = 2, width = 250, height = 250)
#'
#' @param colors       a string specifying the color used for the artwork.
#' @param background   a character specifying the color used for the background.
#' @param layers       the number of layers of each color.
#' @param depth        the maximum depth of the recusive algorithm.
#' @param width        a positive integer specifying the width of the artwork in pixels.
#' @param height       a positive integer specifying the height of the artwork in pixels.
#'
#' @references \url{https://tylerxhobbs.com/essays/2017/a-generative-approach-to-simulating-watercolor-paints}
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(10)
#' canvas_watercolors(color = colorPalette("tuscany1"))
#' }
#'
#' @keywords artwork canvas
#'
#' @export
#' @useDynLib aRtsy
#' @import Rcpp

canvas_watercolors <- function(colors, background = "#ebd5b3", layers = 20,
                               depth = 2, width = 250, height = 250) {
  x <- y <- z <- NULL
  nlayers <- length(colors)
  plotData <- data.frame(x = numeric(), y = numeric(), s = numeric(), z = numeric())
  colorSequence <- rep(colors, times = ceiling(layers / 5), each = 5)
  labelSequence <- rep(1:length(colors), times = ceiling(layers / 5), each = 5)
  corners <- sample(3:10, size = nlayers, replace = TRUE)
  basePolygons <- list()
  for (i in 1:nlayers) {
    basePolygons[[i]] <- .createBasePolygon(i, nlayers, corners[i], width, height)
  }
  for (i in 1:length(colorSequence)) {
    canvas <- basePolygons[[labelSequence[i]]]
    canvas <- deform(canvas, maxdepth = depth, width, height, hole = FALSE)
    canvas <- cbind(canvas, z = i)
    plotData <- rbind(plotData, canvas)
  }
  artwork <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y, fill = factor(z))) +
    ggplot2::geom_polygon(alpha = 0.04) +
    ggplot2::scale_fill_manual(values = colorSequence) +
    ggplot2::xlim(c(0, width)) +
    ggplot2::ylim(0, height)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}

.createBasePolygon <- function(color, nlayers, corners, width, height) {
  if (nlayers == 1) {
    xmid <- (width / 2)
    ymid <- (height / 2)
  } else {
    xmid <- (width / 2) + (width / 3) * cos(2 * pi * color / nlayers) * rnorm(1, mean = 0.5, sd = 0.25)
    ymid <- (height / 2) + (height / 3) * sin(2 * pi * color / nlayers) * rnorm(1, mean = 0.5, sd = 0.25)
  }
  radiusx <- sample((width / 3):(width / 5), size = 1)
  radiusy <- sample((height / 3):(height / 5), size = 1)
  polyx <- xmid + radiusx * cos(2 * pi * 1:corners / corners)
  polyy <- ymid + radiusy * sin(2 * pi * 1:corners / corners)
  coords <- data.frame(x = polyx, y = polyy)
  coords[nrow(coords) + 1, ] <- coords[1, ]
  varsegments <- stats::rnorm(nrow(coords), mean = 5)
  canvas <- data.frame(x = coords$x, y = coords$y, s = varsegments)
  # First time through deformation algorithm
  canvas <- deform(canvas, maxdepth = 5, width, height, hole = 0)
  return(canvas)
}
