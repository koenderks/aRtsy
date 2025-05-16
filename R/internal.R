# Copyright (C) 2021-2023 Koen Derks

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

# This function generates noise
.noise <- function(dims, n = 100, type = c("artsy-knn", "knn", "svm", "rf", "perlin", "cubic", "simplex", "worley"),
                   k = 20, limits = c(0, 1)) {
  type <- match.arg(type)
  if (type == "artsy-knn") {
    if (length(dims) == 1) {
      vec <- expand.grid(limits[1], seq(limits[1], limits[2], length.out = dims))
    } else if (length(dims) == 2) {
      vec <- expand.grid(seq(limits[1], limits[2], length.out = dims[1]), seq(limits[1], limits[2], length.out = dims[2]))
    }
    z <- cpp_knn(stats::runif(n), stats::runif(n), stats::runif(n), vec[, 1], vec[, 2], k)
  } else if (type == "svm") {
    train <- data.frame(
      x = stats::runif(n, limits[1], limits[2]),
      y = stats::runif(n, limits[1], limits[2]),
      z = stats::runif(n, limits[1], limits[2])
    )
    fit <- e1071::svm(formula = z ~ x + y, data = train)
    xsequence <- seq(limits[1], limits[2], length = dims[1])
    ysequence <- seq(limits[1], limits[2], length = dims[2])
    canvas <- expand.grid(xsequence, ysequence)
    colnames(canvas) <- c("x", "y")
    z <- predict(fit, newdata = canvas)
  } else if (type == "knn") {
    train <- data.frame(
      x = stats::runif(n, limits[1], limits[2]),
      y = stats::runif(n, limits[1], limits[2]),
      z = stats::runif(n, limits[1], limits[2])
    )
    xsequence <- seq(limits[1], limits[2], length = dims[1])
    ysequence <- seq(limits[1], limits[2], length = dims[2])
    canvas <- expand.grid(xsequence, ysequence)
    colnames(canvas) <- c("x", "y")
    z <- FNN::knn.reg(train = train[, c("x", "y")], test = canvas[, c("x", "y")], y = train[, "z"], k = k)$pred
  } else if (type == "rf") {
    train <- data.frame(
      x = stats::runif(n, limits[1], limits[2]),
      y = stats::runif(n, limits[1], limits[2]),
      z = stats::runif(n, limits[1], limits[2])
    )
    fit <- randomForest::randomForest(formula = z ~ x + y, data = train)
    xsequence <- seq(limits[1], limits[2], length = dims[1])
    ysequence <- seq(limits[1], limits[2], length = dims[2])
    canvas <- expand.grid(xsequence, ysequence)
    colnames(canvas) <- c("x", "y")
    z <- predict(fit, newdata = canvas)
  } else if (type == "perlin") {
    z <- ambient::noise_perlin(dims, frequency = stats::runif(1, 0.001, 0.04))
    z <- (z - range(z)[1]) / diff(range(z)) * diff(limits) + limits[1]
  } else if (type == "cubic") {
    z <- ambient::noise_cubic(dims, frequency = stats::runif(1, 0.001, 0.04))
    z <- (z - range(z)[1]) / diff(range(z)) * diff(limits) + limits[1]
  } else if (type == "simplex") {
    z <- ambient::noise_simplex(dims, frequency = stats::runif(1, 0.001, 0.04))
    z <- (z - range(z)[1]) / diff(range(z)) * diff(limits) + limits[1]
  } else if (type == "worley") {
    z <- ambient::noise_worley(dims)
    z <- (z - range(z)[1]) / diff(range(z)) * diff(limits) + limits[1]
  }
  return(matrix(z, nrow = dims[1], ncol = dims[2]))
}

# This function performs validation checks on the standardized input arguments of a function
.checkUserInput <- function(background = NULL, resolution = NULL, iterations = NULL) {
  if (!is.null(background) && length(background) != 1) {
    stop("'background' must be a single character")
  }
  if (!is.null(resolution) && (resolution < 1 || resolution %% 1 != 0)) {
    stop("'resolution' must be a single value > 0")
  }
  if (!is.null(iterations) && (iterations < 1 || iterations %% 1 != 0)) {
    stop("'iterations' must be a single integer > 0")
  }
}

# This function turns a matrix into a data frame with columns x, y, and z
.unraster <- function(x, names) {
  newx <- data.frame(x = rep(seq_len(ncol(x)), times = ncol(x)), y = rep(seq_len(nrow(x)), each = nrow(x)), z = c(x))
  colnames(newx) <- names
  return(newx)
}

# This function takes a point (x, y) and returns a warped point (x, y)
.warp <- function(p, warpDistance, resolution, angles = NULL, distances = NULL) {
  if (is.null(angles)) {
    angles <- .noise(c(resolution, resolution), type = sample(c("svm", "perlin", "cubic", "simplex"), size = 1), limits = c(-pi, pi))
  } else if (is.character(angles)) {
    angles <- .noise(c(resolution, resolution), type = angles, limits = c(-pi, pi))
  } else if (is.matrix(angles)) {
    if (nrow(angles) != resolution || ncol(angles) != resolution) {
      stop(paste0("'angles' should be a ", resolution, " x ", resolution, " matrix"))
    }
  }
  if (is.null(distances)) {
    distances <- .noise(c(resolution, resolution), type = sample(c("knn", "perlin", "cubic", "simplex"), size = 1), limits = c(0, warpDistance))
  } else if (is.character(distances)) {
    distances <- .noise(c(resolution, resolution), type = distances, limits = c(0, warpDistance))
  } else if (is.matrix(distances)) {
    if (nrow(distances) != resolution || ncol(distances) != resolution) {
      stop(paste0("'distances' should be a ", resolution, " x ", resolution, " matrix"))
    }
  }
  return(matrix(c(p[, 1] + c(cos(angles)) * c(distances), p[, 2] + c(sin(angles)) * c(distances)), ncol = 2))
}

# This function returns a brownian motion line
.bmline <- function(n, lwd) {
  x <- cumsum(stats::rnorm(n = n, sd = sqrt(1)))
  x <- abs(x / stats::sd(x) * lwd)
  return(x)
}

# This function returns the time elapsed
.runtime <- function(expression, name = NULL) {
  s1 <- Sys.time()
  eval(expression)
  s2 <- Sys.time()
  cat("\n", if (is.null(name)) NULL else paste0("[", name, "]"), "Runtime:", round(s2 - s1, 5), "seconds\n")
  return(invisible(as.numeric(s2 - s1)))
}
