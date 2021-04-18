#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>
#include <math.h>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat iterate_planet(arma::mat X, 
                         int radius,
                         int xcenter,
                         int ycenter,
                         int threshold,
                         int iterations,
                         int seed,
                         int ncolors){
  int m = X.n_rows;
  int n = X.n_cols;
  std::vector<int> xcircle; // Vector of x-locations of all circle points
  std::vector<int> ycircle; // Vector of y-locations of all circle points
  srand (seed);
  // Draw planet circle
  for (int row = 0; row < m; row++) {
    for (int col = 0; col < n; col++) {
      float xdist = xcenter - col;
      float ydist = ycenter - row;
      double dist = sqrt(xdist * xdist + ydist * ydist);
      if (dist <= radius) { // Check if circle point
        X(row, col) = (rand() % ncolors) + 1; // Sample random color from the palette
        xcircle.push_back (col); // Store x-location of circle point
        ycircle.push_back (row); // Store y-location of circle point
      }
    }
  }
  // Fill the circle
  for (int i = 0; i < iterations; i++) {
    for (int ii = 0; ii < xcircle.size(); ii++) {
      int xpoint = xcircle[ii];
      int ypoint = ycircle[ii];
      if (ypoint > 0 && ypoint < (m-1) && xpoint > 0 && xpoint < (n-1)) {
        int level = X(ypoint, xpoint); // Get the current level 
        int newlevel = ((level + 1) % ncolors) + 1;
        int higherlevels = 0;
        if (X(ypoint - 1, xpoint) == newlevel)     higherlevels++;
        if (X(ypoint + 1, xpoint) == newlevel)     higherlevels++;
        if (X(ypoint - 1, xpoint - 1) == newlevel) higherlevels++;
        if (X(ypoint, xpoint - 1) == newlevel)     higherlevels++;
        if (X(ypoint + 1, xpoint - 1) == newlevel) higherlevels++;
        if (X(ypoint - 1, xpoint + 1) == newlevel) higherlevels++;
        if (X(ypoint, xpoint + 1) == newlevel)     higherlevels++;
        if (X(ypoint + 1, xpoint + 1) == newlevel) higherlevels++;
        if (higherlevels >= threshold) {
          X(ypoint, xpoint) = newlevel;
        } else {
          X(ypoint, xpoint) = level;
        }
      }
    }
  }
  return X;
};
