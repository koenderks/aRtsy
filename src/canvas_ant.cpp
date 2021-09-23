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
                   int row,
                   int col,
                   std::vector<int> dx,
                   std::vector<int> dy) {
  int m = X.n_rows;
  int n = X.n_cols;
  int k = dy.size(); // Number of colors is number of rows in the c data frame
  int i = 0;
  int direction = 0; // 1 = left, 2 = up, 3 = right, 4 = down
  int color = 0; // The current color starts at the first in the colors
  int typeZero = 0; // 0 = R; 1 = L
  int typeOne = 0; // 0 = L; 1 = R
  int s = 10000;
  while (i < iters) {
	Rcpp::checkUserInterrupt();
    if (i%s == 0) { // Switch color every s iterations
      color = color + 1; // Next color
      if (color > k) {
        color = 1;
      }
      typeZero = dx[color - 1];
      typeOne = dy[color - 1];
    }
    if (X(row, col) == 0) { // White square
      if (typeZero == 0) { // Turn 90 degrees clockwise for R (Langtons Ant)
        direction = direction + 1;
        if (direction == 5) {
          direction = 1;
        }
      } else if (typeZero == 1) { // Turn 90 degrees counter-clockwise for L
        direction = direction - 1;
        if (direction == 0) {
          direction = 4;
        }	  
      }
      // Color the square
      X(row, col) = color;
    } else { // Colored square
      if (typeOne == 0) { // Turn 90 degrees counter-clockwise for L (Langtons ant)
        direction = direction - 1;
        if (direction == 0) {
          direction = 4;
        }
      } else if (typeOne == 1) { // Turn 90 degrees clockwise for R
        direction = direction + 1;
        if (direction == 5) {
          direction = 1;
        }	  
      }
      // Undo the color on the square
      X(row, col) = 0;
    }
    // Move the ant
    if (direction == 1 && row >= 1) {
      row = row - 1; 
    } else if (direction == 2 && col >= 1) {
      col = col - 1;
    } else if (direction == 3 && row < (m - 1)) {
      row = row + 1;
    } else if (direction == 4 && col < (n - 1)) {
      col = col + 1;
    } 
    i = i + 1;
  }
  return X;
}