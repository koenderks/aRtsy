# This function performs validation checks on the standardized input arguments of a function
.checkUserInput <- function(background = NULL, width = NULL, height = NULL, iterations = NULL) {
  if (!is.null(background) && length(background) != 1) {
    stop("'background' should be a single character")
  }
  if (!is.null(width) && width < 1) {
    stop("'width' should be a single value > 0")
  }
  if (!is.null(height) && height < 1) {
    stop("'height' should be a single value > 0")
  }
  if (!is.null(iterations) && iterations < 1) {
    stop("'iterations' should be a single value > 0")
  }
}

# This function turns a matrix into a data frame with columns x, y, and z
.unraster <- function(x, names) {
  newx <- data.frame(x = rep(1:ncol(x), times = ncol(x)), y = rep(1:nrow(x), each = nrow(x)), z = c(x))
  colnames(newx) <- names
  return(newx)
}

# This function computes k-nearest neighbors noise from c++
.noise <- function(dims, k = 20, n = 100) {
  if (length(dims) == 1) {
    vec <- expand.grid(0, seq(0, 1, length.out = dims)) # Create all combinations of pixels
  } else if (length(dims) == 2) {
    vec <- expand.grid(seq(0, 1, length.out = dims[1]), seq(0, 1, length.out = dims[2])) # Create all combinations of pixels
  }
  z <- c_noise_knn(stats::runif(n), stats::runif(n), stats::runif(n), vec[, 1], vec[, 2], k, n)
  return(matrix(z, nrow = dims[1], ncol = dims[2]))
}
