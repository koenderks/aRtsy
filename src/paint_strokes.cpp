#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

// [[Rcpp::depends(RcppArmadillo)]]

int neighboring_block(int L, int i)
{
  if (i < 0)
    return (L + i % L) % L;
  if(i >= L)
    return i % L;
  return i;
}

// [[Rcpp::export]]
arma::mat iterate_strokes(arma::mat X, 
                          Rcpp::DataFrame neighbors, 
                          int s,
                          double p){
  int m = X.n_rows;
  int n = X.n_cols;
  int k = neighbors.nrows();
  Rcpp::IntegerVector dx = neighbors["x"];
  Rcpp::IntegerVector dy = neighbors["y"];
  double backwardsprob = R::runif(0, 1);
  if(backwardsprob < 0.5){ // Go forward through the loop
    for(int x = 0; x < n; x++) { // Loop over the columns of the frame
      for(int y = 0; y < m; y++){ // Loop over the rows of the frame    
        std::vector<int> colors;  
        for(int z = 0; z < k; z++){ // Loop over all neighboring blocks of the current block
          int ix  = neighboring_block(n, x + dx[z]); // Select the (adjusted) neighboring x location
          int iy  = neighboring_block(m, y + dy[z]); // Select the (adjusted) neighboring y location
          int color = X(ix, iy); // Select the color of the neighboring block
          if(color > 0){
            colors.push_back (color); // Add the color of this block to the adjacent color vector
          }
        }
        double noTake = R::runif(0, 1); // Check whether the block is subject to a random change
        if(colors.size() > 0 && noTake > p){ // The current block takes over the color of an adjacent block with probability p
          int takeIndex = floor(R::runif(0, colors.size())); // Sample a number between 0 and colors.size()
          X(x,y) = colors[takeIndex];
        } else {
          // If the current block does not take a color from the surroundings, a new color selected from the palette
          int newColor;
          newColor = ceil(R::runif(0, s));
          X(x,y) = newColor;
        }     
      }
    }
  } else { // Go backward through the loop  
    for(int x = 0; x < n; x++) {
      for(int y = m; y --> 0;) {    
        std::vector<int> colors;    
        for(int z = 0; z < k; z++){ // Loop over all neighboring blocks of the current block
          int ix  = neighboring_block(n, x + dx[z]); // Select the (adjusted) neighboring x location
          int iy  = neighboring_block(m, y + dy[z]); // Select the (adjusted) neighboring y location
          int color = X(ix, iy); // Select the color of the neighboring block
          if(color > 0){
            colors.push_back (color); // Add the color of this block to the adjacent color vector
          }
        }    
        double noTake = R::runif(0, 1); // Check whether the block is subject to a random change      
        if(colors.size() > 0 && noTake > p){ // The current block takes over the color of an adjacent block with probability p
          int takeIndex = floor(R::runif(0, colors.size()));
          X(x,y) = colors[takeIndex];
        } else {
          // If the current block does not take a color from the surroundings, a new color selected from the palette
          int newColor;
          newColor = ceil(R::runif(0, s));
          X(x,y) = newColor;
        }     
      }
    }   
  }
  return X;
}