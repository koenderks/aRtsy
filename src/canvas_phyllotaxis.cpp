#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
Rcpp::DataFrame iterate_phyllotaxis(int iter,
                                    double a,
                                    double p) {
  Rcpp::NumericVector x;
  Rcpp::NumericVector y;
  for (int i = 1; i < (iter + 1); i++) {
    Rcpp::checkUserInterrupt();
    double s = R::runif(0, 1);
    if (s < p) {
      x.push_back(sqrt(i) * cos(a * i));
      y.push_back(sqrt(i) * sin(a * i));
    }
  }
  Rcpp::DataFrame X = Rcpp::DataFrame::create(Rcpp::Named("x") = x,
                                              Rcpp::Named("y") = y);
  return X;
}