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

#' Draw Mazes
#'
#' @description This function draws a maze on a canvas.
#'
#' @usage canvas_maze(color = "#fafafa", walls = "black", background = "#fafafa",
#'             resolution = 20, polar = FALSE)
#'
#' @param color       a character specifying the color used for the artwork.
#' @param walls       a character specifying the color used for the walls of the maze.
#' @param background  a character specifying the color used for the background.
#' @param resolution  resolution of the artwork in pixels per row/column. Increasing the resolution increases the quality of the artwork but also increases the computation time exponentially.
#' @param polar       logical, whether to use polar coordinates. Warning, this increases display and saving time dramatically.
#'
#' @return A \code{ggplot} object containing the artwork.
#'
#' @references \url{https://github.com/matfmc/mazegenerator}
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
#' canvas_maze(color = "#fafafa")
#' }
#'
#' @export

canvas_maze <- function(color = "#fafafa", walls = "black", background = "#fafafa",
                        resolution = 20, polar = FALSE) {
  canvas <- matrix(0, resolution, resolution)
  x <- sample(2:resolution, size = 1)
  y <- sample(2:resolution, size = 1)
  maze <- iterate_maze(canvas, x, y)
  full_canvas <- .connectMaze(maze, canvas)
  full_canvas <- .unraster(full_canvas, names = c("x", "y", "z"))
  artwork <- ggplot2::ggplot(data = full_canvas, ggplot2::aes(x = x, y = y, fill = factor(z), color = factor(z))) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_manual(values = c(color, walls)) +
    ggplot2::scale_color_manual(values = c(color, walls)) +
    ggplot2::ylim(c(0, max(full_canvas$y) + 1))
  if (!polar) {
    artwork <- artwork + ggplot2::xlim(c(0, max(full_canvas$x) + 1))
  } else {
    artwork <- artwork + ggplot2::coord_polar(start = stats::runif(1, 0, 2 * pi), clip = "off") +
      ggplot2::xlim(c(0.5, max(full_canvas$x) + 0.5))
  }
  artwork <- theme_canvas(artwork, background = background)
  return(artwork)
}

.connectMaze <- function(maze, canvas) {
  # From https://github.com/matfmc/mazegenerator
  for (i in 1:nrow(maze)) {
    if (i == 1) {
      maze[i, 3:4] <- (maze[i, 1:2] - maze[i + 1, 1:2])
    } else if (i == nrow(maze)) {
      maze[i, 3:4] <- (maze[i, 1:2] - maze[i - 1, 1:2])
    } else {
      maze[i, 3:4] <- (maze[i, 1:2] - maze[i + 1, 1:2])
      maze[i, 5:6] <- (maze[i, 1:2] - maze[i - 1, 1:2])
    }
  }
  maze[maze[, 3] == -1 & maze[, 4] == 0, "start"] <- "A"
  maze[maze[, 3] == 0 & maze[, 4] == -1, "start"] <- "B"
  maze[maze[, 3] == 1 & maze[, 4] == 0, "start"] <- "C"
  maze[maze[, 3] == 0 & maze[, 4] == 1, "start"] <- "D"
  maze[(maze[, 5] == -1 & maze[, 6] == 0) & !is.na(maze[, 5]), "end"] <- "A"
  maze[(maze[, 5] == 0 & maze[, 6] == -1) & !is.na(maze[, 5]), "end"] <- "B"
  maze[(maze[, 5] == 1 & maze[, 6] == 0) & !is.na(maze[, 5]), "end"] <- "C"
  maze[(maze[, 5] == 0 & maze[, 6] == 1) & !is.na(maze[, 5]), "end"] <- "D"
  maze$conec <- paste0(maze$start, maze$end)
  maze <- maze[, c(1, 2, 9)]
  maze[maze$conec == "CD" | maze$conec == "DC" | maze$conec == "DNA" | maze$conec == "CNA" | maze$conec == "CC" | maze$conec == "DD", "cell"] <- 1
  maze[maze$conec == "AC" | maze$conec == "CA" | maze$conec == "AD" | maze$conec == "DA" | maze$conec == "ANA" | maze$conec == "AA", "cell"] <- 2
  maze[maze$conec == "BC" | maze$conec == "CB" | maze$conec == "BD" | maze$conec == "DB" | maze$conec == "BNA" | maze$conec == "BB", "cell"] <- 3
  maze[maze$conec == "AB" | maze$conec == "BA", "cell"] <- 4
  for (i in 1:nrow(maze)) {
    if (canvas[maze$x[i], maze$y[i]] == 0) {
      canvas[maze$x[i], maze$y[i]] <- maze$cell[i]
    } else if (canvas[maze$x[i], maze$y[i]] == 4) {
      next
    } else if (canvas[maze$x[i], maze$y[i]] == 2 & maze$cell[i] == 3) {
      canvas[maze$x[i], maze$y[i]] <- 4
    } else if (canvas[maze$x[i], maze$y[i]] == 3 & maze$cell[i] == 2) {
      canvas[maze$x[i], maze$y[i]] <- 4
    } else if (canvas[maze$x[i], maze$y[i]] == 1) {
      canvas[maze$x[i], maze$y[i]] <- maze$cell[i]
    }
  }
  cell_type_0 <- matrix(c(0, 0, 0, 0, 0, 0, 0, 0, 0), ncol = 3, byrow = T)
  cell_type_1 <- matrix(c(0, 0, 1, 0, 0, 1, 1, 1, 1), ncol = 3, byrow = T)
  cell_type_2 <- matrix(c(0, 0, 1, 0, 0, 1, 0, 0, 1), ncol = 3, byrow = T)
  cell_type_3 <- matrix(c(0, 0, 0, 0, 0, 0, 1, 1, 1), ncol = 3, byrow = T)
  cell_type_4 <- matrix(c(0, 0, 0, 0, 0, 0, 0, 0, 1), ncol = 3, byrow = T)
  subCanvas <- as.list(canvas)
  dim(subCanvas) <- c(nrow(canvas), ncol(canvas))
  subCanvas[, ][subCanvas[, ] %in% 0] <- list(cell_type_0)
  subCanvas[, ][subCanvas[, ] %in% 1] <- list(cell_type_1)
  subCanvas[, ][subCanvas[, ] %in% 2] <- list(cell_type_2)
  subCanvas[, ][subCanvas[, ] %in% 3] <- list(cell_type_3)
  subCanvas[, ][subCanvas[, ] %in% 4] <- list(cell_type_4)
  b <- do.call(cbind, subCanvas[1, 1:ncol(canvas)])
  for (i in 2:nrow(canvas)) {
    a <- do.call(cbind, subCanvas[i, 1:ncol(canvas)])
    b <- rbind(b, a)
  }
  full_canvas <- t(rbind(1, cbind(1, b)))
  return(full_canvas)
}
