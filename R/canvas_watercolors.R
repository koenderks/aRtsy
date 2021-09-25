#' Draw Watercolors
#'
#' @description This function paints watercolors on a canvas.
#'
#' @usage canvas_watercolors(colors, background = "#fafafa", layers = 50,
#'                    depth = 2, resolution = 250)
#'
#' @param colors       a string specifying the color used for the artwork.
#' @param background   a character specifying the color used for the background.
#' @param layers       the number of layers of each color.
#' @param depth        the maximum depth of the recusive algorithm.
#' @param resolution   resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://tylerxhobbs.com/essays/2017/a-generative-approach-to-simulating-watercolor-paints}
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
#' canvas_watercolors(colors = colorPalette("tuscany2"))
#' }
#'
#' @export

canvas_watercolors <- function(colors, background = "#fafafa", layers = 50,
                               depth = 2, resolution = 250) {
  .checkUserInput(resolution = resolution, background = background)
  nlayers <- length(colors)
  plotData <- data.frame(x = numeric(), y = numeric(), s = numeric(), z = numeric())
  colorSequence <- rep(colors, times = ceiling(layers / 5), each = 5)
  labelSequence <- rep(1:length(colors), times = ceiling(layers / 5), each = 5)
  corners <- sample(3:10, size = nlayers, replace = TRUE)
  basePolygons <- list()
  for (i in 1:nlayers) {
    basePolygons[[i]] <- .createBasePolygon(i, nlayers, corners[i], resolution)
  }
  for (i in 1:length(colorSequence)) {
    canvas <- basePolygons[[labelSequence[i]]]
    canvas <- deform(canvas, maxdepth = depth, resolution)
    canvas <- cbind(canvas, z = i)
    plotData <- rbind(plotData, canvas)
  }
  artwork <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y, fill = factor(z))) +
    ggplot2::geom_polygon(alpha = 0.04) +
    ggplot2::scale_fill_manual(values = colorSequence) +
    ggplot2::xlim(c(0, resolution)) +
    ggplot2::ylim(0, resolution)
  artwork <- theme_canvas(artwork, background)
  return(artwork)
}

.createBasePolygon <- function(color, nlayers, corners, resolution) {
  if (nlayers == 1) {
    xmid <- (resolution / 2)
    ymid <- (resolution / 2)
  } else {
    xmid <- (resolution / 2) + (resolution / 3) * cos(2 * pi * color / nlayers) * stats::rnorm(1, mean = 0.75, sd = 0.25)
    ymid <- (resolution / 2) + (resolution / 3) * sin(2 * pi * color / nlayers) * stats::rnorm(1, mean = 0.75, sd = 0.25)
  }
  radiusx <- sample((resolution / 3):(resolution / 7.5), size = 1)
  radiusy <- sample((resolution / 3):(resolution / 7.5), size = 1)
  polyx <- xmid + radiusx * cos(2 * pi * 1:corners / corners)
  polyy <- ymid + radiusy * sin(2 * pi * 1:corners / corners)
  coords <- data.frame(x = polyx, y = polyy)
  coords[nrow(coords) + 1, ] <- coords[1, ]
  varsegments <- stats::rnorm(nrow(coords), mean = 6, sd = 1.5)
  canvas <- data.frame(x = coords$x, y = coords$y, s = varsegments)
  canvas <- deform(canvas, maxdepth = 5, resolution)
  return(canvas)
}
