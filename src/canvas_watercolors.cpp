#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
Rcpp::DataFrame deform(Rcpp::DataFrame canvas,
                       int maxdepth,
                       int width,
					   int height) {
  Rcpp::DoubleVector x = canvas["x"];
  Rcpp::DoubleVector y = canvas["y"];
  Rcpp::DoubleVector s = canvas["s"];
  for (int i = 0; i < maxdepth; i++) {
	  int times = x.length() - 1;
	  Rcpp::IntegerVector indexes (times, 0);
	  int isize = indexes.length();
	  // Create seq(0, length(x) * 2 - 1, by = 2)
	  for (int l = 1; l < isize; l++) {
		indexes[l] = indexes[l - 1] + 2;
	  }
	  // Perform deformation on each of the lines
	  for (int j = 0; j < isize; j++) {
		  Rcpp::checkUserInterrupt();
		  // For each line A -> C in the polygon, find the midpoint, B.
		  double bx = (x[indexes[j]] + x[indexes[j] + 1]) / 2;
		  double by = (y[indexes[j]] + y[indexes[j] + 1]) / 2;
		  // Determine the variance, angle, and length of break
		  double edgevar = (s[indexes[j]] + s[indexes[j] + 1]) / 2;
		  double angle = R::rnorm(0, 2);
		  // Pick a new point B'.
		  double bstarx = bx + edgevar * sin(angle);
		  double bstary = by + edgevar * cos(angle);
		  // Insert new point into the data
		  x.insert(indexes[j] + 1, bstarx);
		  y.insert(indexes[j] + 1, bstary);
		  s.insert(indexes[j] + 1, edgevar * 0.5);
	  }
  }
  // Fit to canvas
  for (int i = 0; i < x.length(); i++) {
	Rcpp::checkUserInterrupt();
	if (x[i] < 0) {
		x[i] = 0;
	} else if (x[i] > width) {
		x[i] = width;
	}
	if (y[i] < 0) {
		y[i] = 0;
	} else if (y[i] > height) {
		y[i] = height;
	}
  }
  Rcpp::DataFrame newdata = Rcpp::DataFrame::create(Rcpp::Named("x") = x, Rcpp::Named("y") = y, Rcpp::Named("s") = s);
  return newdata;
}