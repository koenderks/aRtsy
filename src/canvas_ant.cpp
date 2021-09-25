#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>
#include <math.h>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat draw_ant(arma::mat X,
                   int iters,
                   int ncolors,
                   int x,
                   int y,
                   std::vector<int> dx,
                   std::vector<int> dy) {
  int m = X.n_rows;
  int n = X.n_cols;
  int k = dy.size(); // Number of colors is number of rows in the c data frame
  int i = 0;
  int d = 0; // 1 = left, 2 = up, 3 = right, 4 = down
  int c = 0; // The current color starts at the first in the colors
  int t0 = 0; // 0 = R; 1 = L
  int t1 = 0; // 0 = L; 1 = R
  int s = ceil(iters / ncolors); // When to switch colors in the ant
  while (i < iters) {
    Rcpp::checkUserInterrupt();
    if (i%s == 0) { // Switch color every s iterations
      c = c + 1; // Next color
      if (c > k) {
        c = 1;
      }
      t0 = dx[c - 1];
      t1 = dy[c - 1];
    }
    if (X(x, y) == 0) { // White square
      if (t0 == 0) { // Turn 90 degrees clockwise for R (Langtons Ant)
        d = d + 1;
        if (d == 5) {
          d = 1;
        }
      } else if (t1 == 1) { // Turn 90 degrees counter-clockwise for L
        d = d - 1;
        if (d == 0) {
          d = 4;
        }
      }
      // Color the square
      X(x, y) = c;
    } else { // Colored square
      if (t1 == 0) { // Turn 90 degrees counter-clockwise for L (Langtons ant)
        d = d - 1;
        if (d == 0) {
          d = 4;
        }
      } else { // Turn 90 degrees clockwise for R
        d = d + 1;
        if (d == 5) {
          d = 1;
        }	  
      }
      // Undo the color on the square
      X(x, y) = 0;
    }
    // Move the ant
    if (d == 1) {
      x = x - 1; 
      if (x < 0) {
        x = m - 1;
      }
    } else if (d == 2) {
      y = y - 1;
      if (y < 0) {
        y = n - 1;
      }
    } else if (d == 3) {
      x = x + 1;
      if (x >= (m - 1)) {
        x = 0;
      }
    } else if (d == 4) {
      y = y + 1;
      if (y >= (n - 1)) {
        y = 0;
      }
    }
    i = i + 1;
  }
  return X;
}