#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>
#include <math.h>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat draw_polylines(arma::mat X,
                         double ratio,
                         int iters,
                         int rows,
                         int cols) {
  X(0, 0) = R::runif(0, cols);
  X(0, 1) = R::runif(0, rows);
  int xradius = cols * ratio;
  int yradius = rows * ratio;
  for (int i = 1; i < iters; i++) {
    double v = R::runif(0, 1);
    double h = R::runif(0, 1);
    double x1;
    if (h > 0.5) {
      x1 = X(i-1, 0) + R::rnorm(0, xradius);
      if (x1 < 0)
        x1 = 0;
      if (x1 > cols)
        x1 = cols;
      if ((x1 > (X(0, 0) + (xradius * R::runif(0.5, 2)))) | (x1 < (X(0, 0) - (xradius * R::runif(0.5, 2)))))
        x1 = X(i-1, 0);
    } else {
      x1 = X(i-1, 0);
    }
    X(i, 0) = x1;
    double y1;
    if (v > 0.5) {
      y1 = X(i-1, 1) + R::rnorm(0, yradius);
      if (y1 < 0)
        y1 = 0;
      if (y1 > rows)
        y1 = rows;
      if ((y1 > (X(0, 1) + (yradius * R::runif(0.5, 2)))) | (y1 < (X(0, 1) - (yradius * R::runif(0.5, 2)))))
        y1 = X(i-1, 1);
    } else {
      y1 = X(i-1, 1);
    }
    X(i, 1) = y1;
  }
  return X;
}