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
Rcpp::IntegerVector get_closest_node(Rcpp::NumericVector attractor_x,
                                     Rcpp::NumericVector attractor_y,
                                     Rcpp::NumericVector nodes_x,
                                     Rcpp::NumericVector nodes_y,
                                     double attraction_distance) {
  int n_attractors = attractor_x.length();
  int n_nodes = nodes_x.length();
  Rcpp::IntegerVector X;
  for (int i = 0; i < n_attractors; i++) {
    int min_dist_node = 0;
    double min_dist = attraction_distance;
    for (int j = 0; j < n_nodes; j++) {
      Rcpp::checkUserInterrupt();
      double dist = fabs(sqrt(pow(attractor_x[i] - nodes_x[j], 2) + pow(attractor_y[i] - nodes_y[j], 2)));
      if (dist < min_dist) {
        min_dist = dist;
        min_dist_node = j + 1;
      }
    }
    X.insert(i, min_dist_node);
  }
  return X;
}

// [[Rcpp::export]]
Rcpp::DataFrame kill_attractors(Rcpp::NumericVector attractor_x,
                                Rcpp::NumericVector attractor_y,
                                Rcpp::NumericVector nodes_x,
                                Rcpp::NumericVector nodes_y,
                                double kill_distance) {
  int n_attractors = attractor_x.length();
  int n_nodes = nodes_x.length();
  Rcpp::IntegerVector kills;
  Rcpp::NumericVector new_attractor_x;
  Rcpp::NumericVector new_attractor_y;
  for (int i = 0; i < n_attractors; i++) {
    int c = 0;
    for (int j = 0; j < n_nodes; j++) {
      Rcpp::checkUserInterrupt();
      double dist = fabs(sqrt(pow(attractor_x[i] - nodes_x[j], 2) + pow(attractor_y[i] - nodes_y[j], 2)));
      if (dist <= kill_distance) {
        c++;
      }
    }
    if (c == 0) {
      new_attractor_x.push_back(attractor_x[i]);
      new_attractor_y.push_back(attractor_y[i]);
    }
  }
  Rcpp::DataFrame X = Rcpp::DataFrame::create(Rcpp::Named("x") = new_attractor_x,
                                              Rcpp::Named("y") = new_attractor_y);
  return X;
}

// [[Rcpp::export]]
Rcpp::DataFrame draw_circle(double center_x,
                            double center_y,
                            double diameter,
                            int n) {
  double r = diameter / 2;
  Rcpp::DoubleVector x;
  Rcpp::DoubleVector y;
  double t = 0;
  double xnew;
  double ynew;
  for (int i = 0; i < n; i++) {
    Rcpp::checkUserInterrupt();
    xnew = center_x + r * cos(t);
    ynew = center_y + r * sin(t);
    x.push_back(xnew);
    y.push_back(ynew);
    t = t + (2 * M_PI) / n;
  }
  Rcpp::DataFrame circle = Rcpp::DataFrame::create(Rcpp::Named("x") = x,
                                                   Rcpp::Named("y") = y);
  return circle;
}

Rcpp::IntegerVector my_which_max(Rcpp::LogicalVector x) {
  double current_max = x[0];
  int n = x.size();
  std::vector< int > y;
  y.push_back(0);
  int i;
  for(i = 1; i < n; ++i) {
    Rcpp::checkUserInterrupt();
    double currentx = x[i];
    if(currentx > current_max) {
      y.clear();
      current_max = currentx;
      y.push_back(i);
    } else if (currentx == current_max) {
      y.push_back(i);
    }
  }
  Rcpp::IntegerVector X(y.begin(), y.end());
  return X;
}

// [[Rcpp::export]]
Rcpp::DataFrame get_directions(Rcpp::NumericVector attractor_x,
                               Rcpp::NumericVector attractor_y,
                               Rcpp::NumericVector nodes_x,
                               Rcpp::NumericVector nodes_y,
                               Rcpp::IntegerVector closest_nodes) {
  Rcpp::NumericVector directionx;
  Rcpp::NumericVector directiony;
  Rcpp::LogicalVector indexes;
  for (int i = 0; i < nodes_x.length(); i++) {
    Rcpp::checkUserInterrupt();
    indexes = closest_nodes == (i + 1);
    Rcpp::IntegerVector indexes2 = my_which_max(indexes);
    Rcpp::NumericVector nodex = attractor_x[indexes];
    double dirx = mean(nodex - nodes_x[i]);
    directionx.push_back(dirx);
    Rcpp::NumericVector nodey = attractor_y[indexes];
    double diry = mean(nodey - nodes_y[i]);
    directiony.push_back(diry);
  }
  Rcpp::DataFrame X = Rcpp::DataFrame::create(Rcpp::Named("xend") = directionx,
                                              Rcpp::Named("yend") = directiony);
  return X;
}
