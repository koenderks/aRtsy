#' Save a canvas to an external device.
#'
#' @description This function is a wrapper around \code{ggplot2::ggsave}. It provides a suggested export with square dimensions for a canvas created using the \code{aRtsy} package.
#'
#' @usage saveCanvas(plot, filename)
#'
#' @param x   a ggplot2 object.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#' 
#' @keywords canvas save
#' 
#'
#' @export

saveCanvas <- function(plot, filename, resolution = 300) {
  ggplot2::ggsave(plot = plot, filename = filename, width = 7, height = 7, units = 'cm', dpi = resolution)
}