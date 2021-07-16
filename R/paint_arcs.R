#' Paint Arcs on a Canvas
#'
#' @description This function paints arcs.
#'
#' @usage paint_arcs(colors, background = '#fdf5e6', n = 9, nrow = NULL, ncol = NULL, seed = 1)
#'
#' @param color   	  a character specifying the three colors used for the painting.
#' @param background  a character specifying the color used for the background.
#' @param seed        the seed for the painting.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_strokes}} \code{\link{paint_turmite}} \code{\link{paint_ant}} \code{\link{paint_mondriaan}}
#'
#' @examples
#' paint_arcs(colors = c('black', 'red', 'yellow'))
#' 
#' @keywords paint
#'
#' @export
#' @importFrom ggpubr ggarrange

paint_arcs <- function(colors, background = '#fdf5e6', n = 9, nrow = NULL, ncol = NULL, seed = 1) {
  if(length(colors) != 3)
    stop("You must provide three color names.")
  set.seed(seed)
  transparent <- grDevices::rgb(0, 0, 0, alpha = 0)
  plotList <- list()
  # Nice layer 1: ymin: 0,   ymax: 216
  # Nice layer 2: ymin: 100, ymax: 360
  # Nice layer 3: ymin: 20,  ymax: 270
  for(i in 1:n) {
    # x = size of circle
    # y = position of circle
    p <- ggplot2::ggplot() +
      ggplot2::annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 216, alpha=1, colour = NA, fill = colors[1]) +
      ggplot2::annotate("rect", xmin = 0, xmax = 0.6, ymin = 100, ymax = 360, alpha=0.9, colour = NA, fill = colors[2]) +
      ggplot2::annotate("rect", xmin = 0, xmax = 0.3, ymin = 20, ymax = 270, alpha=1, colour = NA, fill = colors[3]) +
      ggplot2::ylim(c(0, 360)) + 
      ggplot2::coord_polar(theta = "y", start=runif(n = 1, min = 0, max = 360), direction = sample(c(-1, 1), 1)) +
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