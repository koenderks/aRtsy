block_painting <- function(width, height, p.newcol, palette, seed){
  
  set.seed(seed)
  
  internalPalette <- c("#fafafa", palette)
  
  canvasColor <- 0
  
  # Initialize the painting
  df <- matrix(sample(x = canvasColor, size = width * height, replace = TRUE), nrow = height, ncol = width)
  
  # Loop over each block in the painting
  for(col in 1:ncol(df)){
    
    for(row in 1:nrow(df)){
      
      if(col == 1 | row == 1 | col == ncol(df) | row == nrow(df)){
        # If the block is an edge block, it receives the canvas color
        df[row, col] <- canvasColor
        
      } else {
        
        # Adjust for edges
        xright <- ifelse(col + 1 > ncol(df), yes = col - 1, no = col + 1)
        xleft <- ifelse(col - 1 < 1, yes = col + 1, no = col - 1)
        ytop <- ifelse(row - 1 < 1, yes = row + 1, no = row - 1)
        ybottom <- ifelse(row + 1 > nrow(df), yes = row - 1, no = row + 1)
        
        # If the block is no edge block, the 9 surrounding blocks are checked if they have a color
        block.around.it.has.color <- df[ytop, xleft] > 0 | df[row, xleft] > 0 | df[ybottom, xleft] > 0 | df[ytop, col] > 0 | df[ybottom, col] > 0 | df[ytop, xright] > 0 | df[row, xright] > 0 | df[ybottom, xright] > 0
        
        if(sample(c(TRUE, FALSE), size = 1, prob = c(p.newcol, 1 - p.newcol)))
          block.around.it.has.color <- FALSE
        
        if(block.around.it.has.color){
          
          # If a block around the current block is colored, the current block takes over a color from its surroundings  
          blocksAround <- c(df[ytop, xleft], df[row, xleft], df[ybottom, xleft], df[ytop, col], df[ybottom, col], df[ytop, xright], df[row, xright], df[ybottom, xright])
          colorsOfBlockAroundIt <- subset(blocksAround, blocksAround > 0)
          selectedColor <- sample(colorsOfBlockAroundIt, size = 1)
          df[row, col] <- selectedColor
          
        } else {
          # If the current block gets a new color, a random color from the palette is sampled
          df[row, col] <- sample(seq_along(palette), size = 1)
        }
      }
    }
    if(col%%100 == 0)
      print(paste0("Filling column ", col))
  }
  
  for(y in 1:nrow(df)){
    df[y, 1] <- df[y, 2]
  }
  
  for(x in 1:ncol(df)){
    df[nrow(df), x] <- df[nrow(df) - 1, x]
  }
  
  # Reshape the data to plotting format
  df <- reshape2::melt(df)
  colnames(df) <- c("y","x","z") # to name columns
  
  df <- subset(df, df$x > 1 & df$x < max(df$x))
  df <- subset(df, df$y > 1 & df$y < max(df$y))
  
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
          plot.margin = unit(rep(0, 4), "cm"), 
          strip.background = element_blank(), 
          strip.text = element_blank())
  
  return(painting)
}