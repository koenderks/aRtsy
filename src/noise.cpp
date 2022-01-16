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
std::vector<double> c_noise_knn(arma::rowvec x,
                                arma::rowvec y,
                                arma::rowvec z,
                                arma::rowvec newx,
                                arma::rowvec newy,
                                int k,
                                int n)
{
  int npred = newx.n_elem;
  std::vector<double> newz;
  for(int i = 0; i < npred; i++) {
	Rcpp::checkUserInterrupt();
    arma::rowvec xdist = x - newx[i]; // For each new point, compute distance to training points in x-plane
    arma::rowvec ydist = y - newy[i]; // For each new point, compute distance to training points in y-plane
    arma::rowvec dist = sqrt((xdist % xdist) + (ydist % ydist)); // Calculate Euclidian distance
    arma::uvec sorted_indexes = arma::sort_index(dist); // Sort distances
    std::vector<double> closest_z;
    for (int l = 0; l < k; l++) {
      int index = sorted_indexes[l];
      closest_z.push_back(z[index]);
    }
    double average = std::accumulate(closest_z.begin(), closest_z.end(), 0.0) / closest_z.size(); // Compute average of nearest neighbors
    newz.push_back(average);
  }
  return newz;
}