#' Paint A Triangle with Lines on a Canvas
#'
#' @description This function paints triangles and lines.
#'
#' @usage paint_triangle(colors, background = '#fdf5e6', seed = 1)
#'
#' @param colors      a character (vector) specifying the colors for the lines.
#' @param background  a character specifying the color of the background.
#' @param triangle    logical. Whether to draw the triangle itself.
#' @param seed        the seed for the painting.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_strokes}} \code{\link{paint_turmite}} \code{\link{paint_ant}} \code{\link{paint_mondriaan}}
#'
#' @examples
#' paint_triangle(colors = c("forestgreen", "firebrick", "dodgerblue", "goldenrod"))
#' 
#' @keywords paint
#'
#' @export
#' @importFrom ggpubr ggarrange

paint_triangle <- function(colors, background = '#fdf5e6', triangle = TRUE, seed = 1) {
  p <- ggplot2::ggplot() +
    ggplot2::xlim(c(0, 100)) +
    ggplot2::ylim(0, 100)
  
  y_max_top <- 75 - 7
  trainglePointsLeft <- data.frame(x = 16:49, y = seq(from = 16, to = 75, length.out = 34))
  trainglePointsLeft <- trainglePointsLeft[which(trainglePointsLeft$y < y_max_top), ]
  trainglePointsRight <- data.frame(x = 51:84, y = seq(from = 74, to = 16, length.out = 34))
  trainglePointsRight <- trainglePointsRight[which(trainglePointsRight$y < y_max_top), ]
  set.seed(seed)
  for(i in 1:length(colors)) {
    
    # Take this out for ordered bars
    begin_point_top <- data.frame(x = 0, y = sample(10:90, size = 1))
    end_point_top <- data.frame(x = 100, y = sample(10:90, size = 1))
    first_point_top <- trainglePointsLeft[sample(1:nrow(trainglePointsLeft), size = 1), ]
    second_point_top <- trainglePointsRight[sample(1:nrow(trainglePointsRight), size = 1), ]
    
    begin_point_bottom <- begin_point_top
    first_point_bottom <- first_point_top
    second_point_bottom <- second_point_top
    end_point_bottom <- end_point_top
    
    begin_point_top <- data.frame(x = 0, y = begin_point_bottom$y + 5)
    first_point_top <- data.frame(x = first_point_bottom$x + 2.5, y = first_point_bottom$y + 5)
    second_point_top <- data.frame(x = second_point_bottom$x - 2.5, y = second_point_bottom$y + 5)
    end_point_top <- data.frame(x = 100, y = end_point_bottom$y + 5)
    
    points <- rbind(begin_point_bottom, first_point_bottom, second_point_bottom, end_point_bottom,
                    end_point_top, second_point_top, first_point_top, begin_point_top)
    
    p <- p + ggplot2::geom_polygon(data = points, mapping = ggplot2::aes(x = x, y = y), 
                                   fill = colors[i], color = NA, 
                                   stat = "identity", alpha = 1)
  }
  
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