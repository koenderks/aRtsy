#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
Rcpp::DataFrame iterate_flow(arma::mat angles, 
							 int j,
							 int iters, 
							 int left, 
							 int right, 
							 int top, 
							 int bottom, 
							 double step,
							 int r) {
  Rcpp::DoubleVector x = {ceil(R::runif(left + 1, right - 1))};
  Rcpp::DoubleVector y = {ceil(R::runif(bottom + 1, top - 1))};
  int m = angles.n_rows;
  int n = angles.n_cols;
  for (int i = 0; i < iters; i++) {
	Rcpp::checkUserInterrupt();
    double x_offset = x[x.length() - 1] - left;
    double y_offset = y[y.length() - 1] - bottom;
    int col_index = round(x_offset / r);
    int row_index = round(y_offset / r);
    if (col_index >= n || col_index <= 0 || row_index >= m || row_index <= 0) {
      break;
    }
    double angle = angles(row_index, col_index);
    double xnew = x[x.length() - 1] + step * cos(angle);
    double ynew = y[y.length() - 1] + step * sin(angle);
    x.push_back(xnew);
    y.push_back(ynew);
  }
  Rcpp::IntegerVector z (x.length(), j);
  Rcpp::DataFrame flow = Rcpp::DataFrame::create(Rcpp::Named("x") = x, 
                                                 Rcpp::Named("y") = y,
												 Rcpp::Named("z") = z);
  return flow;
}