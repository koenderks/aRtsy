#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
std::vector<int> get_collatz_sequence(int x) {
  std::vector<int> sequence;
  sequence.push_back(1);
  while (x > 1) {
    if (x%2==1) {
      x = (3 * x) + 1;
      sequence.push_back(1);
    } else {
      x = x / 2;
      sequence.push_back(0);
    }
  }
  return sequence;
}

// [[Rcpp::export]]
arma::mat draw_collatz(arma::mat empty,
                       std::vector<int> series,
                       double even,
                       double odd) {
  int s = series.size();
  double angle = 3.14/2;
  for (int i = 1; i < s; i++) {
    empty(i, 0)  = cos(angle) + empty(i - 1, 0);
    empty(i, 1) = sin(angle) + empty(i - 1, 1);
    if(series[i] == 0) {
      angle = angle - even;
    } else {
      angle = angle + odd;
    }
  }
  return empty;
}