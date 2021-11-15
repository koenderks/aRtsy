#' @useDynLib aRtsy
#' @import Rcpp
#' @importFrom stats predict
NULL

utils::globalVariables(c("x", "y", "z"))
utils::globalVariables(c("width", "height"))
utils::globalVariables(c("xend", "yend", "type"))
