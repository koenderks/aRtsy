#' Generate Noise
#'
#' @description This function generates noise. Currently it is only capable of generating k-nearest neighbors noise.
#'
#' @usage noise(dims, k = 20, n = 100)
#'
#' @param dims        a vector containing the two dimenstions of the output.
#' @param k           a positive integer specifying the number of nearest neighbors to consider.
#' @param n           a positive integer specifying the number of random data points to generate.
#'
#' @return A matrix containing the noise values.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @examples
#' \donttest{
#' set.seed(6)
#' plot(as.raster(noise(dims = c(100, 100)))
#' }
#' 
#' @keywords noise
#'
#' @export

noise <- function(dims, k = 20, n = 100) {
  if (length(dims) == 1) {
    vec <- expand.grid(0, seq(0, 1, length.out = dims)) # Create all combinations of pixels
  } else if (length(dims) == 2) {
    vec <- expand.grid(seq(0, 1, length.out = dims[1]), seq(0, 1, length.out = dims[2])) # Create all combinations of pixels
  }
  z <- c_noise_knn(stats::runif(n), stats::runif(n), stats::runif(n), vec[, 1], vec[, 2], k, n)
  return(matrix(z, nrow = dims[1], ncol = dims[2]))
}
