# This function turns a matrix into a data frame with columns x, y, and z
unraster <- function(x, names) {
  newx <- data.frame(x = rep(1:ncol(x), times = ncol(x)), y = rep(1:nrow(x), each = nrow(x)), z = c(x))
  colnames(newx) <- names
  return(newx)
}

noise <- function(dims, k = 20, n = 100) {
  if (length(dims) == 1) {
    vec <- expand.grid(0, seq(0, 1, length.out = dims)) # Create all combinations of pixels
  } else if (length(dims) == 2) {
    vec <- expand.grid(seq(0, 1, length.out = dims[1]), seq(0, 1, length.out = dims[2])) # Create all combinations of pixels
  }
  z <- c_noise_knn(stats::runif(n), stats::runif(n), stats::runif(n), vec[, 1], vec[, 2], k, n)
  return(matrix(z, nrow = dims[1], ncol = dims[2]))
}
