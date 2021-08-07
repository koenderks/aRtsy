#' Paint Arcs on a Canvas
#'
#' @description Inspired by the work of \href{https://twitter.com/ijeamaka_a}{@ijeamaka_a}, this type of artwork mimics her beautiful \href{https://www.etsy.com/listing/1032142006/arcs-series-geometric-art-generative-art?ref=shop_home_recs_1&crt=1}{Arc Series}. For private use only.
#'
#' @usage paint_arcs(colors, background = '#fdf5e6', n = 1, nrow = NULL, ncol = NULL, 
#'            dir = 'right', starts = 'clockwise')
#'
#' @param colors   	  a character vector specifying the 3 colors used for the arcs.
#' @param background  a character string specifying the color used for the background.
#' @param n           an integer specifying how many arcs should be put on the canvas.
#' @param nrow        an (optional) integer specifying the number of rows on the canvas.
#' @param ncol        an (optional) integer specifying the number of columns on the canvas.
#' @param dir         a character string specifying which direction the arcs turn. Can be one of \code{"right"} (default) or \code{"left"}.
#' @param starts      a character sting specifying where the arcs should start. Can be one of \code{"clockwise"} (default) or \code{"random"}.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' aRtsy:::paint_arcs(colors = c('darkgreen', 'goldenrod', 'firebrick'), n = 9)
#' 
#' @keywords paint
#'
#' @importFrom ggpubr ggarrange

paint_arcs <- function(colors, background = '#fdf5e6', n = 1, nrow = NULL, ncol = NULL, 
                       dir = 'right', starts = 'clockwise') {
  if(length(colors) != 3)
    stop("You must provide three color names.")
  if (n <= 0)
    stop("You must specify n > 0.")
  if (!(dir %in% c("left", "right")))
    stop("dir must be 'left' or 'right'")
  if (!(starts %in% c("clockwise", "random")))
    stop("starts must be 'clockwise' or 'random'")
  transparent <- grDevices::rgb(0, 0, 0, alpha = 0)
  starts <- if (starts == 'clockwise') seq(from = 0, to = 360, length.out = n) else sample(0:360, size = n, replace = FALSE)
  # Nice layer 1: ymin: 0,   ymax: 216
  # Nice layer 2: ymin: 100, ymax: 360
  # Nice layer 3: ymin: 20,  ymax: 270
  plotList <- list()
  for(i in 1:n) {
    # xmax = size of arc
    # ymin, ymax = position(s) of arc
    p <- ggplot2::ggplot() +
      ggplot2::annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 216, alpha = 1, colour = NA, fill = colors[1]) +
      ggplot2::annotate("rect", xmin = 0, xmax = 0.6, ymin = 100, ymax = 360, alpha = 0.9, colour = NA, fill = colors[2]) +
      ggplot2::annotate("rect", xmin = 0, xmax = 0.3, ymin = 20, ymax = 270, alpha = 1, colour = NA, fill = colors[3]) +
      ggplot2::ylim(c(0, 360)) + 
      ggplot2::coord_polar(theta = "y", start = starts[i], direction = if (dir == "right") 1 else -1) +
      ggplot2::theme(axis.title = ggplot2::element_blank(), 
                     axis.text = ggplot2::element_blank(), 
                     axis.ticks = ggplot2::element_blank(), 
                     axis.line = ggplot2::element_blank(), 
                     legend.position = "none", 
                     panel.background = ggplot2::element_rect(fill = background, colour = background), 
                     panel.border = ggplot2::element_blank(), 
                     panel.grid = ggplot2::element_blank(), 
                     plot.margin = ggplot2::unit(c(0,0,0,0), "cm"),
                     plot.background = ggplot2::element_rect(fill = background, colour = background), 
                     strip.background = ggplot2::element_blank(), 
                     strip.text = ggplot2::element_blank())
    plotList[[i]] <- p
  }
  p <- do.call("ggarrange", c(plotList, nrow = nrow, ncol = ncol))
  p <- p + ggplot2::theme(panel.background = ggplot2::element_rect(fill = background, colour = background))
  if(is.null(p))
    stop("Not all figures can be placed on the canvas. Increase the canvas dimensions.")
  return(p)
}