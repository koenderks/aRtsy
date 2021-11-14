#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat iterate_chladni(arma::mat X,
                          Rcpp::IntegerVector waves,
                          double f) {
  int m = X.n_rows;
  int n = X.n_cols;
  int iter = waves.length();
  for (int k = 0; k < iter; k++) {
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        Rcpp::checkUserInterrupt();
        X(i, j) = abs(X(i, j) + sin(waves[k] * f * i) * sin(waves[k] * f * j));
      }
    }
  }
  return X;
}