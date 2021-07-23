#' Paint Ribbons on a Canvas
#'
#' @description This function paints ribbons and (optionally) a triangle in the middle.
#'
#' @usage paint_ribbons(colors, background = '#fdf5e6', triangle = TRUE)
#'
#' @param colors      a character (vector) specifying the colors for the ribbons.
#' @param background  a character specifying the color of the background.
#' @param triangle    logical. Whether to draw the triangle that breaks the ribbon polygons.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' paint_ribbons(colors = c("forestgreen", "firebrick", "dodgerblue", "goldenrod"))
#' 
#' @keywords paint
#'
#' @export
#' @importFrom ggpubr ggarrange

paint_ribbons <- function(colors, background = '#fdf5e6', triangle = TRUE) {
  # Create an empty figure
  p <- ggplot2::ggplot() +
    ggplot2::xlim(c(0, 100)) +
    ggplot2::ylim(0, 100)
  # Determine points on the triangle
  y_max_top <- 75 - 7
  tpl <- data.frame(x = 16:49, y = seq(from = 16, to = 75, length.out = 34))
  tpl <- tpl[which(tpl$y < y_max_top), ]
  tpr <- data.frame(x = 51:84, y = seq(from = 74, to = 16, length.out = 34))
  tpr <- tpr[which(tpr$y < y_max_top), ]
  for(i in 1:length(colors)) {
    # Determine points on left side of triangle
    bpb <- data.frame(x = 0, y = sample(10:90, size = 1))
    fpb <- tpl[sample(1:nrow(tpl), size = 1), ]
    spb <- tpr[sample(1:nrow(tpr), size = 1), ]
    epb <- data.frame(x = 100, y = sample(10:90, size = 1))
    # Determine points on right side of triangle
    bpt <- data.frame(x = 0, y = bpb$y + 5)
    fpt <- data.frame(x = fpb$x + 2.5, y = fpb$y + 5)
    spt <- data.frame(x = spb$x - 2.5, y = spb$y + 5)
    ept <- data.frame(x = 100, y = epb$y + 5)
    # Combine polygon points
    points <- rbind(bpb, fpb, spb, epb, ept, spt, fpt, bpt)
    p <- p + ggplot2::geom_polygon(data = points, mapping = ggplot2::aes(x = x, y = y), 
                                   fill = colors[i], color = NA, 
                                   stat = "identity", alpha = 1)
  }
  # (Optionally) draw the triangle 
  if (triangle) {
    d <- data.frame(x = c(15, 50, 85), y = c(15, 75, 15))
    p <- p + ggplot2::geom_polygon(data = d, mapping = ggplot2::aes(x = x, y = y), 
                                   fill = NA, color = "black", 
                                   stat = "identity", size = 1)
  }
  p <- p + ggplot2::theme(axis.title = ggplot2::element_blank(),
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
  return(p)
}