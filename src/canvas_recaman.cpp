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