#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
Rcpp::NumericVector iterate_chladni(Rcpp::NumericVector x,
                          Rcpp::NumericVector y,
                          Rcpp::NumericVector waves) {
  int n = x.length();
  int k = waves.length();
  Rcpp::NumericVector z (n);
  for (int i = 0; i < k; i++) {
    for (int j = 0; j < n; j++) {
      Rcpp::checkUserInterrupt();
      z[j] += fabs(sin(waves[i] *  x[j]) * sin(waves[i] * y[j]));
    }
  }
  return z;
}