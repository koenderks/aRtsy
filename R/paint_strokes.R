paint_strokes <- function(width = 500, height = 500, p.newcol = 0.01, palette, seed = 120495, xascending = TRUE, yascending = TRUE){
  
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
      
      if(col == 1 | row == 1 | col == ncol(df) | row == nrow(df)){
        # If the block is an edge block, it receives the temporary canvas color
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
          
          # If a block around the current block is colored, the current block takes over a random color from its surroundings  
          blocksAround <- c(df[ytop, xleft], df[row, xleft], df[ybottom, xleft], df[ytop, col], df[ybottom, col], df[ytop, xright], df[row, xright], df[ybottom, xright])
          colorsOfBlockAroundIt <- subset(blocksAround, blocksAround > 0)
          selectedColor <- sample(colorsOfBlockAroundIt, size = 1)
          df[row, col] <- selectedColor
          
        } else {
          
          # If the current block does not take a color from the surroundings, a new color from the palette is sampled
          df[row, col] <- sample(seq_along(palette), size = 1)
        }
      }
    }
    iter <- iter + 1
    if(iter%%100 == 0)
      print(paste0("Filling column ", iter))
  }
  
  print("Coloring border blocks")
  
  # Color blocks on the border of the frame
  for(row in roworder){
    df[row, roworder[1]] <- df[row, roworder[2]]
  }
  
  for(col in colorder){
    df[colorder[length(colorder)], col] <- df[colorder[length(colorder) - 1], col]
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
