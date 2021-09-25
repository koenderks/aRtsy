#' @importFrom stats predict

# This function computes k-nearest neighbors noise from c++
.noise <- function(dims, n = 100, type = c("artsy-knn", "knn", "svm", "rf"), k = 20) {
  type <- match.arg(type)
  if (type == "artsy-knn") {
    if (length(dims) == 1) {
      vec <- expand.grid(0, seq(0, 1, length.out = dims))
    } else if (length(dims) == 2) {
      vec <- expand.grid(seq(0, 1, length.out = dims[1]), seq(0, 1, length.out = dims[2]))
    }
    z <- c_noise_knn(stats::runif(n), stats::runif(n), stats::runif(n), vec[, 1], vec[, 2], k, n)
  } else if (type == "svm") {
    train <- data.frame(
      x = stats::runif(n, 0, 1),
      y = stats::runif(n, 0, 1),
      z = stats::runif(n, 0, 1)
    )
    fit <- e1071::svm(formula = z ~ x + y, data = train)
    xsequence <- seq(0, 1, length = dims[1])
    ysequence <- seq(0, 1, length = dims[2])
    canvas <- expand.grid(xsequence, ysequence)
    colnames(canvas) <- c("x", "y")
    z <- predict(fit, newdata = canvas)
  } else if (type == "knn") {
    train <- data.frame(
      x = stats::runif(n, 0, 1),
      y = stats::runif(n, 0, 1),
      z = stats::runif(n, 0, 1)
    )
    fit <- kknn::train.kknn(formula = z ~ x + y, data = train, kmax = k)
    xsequence <- seq(0, 1, length = dims[1])
    ysequence <- seq(0, 1, length = dims[2])
    canvas <- expand.grid(xsequence, ysequence)
    colnames(canvas) <- c("x", "y")
    z <- predict(fit, newdata = canvas)
  } else if (type == "rf") {
    train <- data.frame(
      x = stats::runif(n, 0, 1),
      y = stats::runif(n, 0, 1),
      z = stats::runif(n, 0, 1)
    )
    fit <- randomForest::randomForest(formula = z ~ x + y, data = train)
    xsequence <- seq(0, 1, length = dims[1])
    ysequence <- seq(0, 1, length = dims[2])
    canvas <- expand.grid(xsequence, ysequence)
    colnames(canvas) <- c("x", "y")
    z <- predict(fit, newdata = canvas)
  }
  return(matrix(z, nrow = dims[1], ncol = dims[2]))
}

# This function performs validation checks on the standardized input arguments of a function
.checkUserInput <- function(background = NULL, width = NULL, height = NULL, iterations = NULL) {
  if (!is.null(background) && length(background) != 1) {
    stop("'background' should be a single character")
  }
  if (!is.null(width) && (width < 1 || width %% 1 != 0)) {
    stop("'width' should be a single value > 0")
  }
  if (!is.null(height) && (height < 1 || height %% 1 != 0)) {
    stop("'height' should be a single integer > 0")
  }
  if (!is.null(iterations) && (iterations < 1 || iterations %% 1 != 0)) {
    stop("'iterations' should be a single integer > 0")
  }
}

# This function turns a matrix into a data frame with columns x, y, and z
.unraster <- function(x, names) {
  newx <- data.frame(x = rep(1:ncol(x), times = ncol(x)), y = rep(1:nrow(x), each = nrow(x)), z = c(x))
  colnames(newx) <- names
  return(newx)
}
