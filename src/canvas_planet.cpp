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
                         double starprob,
                         int ncolors,
                         int colorsused,
                         double fade,
                         int lightright) {
  int m = X.n_rows;
  int n = X.n_cols;
  std::vector<int> xcircle; // Vector of x-locations of all circle points
  std::vector<int> ycircle; // Vector of y-locations of all circle points
  // Draw planet circle
  for (int row = 0; row < m; row++) {
    for (int col = 0; col < n; col++) {
      float xdist = xcenter - col;
      float ydist = ycenter - row;
      double dist = sqrt(xdist * xdist + ydist * ydist);
      if (dist <= radius) { // Check if circle point
	      xcircle.push_back (col); // Store x-location of circle point
        ycircle.push_back (row); // Store y-location of circle point
        X(row, col) = 3 + colorsused + floor(R::runif(0, ncolors - 3)); // Sample random color from 3 to ncolors
      } else if (dist > (radius + 1) && dist < ceil(radius * 1.01)) { // Check if edge point
		    if (lightright == 0) {
		      if (col > xcenter) {
			      X(row, col) = 0;//1; // Dark edge = gray
		      } else {
			      X(row, col) = 0;//2; // Light edge = white
		      }
		    } else {
		      if (col < xcenter) {
			      X(row, col) = 0;//1; // Dark edge = gray
		      } else {
			      X(row, col) = 0;//2; // Light edge = white
		      }			
		    }
	    } else { // Check if star point
	      double star = R::runif(0, 1);
		    if (star < starprob && X(row, col) == 0) {
          X(row, col) = 2; // Star = white
		    }
	    }
    }
  }
  // Fill the circle
  arma::mat X_ref = X;
  for (int i = 0; i < iterations; i++) {
    for (int ii = 0; ii < xcircle.size(); ii++) {
      int xpoint = xcircle[ii];
      int ypoint = ycircle[ii];
      if (ypoint > 0 && ypoint < (m - 1) && xpoint > 0 && xpoint < (n - 1)) {
        int level = X_ref(ypoint, xpoint); // Get the current level 
		    int newlevel = level + 1;
		    if (newlevel == (ncolors + colorsused)) {
			    newlevel = 3 + colorsused;
		    }
        //int newlevel = ((level + 1) % (ncolors - 1)) + 3; // New level can be 3 to ncolors
        int higherlevels = 0;
        if (X_ref(ypoint - 1, xpoint) == newlevel)     higherlevels++;
        if (X_ref(ypoint + 1, xpoint) == newlevel)     higherlevels++;
        if (X_ref(ypoint - 1, xpoint - 1) == newlevel) higherlevels++;
        if (X_ref(ypoint, xpoint - 1) == newlevel)     higherlevels++;
        if (X_ref(ypoint + 1, xpoint - 1) == newlevel) higherlevels++;
        if (X_ref(ypoint - 1, xpoint + 1) == newlevel) higherlevels++;
        if (X_ref(ypoint, xpoint + 1) == newlevel)     higherlevels++;
        if (X_ref(ypoint + 1, xpoint + 1) == newlevel) higherlevels++;
        if (higherlevels >= threshold) {
          X(ypoint, xpoint) = newlevel;
        } else {
          X(ypoint, xpoint) = level;
        }
      }
    }
	X_ref = X;
  }
  for (int ii = 0; ii < xcircle.size(); ii++) {
    int xpoint = xcircle[ii];
    int ypoint = ycircle[ii];
	  float xdist = abs(xcenter - xpoint);
	  if (lightright == 0) {
		  if (xpoint < xcenter) {
			  X(ypoint, xpoint) = X(ypoint, xpoint) - (fade * (xdist / radius));
		  } else {
			  X(ypoint, xpoint) = X(ypoint, xpoint) + (fade * (xdist / radius));
		  }
	  } else if (lightright == 1) {
		  if (xpoint > xcenter) {
			  X(ypoint, xpoint) = X(ypoint, xpoint) - (fade * (xdist / radius));
		  } else {
			  X(ypoint, xpoint) = X(ypoint, xpoint) + (fade * (xdist / radius));
		  }
	  }
  }
  return X;
}