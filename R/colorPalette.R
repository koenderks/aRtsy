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

#' Color Palette Generator
#'
#' @description This function creates a random color palette, or allows the user to select a pre-implemented palette.
#'
#' @usage colorPalette(name, n = NULL)
#'
#' @param name   name of the color palette. Can be \code{random} for random colors, \code{complement} for complementing colors, \code{divergent} for equally spaced colors, or \code{random-palette} for a random palette, but can also be the name of a pre-implemented palette. See the \code{details} section for a list of pre-implemented palettes.
#' @param n      the number of colors to select from the palette. Required if \code{name = 'random'}, \code{name = 'complement'}, or \code{name = 'divergent'}. Otherwise, if \code{NULL}, automatically selects all colors from the chosen palette.
#'
#' @details The following color palettes are implemented:
#'
#' \if{html}{\figure{colors.svg}{options: width=600 alt="colors"}}
#' \if{latex}{\figure{colors.pdf}{options: width=5in}}
#'
#' @return A vector of colors.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' colorPalette("divergent", 5)
#' @keywords canvas palette
#'
#' @export

colorPalette <- function(name, n = NULL) {
  if (!is.null(n) && (n < 1 || n %% 1 != 0)) {
    stop("'n' must be an integer > 0")
  }
  if (name == "random") {
    if (is.null(n)) {
      stop("'n' is missing for palette = 'random'")
    }
    palette <- character(n)
    for (i in 1:length(palette)) {
      palette[i] <- .hsl_to_rgb(h = stats::runif(1, 1, 360), stats::runif(1), stats::runif(1))
    }
  } else if (name == "complement") {
    palette <- character(n)
    tmp <- stats::runif(1, 1, 360)
    palette[1] <- .hsl_to_rgb(h = tmp, stats::runif(1, .4, .8), stats::runif(1, .4, .8))
    for (i in 2:length(palette)) {
      if (i %% 2 == 0) {
        if (tmp > 180) {
          color <- tmp - 180
        } else if (tmp < 180) {
          color <- tmp + 180
        } else {
          color <- tmp
        }
        palette[i] <- .hsl_to_rgb(h = color, stats::runif(1, .4, .8), stats::runif(1, .4, .8))
      } else {
        tmp <- stats::runif(1, 1, 360)
        palette[i] <- .hsl_to_rgb(h = tmp, stats::runif(1, .4, .8), stats::runif(1, .4, .8))
      }
    }
  } else if (name == "divergent") {
    palette <- character(n)
    start <- stats::runif(1, 0, 260)
    colSeq <- seq(from = 1, to = 360, length.out = n)
    h <- (colSeq + start) %% 360
    for (i in 1:length(palette)) {
      palette[i] <- .hsl_to_rgb(h = h[i], stats::runif(1, .4, .7), stats::runif(1, .4, .7))
    }
  } else {
    if (name == "random-palette") {
      name <- sample(c(
        "blackwhite", "bell", "boogy1", "boogy2", "boogy3", "dark1", "dark2", "dark3", "flora", "gogh", "house", "jasp", "jfa", "jungle",
        "klimt", "kpd", "lava", "nature", "mixer1", "mixer2", "mixer3", "mixer4", "neon1", "neon2", "origami", "retro1", "retro2",
        "retro3", "retro4", "sooph", "sky", "tuscany1", "tuscany2", "tuscany3", "vrolik1", "vrolik2", "vrolik3", "vrolik4", "vrolik5"
      ), size = 1)
    }
    palette <- switch(name,
      "blackwhite" = c("black", "white"),
      "bell" = c("#000000", "#ff0000", "#ffcc00"),
      "boogy1" = c("#a2a07a", "#c49700", "#b4b9cc", "#c0c1b1"),
      "boogy2" = c("#204b9a", "#f1e60e", "#ffffff", "#e5181d", "1d1d1b"),
      "boogy3" = c("#e9e489", "#995c25", "#5eb9f0", "#68b95d", "#69241f"),
      "dark1" = c("#161616", "#346751", "#C84B31", "#ECDBBA"),
      "dark2" = c("#1B262C", "#0F4C75", "#3282B8", "#BBE1FA"),
      "dark3" = c("#222831", "#393E46", "#00ADB5", "#EEEEEE"),
      "flora" = c("#000000", "#f2f2eb", "#ccb77c", "#523402"),
      "gogh" = c("#8699b5", "#161918", "#9d8018", "#232d8a", "#b4ad5a", "#c2ccd5"),
      "house" = c("#191919", "white", "#ab3920", "#cca222", "#036440"),
      "jasp" = c("#14a1e3", "#ffffff", "#f7971c", "#8cc63e", "#000000"),
      "jfa" = c("#2a94d1", "#e89643", "#233e4a"),
      "jungle" = c("#4e6349", "#614128", "#171812", "#698144", "#917861"),
      "klimt" = c("#847049", "#ba9d3e", "#29241f", "#a787b0", "#cd5627", "#7ea36e"),
      "kpd" = c("#c42f32", "#315b99", "#354741"),
      "lava" = c("#f59907", "#a42300", "#482a22", "#050000", "#6b0800"),
      "mixer1" = c("#fa9f29", "#15cab1", "0a633d", "2f3030"),
      "mixer2" = c("#a3a948", "#edb92e", "#f85931", "#ce1836", "#009989"),
      "mixer3" = c("#aacad5", "#c9e0e6", "#e0e9ee", "#dccda4", "#99886e"),
      "mixer4" = c("#20663F", "#259959", "#ABD406", "#FFD412", "#FF821C"),
      "nature" = c("forestgreen", "dodgerblue", "brown", "white", "gray"),
      "neon1" = c("#F7FD04", "#F9B208", "#F98404", "#FC5404"),
      "neon2" = c("#F5F7B2", "#1CC5DC", "#890596", "#CF0000"),
      "origami" = c("#01364f", "#84231e", "#247c86", "#e8674d", "#dfdbbe", "#fdf4b4"),
      "retro1" = c("#0A1931", "#185ADB", "#FFC947", "#EFEFEF"),
      "retro2" = c("#DDDDDD", "#222831", "#30475E", "#F05454"),
      "retro3" = c("#111D5E", "#C70039", "#F37121", "#C0E218"),
      "retro4" = c("#80A8A8", "#909D9E", "#A88C8C", "#FF0D51"),
      "sooph" = c("#d6c398", "#cbabdb", "#139485", "#9e1710", "#414952"),
      "sky" = c("#CFF09E", "#A8DBA8", "#79BD9A", "#3B8686", "#0B486B"),
      "tuscany1" = c("firebrick", "goldenrod", "forestgreen", "navyblue"),
      "tuscany2" = c("#500342", "#023b59", "#f9efdd", "#deaa70", "#711308"),
      "tuscany3" = c("#b08653", "#f5daba", "#c9673c", "#f2ab4e", "#a1863b"),
      "vrolik1" = c("#4ca787", "#183867", "#ea8857", "#442a37", "#ffb747"),
      "vrolik2" = c("#d8c888", "#f4edf3", "#fa428c", "#1900b4", "#ecd07d"),
      "vrolik3" = c("#774f38", "#e08e79", "#f1d4af", "#ece5ce", "#c5e0dc"),
      "vrolik4" = c("#16E0F2", "#080E10", "#E69E02", "#CB1BA3", "#BA097F"),
      "vrolik5" = c("#FBCE03", "#03F7EC", "#4D0E98", "#3A3838", "#150326")
    )
    if (is.null(palette)) {
      stop(paste0("'", name, "' is not an existing palette"))
    }
    if (is.null(n)) {
      n <- length(palette)
    }
    if (n > length(palette)) {
      warning("attempt to select more colors than are available in this palette, returning the requested palette with the maximum number of colors")
      return(palette)
    }
    palette <- palette[sample(1:n)]
  }
  return(palette)
}

.hsl_to_rgb <- function(h, s, l) {
  h <- h / 360
  r <- g <- b <- 0.0
  if (s == 0) {
    r <- g <- b <- l
  } else {
    q <- ifelse(l < 0.5, l * (1.0 + s), l + s - (l * s))
    p <- 2.0 * l - q
    r <- .hue_to_rgb(p, q, h + 1 / 3)
    g <- .hue_to_rgb(p, q, h)
    b <- .hue_to_rgb(p, q, h - 1 / 3)
  }
  col <- grDevices::rgb(r, g, b)
  return(col)
}

.hue_to_rgb <- function(p, q, t) {
  if (t < 0) {
    t <- t + 1.0
  }
  if (t > 1) {
    t <- t - 1.0
  }
  if (t < 1 / 6) {
    return(p + (q - p) * 6.0 * t)
  }
  if (t < 1 / 2) {
    return(q)
  }
  if (t < 2 / 3) {
    return(p + ((q - p) * ((2 / 3) - t) * 6))
  }
  return(p)
}
