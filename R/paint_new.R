paint_new <- function(width = 500, height = 500, palette, seed = 120495, xascending = TRUE, yascending = TRUE){
  
  set.seed(seed)
  
  internalPalette <- c("#fafafa", palette)
  
  canvasColor <- 0
  
  # Initialize the painting
  df <- matrix(sample(x = canvasColor, size = width * height, replace = TRUE), nrow = height, ncol = width)
  
  colorder <- 1:ncol(df)
  if(!yascending)
    colorder <- rev(colorder)
  
  roworder <- 1:nrow(df)
  if(!xascending)
    roworder <- rev(roworder)
  
  iter <- 0
  
  # Loop over each block in the painting
  for(col in colorder){
    
    for(row in roworder){
      
      df[row, col] <- sample(2:length(palette), size = 1)
      
    }
  }
  
  # Reshape the data to plotting format
  df <- reshape2::melt(df)
  colnames(df) <- c("y","x","z") # to name columns
  
  painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y, fill = z)) + 
    geom_raster(interpolate = TRUE, alpha = 0.9) + 
    coord_equal() +
    scale_fill_gradientn(colours = internalPalette) +
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
