paint_turmite <- function(width = 1000, height = 1000, seed = 120495, iters = 1e6, p = 0.5){
  
  Rcpp::sourceCpp('cpp/paint_turmite.cpp')
  
  set.seed(seed)
  
  palette <- c("#fafafa", "black")
  
  canvasColor <- 0
  
  # Initialize the painting
  df <- iterate_turmite(X = matrix(0, nrow = height, ncol = width), iters = iters, col = ceiling(width / 2), row = ceiling(height / 2), p = p)  
  
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
