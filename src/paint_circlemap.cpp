#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat iterate_circlemap(arma::mat X,
							double kmin,
							double kmax,
							double phimin,
							double phimax,
						    int iterations){
  int m = X.n_rows;
  int n = X.n_cols;
  double K = kmax;
  double phi = phimin;
  for (int iter = 0; iter < iterations; iter++) {
	for (int row = 0; row < m; row++) {
		for (int col = 0; col < n; col++) {
			X(row, col) = X(row, col) + phi + (K / (2 * M_PI)) * sin(2 * M_PI * X(row, col));
			K = K - ((kmax - kmin) / m);
		}
		phi = phi + ((phimax - phimin) / n);
		K = kmax;
	}
  }
  return X;
};
