paint_turmite <- function(width = 1000, height = 1000, seed = 120495, iters = 1e6, row = 1, col = 1, p.swap = 0.5, color = "#fafafa", background = "black"){
  
  Rcpp::sourceCpp('cpp/paint_turmite.cpp')
  
  set.seed(seed)
  
  palette <- c(background, color)
  
  k <- sample(0:1, size = 1)
  row <- 0
  col <- 0
  if(k == 1)
    col <- sample(0:(width-1), size = 1)
  if(k == 0)
    row <- sample(0:(height-1), size = 1)
  
  df <- iterate_turmite(matrix(0, nrow = height, ncol = width), iters, row, col, p = p.swap)  
  
  # Reshape the data to plotting format
  df <- reshape2::melt(df)
  colnames(df) <- c("y","x","z") # to name columns
  
  painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y, fill = z)) +
    geom_raster(interpolate = TRUE, alpha = 0.9) + 
    coord_equal() +
    scale_fill_gradientn(colours = palette) +
    scale_y_continuous(expand = c(0,0)) + 
    scale_x_continuous(expand = c(0,0)) +
    theme(axis.title = element_blank(), 
          axis.text = element_blank(), 
          axis.ticks = element_blank(), 
          axis.line = element_blank(), 
          legend.position = "none", 
          panel.border = element_blank(), 
          panel.grid = element_blank(), 
          plot.margin = unit(rep(-1.25,4),"lines"), 
          strip.background = element_blank(), 
          strip.text = element_blank())
  
  return(painting)
}
