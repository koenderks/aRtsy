#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
Rcpp::IntegerVector iterate_recaman(int n,
                                    int start,
                                    int increment) {
  int inc = 0;
  Rcpp::IntegerVector x = {start};
  Rcpp::IntegerVector xlist = {start};
  for (int i = 1; i < n; i++) {
    Rcpp::checkUserInterrupt();
    inc = inc + increment;
    int newx = x[i - 1] - inc;
    bool contains = std::find(xlist.begin(), xlist.end(), newx) != xlist.end();
    if (contains || newx <= 0) {
      newx = x[i - 1] + inc;
    }
    x.push_back(newx);
    xlist.push_back(newx);
  }
  return x;
}