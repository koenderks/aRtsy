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
Rcpp::DataFrame draw_splits(Rcpp::NumericVector x,
                            Rcpp::NumericVector xend,
                            Rcpp::NumericVector y,
                            Rcpp::NumericVector yend,
                            Rcpp::NumericVector col,
                            double sda,
                            int ncols,
                            int iterations) {
  for (int i = 0; i < iterations; i++) {
    int l1 = x.length() * 4;
    Rcpp::NumericVector x2 (l1);
    Rcpp::NumericVector xend2 (l1);
    Rcpp::NumericVector y2 (l1);
    Rcpp::NumericVector yend2 (l1);
    Rcpp::NumericVector col2 (l1);
    for (int j = 0; j < x.length(); j++) {
      int index = j * 4;
      double xdir = xend[j] - x[j];
      double ydir = yend[j] - y[j];
      double center_x = x[j] + xdir / 2;
      double center_y = y[j] + ydir / 2;
      double d = sqrt(pow(xdir, 2) + pow(ydir, 2));
      double r = d * 0.49;
      double cur_angle = atan2(ydir, xdir);
      double new_angle = cur_angle + M_PI / 2 + R::rnorm(0, sda);
      x2[index + 0] = x[j];
      x2[index + 1] = x[j] + 0.47 * xdir;
      x2[index + 2] = center_x + r * cos(new_angle);
      x2[index + 3] = x[j] + 0.53 * xdir;
      xend2[index + 0] = x2[index + 1];
      xend2[index + 1] = x2[index + 2];
      xend2[index + 2] = x2[index + 3];
      xend2[index + 3] = xend[j];
      y2[index + 0] = y[j];
      y2[index + 1] = y[j] + 0.47 * ydir;
      y2[index + 2] = center_y + r * sin(new_angle);
      y2[index + 3] = y[j] + 0.53 * ydir;
      yend2[index + 0] = y2[index + 1];
      yend2[index + 1] = y2[index + 2];
      yend2[index + 2] = y2[index + 3];
      yend2[index + 3] = yend[j];
      double r1 = R::runif(0, 1);
      if (r1 < 0.5) {
        col2[index + 0] = col[j];
        col2[index + 1] = col[j];
        col2[index + 2] = col[j];
        col2[index + 3] = col[j];
      } else {
        double r2 = R::runif(0, 1);
        col2[index + 0] = ceil(r2 * ncols);
        col2[index + 1] = col[j];
        col2[index + 2] = col[j];
        col2[index + 3] = col[j];
      }
    }
    x = x2;
    xend = xend2;
    y = y2;
    yend = yend2;
    col = col2;
  }
  int nlines = 3;
  int l2 = x.length() * nlines;
  Rcpp::NumericVector nx (l2);
  Rcpp::NumericVector nxend (l2);
  Rcpp::NumericVector ny (l2);
  Rcpp::NumericVector nyend (l2);
  Rcpp::NumericVector ncol (l2);
  int nrows = x.length();
  for (int i = 0; i < nrows; i++) {
    for (int j = 0; j < nlines; j++ ){
      int index    = i * nlines + j;
      nx[index]    = R::rnorm(x[i], 0.0025);
      nxend[index] = R::rnorm(xend[i], 0.0025);
      ny[index]    = R::rnorm(y[i], 0.0025);
      nyend[index] = R::rnorm(yend[i], 0.0025);
      ncol[index]  = col[i];
    }
  }
  Rcpp::DataFrame X = Rcpp::DataFrame::create(Rcpp::Named("x") = nx,
                                              Rcpp::Named("xend") = nxend,
                                              Rcpp::Named("y") = ny,
                                              Rcpp::Named("yend") = nyend,
                                              Rcpp::Named("col") = ncol);
  return X;
}