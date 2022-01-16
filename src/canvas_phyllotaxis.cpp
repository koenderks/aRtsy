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
#include <math.h>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
Rcpp::DataFrame iterate_phyllotaxis(int iter,
                                    double a,
                                    double p) {
  Rcpp::NumericVector x;
  Rcpp::NumericVector y;
  for (int i = 1; i < iter + 1; i++) {
    Rcpp::checkUserInterrupt();
    double s = R::runif(0, 1);
    if (s < p) {
      x.push_back(sqrt( (double) i) * cos(a * i));
      y.push_back(sqrt( (double) i) * sin(a * i));
    }
  }
  Rcpp::DataFrame X = Rcpp::DataFrame::create(Rcpp::Named("x") = x,
                                              Rcpp::Named("y") = y);
  return X;
}