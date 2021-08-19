#' Save a canvas to an external device.
#'
#' @description This function is a wrapper around \code{ggplot2::ggsave}. It provides a suggested export with square dimensions for a canvas created using the \code{aRtsy} package.
#'
#' @usage saveCanvas(plot, filename, width = 7, height = 7, resolution = 300)
#'
#' @param plot       a ggplot2 object to be saved.
#' @param filename   the filename of the export.
#' @param width      the width of the artwork in cm.
#' @param height     the height of the artwork in cm.
#' @param resolution the \code{dpi} of the export.
#'
#' @return No return value, called for saving plots.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#' 
#' @keywords canvas save
#' 
#' @export

saveCanvas <- function(plot, filename, width = 7, height = 7, resolution = 300) {
  ggplot2::ggsave(plot = plot, filename = filename, width = width, height = height, units = 'cm', dpi = resolution)
}