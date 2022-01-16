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
arma::mat draw_turmite(arma::mat X,
                       int iters,
                       int row,
                       int col,
                       double p) {
  int m = X.n_rows;
  int n = X.n_cols;
  int i = 0;
  int state = 0;
  while (i < iters) {
    Rcpp::checkUserInterrupt();
    double swap = ceil(R::runif(0, 2));
    if (swap < p) {
      if (state == 0) {
        state = 1;
      } else if (state == 1) {
        state = 0;
      }
    }
    if (X(row,col) == 1) {
      // Color
      if (state == 0 && X(row,col) == 0) {
        state = 0;
      } else if (state == 0 && X(row,col) == 1) {
        state = 1;
        X(row,col) = 0;
      } else if (state == 1 && X(row,col) == 0) {
        state = 0;
        X(row,col) = 0;
      } else if (state == 1 && X(row,col) == 1) {
        state = 1;
      }
    } else {
      X(row,col) = 1;
    }
    // Turn
    int direction;
    direction = ceil(R::runif(0, 4));
    if (state == 0) {
      if (direction == 1 && row < (m - 1)) {
        row++; 
      } else if (direction == 2 && row >= 1) {
        row--;
      } else if (direction == 3 && col < (n - 1)) {
        col++;
      } else if (direction == 4 && col >= 1) {
        col--;
      } 
    } else if (state == 1) {
      if (direction == 4 && row < (m - 2)) {
        row++;
      } else if (direction == 1 && row >= 2) {
        row--;
      } else if (direction == 2 && col < (n - 2)) {
        col++;
      } else if (direction == 3 && col >= 2) {
        col--;
      }
    }
    i++;
  }
  return X;
}