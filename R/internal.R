# This function turns a matrix into a data frame with columns x, y, and z
unraster <- function(x, names) {
  newx <- data.frame(x = rep(1:ncol(x), times = ncol(x)), y = rep(1:nrow(x), each = nrow(x)), z = c(x))
  colnames(newx) <- names
  return(newx)
}

noise <- function(dims, type = "knn", n = 100) {
  if (length(dims) == 1) {
    vec <- expand.grid(0, seq(0, 1, length.out = dims)) # Create all combinations of pixels
  } else if (length(dims) == 2) {
    vec <- expand.grid(seq(0, 1, length.out = dims[1]), seq(0, 1, length.out = dims[2])) # Create all combinations of pixels
  }
  colnames(vec) <- c("x", "y")
  train <- data.frame(x = stats::runif(n, 0, 1), y = stats::runif(n, 0, 1), z = stats::runif(n, 0, 1))
  if (type == 'knn') {
    fit <- kknn::train.kknn(formula = z ~ x + y, data = train) # Fit knn model to training data
  } else if (type == "svm") {
    fit <- e1071::svm(formula = z ~ x + y, data = train)
  } else if (type == 'rf') {
    fit <- randomForest::randomForest(formula = z ~ x + y, data = train)
  }
  z <- predict(fit, newdata = vec) # Predict each pixel using the fitted model
  if (length(dims) == 1) {
    newx <- z
  } else if (length(dims) == 2) {
    newx <- matrix(z, nrow = dims[1], ncol = dims[2])
  }
  return(newx)
}