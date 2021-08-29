# This function turns a matrix into a data frame with columns x, y, and z
unraster <- function(x, names) {
  newx <- data.frame(x = rep(1:ncol(x), times = ncol(x)), y = rep(1:nrow(x), each = nrow(x)), z = c(x))
  colnames(newx) <- names
  return(newx)
}

# Function to generate k-nearest neighbors noise
noise <- function(dims, k = 20, n = 100) {
  if (length(dims) == 1) {
    vec <- expand.grid(0, seq(0, 1, length.out = dims)) # Create all combinations of pixels
  } else if (length(dims) == 2) {
    vec <- expand.grid(seq(0, 1, length.out = dims[1]), seq(0, 1, length.out = dims[2])) # Create all combinations of pixels
  }
  z <- c_noise_knn(stats::runif(n), stats::runif(n), stats::runif(n), vec[, 1], vec[, 2], k, n)
  return(matrix(z, nrow = dims[1], ncol = dims[2]))
}

# Function for aRtsy-painting-bot only
canvas_noise <- function(colors, k = 50, n = 500, resolution = 2000) {
  dims <- c(resolution, resolution)
  canvas <- noise(dims = dims, k, n)
  canvas <- unraster(canvas, c('x', 'y', 'z'))
  artwork <- ggplot2::ggplot(data = canvas, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster() +
    ggplot2::scale_fill_gradientn(colors = colors)
  artwork <- aRtsy::theme_canvas(artwork)
  return(artwork)
}