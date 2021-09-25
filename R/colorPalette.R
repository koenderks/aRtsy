#' Color Palette Generator
#'
#' @description This function creates a random color palette, or allows the user to select a pre-implemented palette.
#'
#' @usage colorPalette(name, n = NULL)
#'
#' @param name   name of the color palette. Can be \code{random} for random colors, but can also be the name of a pre-implemented palette. See the \code{details} section for a list of pre-implemented palettes.
#' @param n      the number of colors to select from the palette. Required if \code{name = 'random'}. Otherwise, if \code{NULL}, automatically selects all colors from the chosen palette.
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
#' colorPalette("random", 5)
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
    palette <- grDevices::rgb(stats::runif(n, 0, 255), stats::runif(n, 0, 255), stats::runif(n, 0, 255), maxColorValue = 255)
  } else {
    palette <- switch(name,
      "blackwhite" = c("black", "white"),
      "dark1" = c("#161616", "#346751", "#C84B31", "#ECDBBA"),
      "dark2" = c("#1B262C", "#0F4C75", "#3282B8", "#BBE1FA"),
      "dark3" = c("#222831", "#393E46", "#00ADB5", "#EEEEEE"),
      "house" = c("#191919", "white", "#960606", "#cca222", "#036440"),
      "jasp" = c("#14a1e3", "#ffffff", "#f7971c", "#8cc63e", "#000000"),
      "jfa" = c("#2a94d1", "#e89643", "#233e4a"),
      "jungle" = c("#4e6349", "#614128", "#171812", "#698144", "#917861"),
      "lava" = c("#f59907", "#a42300", "#482a22", "#050000", "#6b0800"),
      "nature" = c("forestgreen", "dodgerblue", "brown", "white", "gray"),
      "neon1" = c("#F7FD04", "#F9B208", "#F98404", "#FC5404"),
      "neon2" = c("#F5F7B2", "#1CC5DC", "#890596", "#CF0000"),
      "retro1" = c("#0A1931", "#185ADB", "#FFC947", "#EFEFEF"),
      "retro2" = c("#DDDDDD", "#222831", "#30475E", "#F05454"),
      "retro3" = c("#111D5E", "#C70039", "#F37121", "#C0E218"),
      "tuscany1" = c("firebrick", "goldenrod", "forestgreen", "navyblue"),
      "tuscany2" = c("#500342", "#023b59", "#f9efdd", "#deaa70", "#711308"),
      "tuscany3" = c("#b08653", "#f5daba", "#c9673c", "#f2ab4e", "#a1863b")
    )
    if (is.null(palette)) {
      stop(paste0("'", name, "' is not an existing palette"))
    }
    if (is.null(n)) {
      n <- length(palette)
    }
    if (n > length(palette)) {
      stop("attempt to select more colors than are available in this palette")
    }
    palette <- palette[1:n]
  }
  return(palette)
}
