#include <RcppArmadillo.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <cstdlib>
#include <iterator>
#include <math.h>

using namespace std;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat iterate_ant(arma::mat X,
                      int iters,
                      int row,
                      int col){
  int m = X.n_rows;
  int n = X.n_cols;
  int i = 0;
  int direction = 0; // 1 = left, 2 = up, 3 = right, 4 = down
  while(i < iters){
    if(X(row,col) == 0){ // White square
	  // Turn 90 degrees clockwise
	  direction = direction + 1;
	  if(direction == 5)
	   direction = 1;
      // Color the square
	  X(row,col) = 1;
	} else { // Black square
	  // Turn 90 degrees counter-clockwise
	  direction = direction - 1;
	  if(direction == 0){
	   direction = 4;
	  }
	  // Color the square
	  X(row,col) = 0;
	}
	// Move the ant
	if(direction == 1 && row >= 1){
	row--; 
	} else if(direction == 2 && col >= 1){
	col--;
	} else if(direction == 3 && row < (m - 1)){
	row++;
	} else if(direction == 4 && col < (n - 1)) {
	col++;
	} 
    i++;
  }
  return X;
};