# This function turns a matrix into a data frame with columns x, y, and z
unraster <- function(x, names) {
  newx <- data.frame(x = rep(1:ncol(x), times = ncol(x)), y = rep(1:nrow(x), each = nrow(x)), z = c(x))
  colnames(newx) <- names
  return(newx)
}