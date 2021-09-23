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
					   int height,
					   double hole) {
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
	  // Perform one round of deformation on each line
	  for (int j = 0; j < isize; j++) {
		  Rcpp::checkUserInterrupt();
		  // For each line A -> C in the polygon, find the midpoint, B.
		  double bx = (x[indexes[j]] + x[indexes[j] + 1]) / 2;
		  double by = (y[indexes[j]] + y[indexes[j] + 1]) / 2;
		  double cvar = (s[indexes[j]] + s[indexes[j] + 1]) / 2;
		  // From a Gaussian distribution centered on B, pick a new point B'.
		  double bstarx = R::rnorm(bx, cvar);
		  double bstary = R::rnorm(by, cvar);
		  double bs = cvar * 0.5;
		  // Insert new point into the data
		  x.insert(indexes[j] + 1, bstarx);
		  y.insert(indexes[j] + 1, bstary);
		  s.insert(indexes[j] + 1, bs);
	  }
  }
  // Insert a hole with 8 corners inside the polygon
  if (hole == 1) {
	for (int k = 0; k < 50; k++) {
		int ind = floor(R::runif(1, x.length()));
		int ncorns = 10;
		double r = 1;
		int xstart = R::rnorm(min(x) + (max(x) - min(x)) / 2, (max(x) - min(x)) / 2 / 3);
		int ystart = R::rnorm(min(y) + (max(y) - min(y)) / 2, (max(y) - min(y)) / 2 / 3);
		for (int i = 1; i < ncorns; i++) {
			double px = xstart + r * cos(2 * 3.14 * i / ncorns);
			double py = ystart + r * sin(2 * 3.14 * i / ncorns);
			x.insert(ind + i, px);
			y.insert(ind + i, py);
			s.insert(ind + i, 0);
		}
		x.insert(ind + ncorns, xstart + r * cos(2 * 3.14 * 1 / ncorns));
		y.insert(ind + ncorns, ystart + r * sin(2 * 3.14 * 1 / ncorns));
		s.insert(ind + ncorns, 0);
		x.insert(ind + ncorns + 1, x[ind]);
		y.insert(ind + ncorns + 1, y[ind]);
		s.insert(ind + ncorns + 1, 0);
	}
  }
  // Fit to canvas
  for (int i = 0; i < x.length(); i++) {
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