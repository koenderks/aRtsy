block_painting <- function(width, height, p.newcol, palette){
  
  canvasColor <- 0
  iter <- 1
  
  # Initialize the painting
  df <- matrix(sample(x = canvasColor, size = width * height, replace = TRUE), nrow = height, ncol = width)
  
  # Loop over each block in the painting
  for(x in 1:ncol(df)){
    
    for(y in 1:nrow(df)){
      
      # Determine if the current block is an edge block
      edge <- x == 1 || y == 1 || x == ncol(df) || y == nrow(df)

      if(edge){
        # If the block is an edge block, it should take over the color from any adjacent block
        block.around.it.has.color <- TRUE
      } else {
        # If the block is no edge block, the 9 surrounding blocks are checked if they have a color
        block.around.it.has.color <- df[x - 1, y - 1] > 1 || df[x - 1, y] > 1 || df[x - 1, y + 1] > 1 || df[x, y - 1] > 1 || df[x, y + 1] > 1 || df[x + 1, y - 1] > 1 || df[x + 1, y] > 1 || df[x + 1, y + 1] > 1
      }
      
      if(block.around.it.has.color){
        # If a block around the current block is colored, the current block takes over a color from its surroundings
          colorOfBlockAroundIt <- c(df[x - 1, y - 1], df[x - 1, y], df[x - 1, y + 1], df[x, y - 1], df[x, y + 1], df[x + 1, y - 1], df[x + 1, y], df[x + 1, y + 1])
          colorOfBlockAroundIt <- subset(colorOfBlockAroundIt, colorOfBlockAroundIt > 1)
          colorOfBlockAroundIt <- sample(colorOfBlockAroundIt, size = 1)
          df[x, y] <- colorOfBlockAroundIt 
      } else {
        # If no blocks around the current block are colored, the current block gets a new color with probability p.newcol
        get.new.color <- sample(c(FALSE, TRUE), size = 1, prob = c(1 - p.newcol, p.newcol))
        if(get.new.color){
          # If the current block gets a new color, a random color from the palette is sampled
          df[x, y] <- sample(1:length(palette), size = 1)
        } else {
          # If the current block does not get a new color, the original color is retained
          df[x, y] <- canvasColor
        }
      }
    }
    iter <- iter + 1
    if(iter%%100 == 0)
      print(paste0("Iteration ", iter))
  }
  
  # Reshape the data to plotting format
  df <- reshape2::melt(df)
  colnames(df) <- c("x","y","z") # to name columns
  
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
          plot.margin = unit(rep(0, 4), "cm"), 
          strip.background = element_blank(), 
          strip.text = element_blank())
  
  return(painting)
}