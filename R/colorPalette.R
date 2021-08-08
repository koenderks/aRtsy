#' Color palette generator.
#'
#' @description This function creates a random color palette, or allows the user to select a pre-implemented palette.
#'
#' @usage colorPalette(name, n = NULL)
#'
#' @param name   name of the color palette. See the \code{details} section for a list of implemented palettes.
#' @param n      the number of colors to select from the palette. Required if \code{name = 'random'}. Otherwise, if \code{NULL}, automatically selects all colors from the chosen palette.
#'
#' @details The following color palettes are implemented:
#'
#' \itemize{
#'  \item{\code{random}}
#'  \item{\code{tuscany1}}
#'  \item{\code{tuscany2}}
#' }
#'
#' @return A vector of colors.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#' 
#' @keywords canvas palette
#' 
#' @export

colorPalette <- function(name, n = NULL) {
  if (!is.null(n) && n < 1)
    stop("You must select at least one color.")
  if (name == 'random') {
    if (is.null(n))
      stop("The random palette requires that you specify how many colors should be selected.")
    palette <- character(n)
    for (i in 1:n)
      palette[i] <- grDevices::rgb(stats::runif(1, 0, 255), stats::runif(1, 0, 255), stats::runif(1, 0, 255), maxColorValue = 255)
  } else {
    palette <- switch(name,
                      'tuscany1' = c("firebrick", "goldenrod", "forestgreen", "navyblue"),
                      'tuscany2' = c('#500342', '#023b59', '#f9efdd', '#deaa70', '#711308'),
                      'tuscany3' = c('#b08653', '#f5daba', '#c9673c', '#f2ab4e', '#a1863b'))
    if (is.null(n))
      n <- length(palette)
    if (n > length(palette))
      stop("Attempt to select more colors than are available in this palette.")
    palette <- palette[1:n]
  }
  return(palette)
}