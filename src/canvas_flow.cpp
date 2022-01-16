// Copyright (C) 2021-2022 Koen Derks

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
                             double step) {
  Rcpp::DoubleVector x = {ceil(R::runif(left + 1, right - 1))};
  Rcpp::DoubleVector y = {ceil(R::runif(bottom + 1, top - 1))};
  int m = angles.n_rows;
  int n = angles.n_cols;
  for (int i = 0; i < iters; i++) {
    Rcpp::checkUserInterrupt();
    int col_index = x[x.length() - 1] - left;
    int row_index = y[y.length() - 1] - bottom;
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