#' Canvas Theme for ggplot2 Objects
#'
#' @description Add a canvas theme to the plot. The canvas theme by default has no margins and fills any empty canvas with a background color.
#'
#' @usage theme_canvas(x, background = NULL, margin = 0)
#'
#' @param x            a ggplot2 object.
#' @param background   a character specifying the color used for the empty canvas.
#' @param margin       margins of the canvas.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords canvas theme
#'
#' @export

theme_canvas <- function(x, background = NULL, margin = 0) {
  x <- x + ggplot2::theme(
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    legend.position = "none",
    plot.background = ggplot2::element_rect(fill = background, colour = background),
    panel.border = ggplot2::element_blank(),
    panel.grid = ggplot2::element_blank(),
    plot.margin = ggplot2::unit(rep(margin, 4), "lines"),
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_blank()
  )
  if (is.null(background)) {
    x <- x + ggplot2::theme(panel.background = ggplot2::element_blank())
  } else {
    x <- x + ggplot2::theme(panel.background = ggplot2::element_rect(fill = background, colour = background))
  }
  return(x)
}
