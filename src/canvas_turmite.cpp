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
    double stateSwap = ceil(R::runif(0, 2));
    if (stateSwap < p) {
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