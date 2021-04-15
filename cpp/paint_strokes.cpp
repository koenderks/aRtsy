#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>

using namespace std;

// [[Rcpp::depends(RcppArmadillo)]]

int get_index(int M, int i)
{
  if (i < 0)
    return(i + 2);
  if(i >= M)
    return(i - 2);
  return i;
}

// [[Rcpp::export]]
arma::mat iterate_strokes(arma::mat X, 
                          Rcpp::DataFrame L, 
                          int s,
                          double p){
  int m = X.n_rows;
  int n = X.n_cols;
  int k = L.nrows();
  
  Rcpp::IntegerVector dx = L["x"];
  Rcpp::IntegerVector dy = L["y"];
  
  for(int x = 0; x < n; x++) { // Loop over the columns of the frame
    for(int y = 0; y < m; y++){ // Loop over the rows of the frame
      
      std::vector<int> colors;
      
      for(int z = 0; z < k; z++){ // Loop over all neighboring blocks of the current block
        int ix  = get_index(n, x + dx[z]); // Select the (adjusted) neighboring x location
        int iy  = get_index(m, y + dy[z]); // Select the (adjusted) neighboring y location
        int X_n = X(ix, iy); // Select the color of the neighboring block
        if(X_n > 0){
          colors.push_back (X_n); // Add the color of this block to the adjacent color vector
        }
      }
      
      double rndDouble = (double)rand() / RAND_MAX; // Check whether the block is subject to a random change
        
      if(colors.size() > 0 && rndDouble > p){ // The current block takes over the color of an adjacent block with probability p
        int randomIndex = rand() % colors.size();
        X(x,y) = colors[randomIndex];
      } else {
        // If the current block does not take a color from the surroundings, a new color selected from the palette
        int randomNumber2;
        randomNumber2 = (rand() % s) + 2;
        X(x,y) = randomNumber2;
      }
    }
  }
  return X;
};
