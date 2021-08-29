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