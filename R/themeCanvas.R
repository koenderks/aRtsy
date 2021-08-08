#' Canvas theme for ggplot2 objects
#'
#' @description Add a canvas theme to the plot. The canvas theme by default has no margins and fills any empty canvas with a background color.
#'
#' @usage themeCanvas(x)
#'
#' @param x   a ggplot2 object.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#' 
#' @keywords canvas theme
#' 
#'
#' @export

themeCanvas <- function(x, background = '#fafafa', margin = -1.25) {
  x <- x + ggplot2::theme(axis.title = ggplot2::element_blank(), 
                          axis.text = ggplot2::element_blank(), 
                          axis.ticks = ggplot2::element_blank(), 
                          axis.line = ggplot2::element_blank(), 
                          legend.position = "none", 
                          panel.background = ggplot2::element_rect(fill = background, colour = background),
                          panel.border = ggplot2::element_blank(), 
                          panel.grid = ggplot2::element_blank(), 
                          plot.background = ggplot2::element_rect(fill = background, colour = background),
                          plot.margin = ggplot2::unit(rep(margin, 4), "lines"), 
                          strip.background = ggplot2::element_blank(), 
                          strip.text = ggplot2::element_blank())
  return(x)
}