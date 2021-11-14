#' Draw Cobwebs
#'
#' @description This function draws many Fibonacci spirals shifted by random noise from a normal distribution.
#'
#' @usage canvas_cobweb(colors, background = "#fafafa", lines = 300,
#'               iterations = 100)
#'
#' @param colors      a string or character vector specifying the color(s) used for the artwork.
#' @param background  a character specifying the color used for the background.
#' @param lines       the number of lines to draw.
#' @param iterations  the number of iterations of the algorithm.
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
#' canvas_cobweb(colors = colorPalette("neon1"), background = "black")
#' }
#'
#' @export

canvas_cobweb <- function(colors, background = "#fafafa", lines = 300,
                          iterations = 100) {
  .checkUserInput(background = background, iterations = iterations)
  fibonacci <- .fibonacci(n = iterations)
  seqn <- 1:iterations
  nrows <- length(seqn - 3) * lines
  canvas <- data.frame(x = rep(NA, nrows), xend = rep(NA, nrows), y = rep(NA, nrows), yend = rep(NA, nrows), z = rep(NA, nrows), lwd = rep(NA, nrows), col = rep(NA, nrows))
  for (i in 1:lines) {
    x1 <- ifelse(seqn %% 2 == 1, yes = fibonacci, no = 0)
    y1 <- ifelse(seqn %% 2 == 0, yes = fibonacci, no = 0)
    x2 <- ifelse(seqn %% 4 == 1, yes = x1, no = -x1)
    y2 <- ifelse(seqn %% 4 == 2, yes = y1, no = -y1)
    suppressWarnings({
      x <- ifelse(x2 > 0, log(x2), ifelse(x2 < 0, -log(-x2), 0)) * stats::rnorm(length(x2))
      y <- ifelse(y2 > 0, log(y2), ifelse(y2 < 0, -log(-y2), 0)) * stats::rnorm(length(x2))
    })
    xend <- c(x[-1], x[1])
    yend <- c(y[-1], y[1])
    subdata <- data.frame(x = x, xend = xend, y = y, yend = yend, z = i, lwd = stats::runif(1, 0, 0.1), col = sample(colors, size = 1))
    subdata <- subdata[-which(subdata$x == subdata$xend | subdata$y == subdata$yend), ]
    ind <- which(is.na(canvas$x))[1]
    canvas[ind:(ind + nrow(subdata)-1), ] <- subdata[stats::complete.cases(subdata), ]
  }
  canvas <- canvas[stats::complete.cases(canvas), ]
  artwork <- ggplot2::ggplot() +
    ggplot2::geom_curve(
      data = canvas, mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = z),
      color = canvas$col, curvature = stats::runif(1, 0, 0.8), ncp = 25, size = canvas$lwd, alpha = 0.01
    ) +
    ggplot2::coord_cartesian(xlim = c(min(canvas$x) / 4, max(canvas$x) / 4),
                             ylim = c(min(canvas$y) / 4, max(canvas$y) / 4))
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}

.fibonacci <- function(n) {
  x <- c(0, 1)
  for (i in 3:n) {
    x[i] <- x[i - 1] + x[i - 2]
  }
  x <- x[-1]
  return(x)
}
