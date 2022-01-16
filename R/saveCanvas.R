# Copyright (C) 2021-2022 Koen Derks

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Save a Canvas to an External Device
#'
#' @description This function is a wrapper around \code{ggplot2::ggsave}. It provides a suggested export with square dimensions for a canvas created using the \code{aRtsy} package.
#'
#' @usage saveCanvas(plot, filename, width = 7, height = 7, dpi = 300)
#'
#' @param plot       a ggplot2 object to be saved.
#' @param filename   the filename of the export.
#' @param width      the width of the artwork in cm.
#' @param height     the height of the artwork in cm.
#' @param dpi        the \code{dpi} (dots per inch) of the file.
#'
#' @return No return value, called for saving plots.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @keywords canvas save
#'
#' @export

saveCanvas <- function(plot, filename, width = 7, height = 7, dpi = 300) {
  plot <- plot + ggplot2::theme(plot.margin = ggplot2::unit(rep(-1.25, 4), "lines"))
  ggplot2::ggsave(plot = plot, filename = filename, width = width, height = height, units = "cm", dpi = dpi)
}
