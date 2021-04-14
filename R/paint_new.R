paint_new <- function(width = 500, height = 500, p.newcol = 0.001, palette, seed = 120495){
  
  set.seed(seed)
  
  internalPalette <- c("#fafafa", palette)
  
  canvasColor <- 0
  
  # Initialize the painting
  df <- matrix(sample(x = canvasColor, size = width * height, replace = TRUE), nrow = height, ncol = width)
  
  filled <- 0
  
  row <- sample(1:height, size = 1)
  col <- sample(1:width, size = 1)
  allfilled <- FALSE
  
  # Pick a random starting point on the canvas
  while (!allfilled){
    
    # Check if all the blocks have a color and end
    allfilled <- all(df > 0)
    if(allfilled)
      next
    
    if(col <= 1 | row <= 1 | col >= ncol(df) | row >= nrow(df) | df[row, col] > 0){
      
      # If the trails hits an edge it moves to a random empty block (the block is to be revisited again)
      zeros <- which(df == 0, arr.ind=TRUE)
      i <- sample(1:nrow(zeros), size = 1)
      row <- as.numeric(zeros[i, 1])
      col <- as.numeric(zeros[i, 2])
      newcol <- sample(c(TRUE, FALSE), size = 1, prob = c(p.newcol, 1 - p.newcol))
      if(newcol)
        df[row, col] <- sample(2:length(palette), size = 1)
      
    } else {
      
      # Determine if there is something on the canvas adjacent to the block
      xright <- ifelse(col + 1 > ncol(df), yes = col - 1, no = col + 1)
      xleft <- ifelse(col - 1 < 1, yes = col + 1, no = col - 1)
      ytop <- ifelse(row - 1 < 1, yes = row + 1, no = row - 1)
      ybottom <- ifelse(row + 1 > nrow(df), yes = row - 1, no = row + 1)
      
      # If there is nothing on the canvas at all, draw a random colored block
      if(filled == 0){
        
        df[row, col] <- sample(2:length(palette), size = 1)
        
      } else {
        
        # Any new block will put up a color of an adjacent block if available, otherwise it will generate a new color
        blocksAround <- c(df[ytop, xleft], df[row, xleft], df[ybottom, xleft], df[ytop, col], df[ybottom, col], df[ytop, xright], df[row, xright], df[ybottom, xright])
        if(all(blocksAround == 0)){
          newcol <- sample(c(TRUE, FALSE), size = 1, prob = c(p.newcol, 1 - p.newcol))
          if(newcol)
            df[row, col] <- sample(2:length(palette), size = 1)
        } else {
          colorsOfBlockAroundIt <- subset(blocksAround, blocksAround > 0)
          selectedColor <- sample(colorsOfBlockAroundIt, size = 1)
          df[row, col] <- selectedColor 
        }
        
      }
      
      # The new block will then detect by which sides it is surrounded by other colored blocks
      leftprob <- ifelse(df[xleft, col] > 0, yes = 0, no = 1)
      rightprob <- ifelse(df[xleft, col] > 0, yes = 0, no = 1)
      upprob <- ifelse(df[row, ytop] > 0, yes = 0, no = 1)
      downprob <- ifelse(df[row, ybottom] > 0, yes = 0, no = 1)
      
      if (all(c(leftprob, rightprob, upprob, downprob) == 0)){
        # If the block is completely surrounded by colored blocks it will get the color of an adjacent block
        blocksAround <- c(df[ytop, xleft], df[row, xleft], df[ybottom, xleft], df[ytop, col], df[ybottom, col], df[ytop, xright], df[row, xright], df[ybottom, xright])
        if(all(blocksAround == 0)){
          df[row, col] <- sample(2:length(palette), size = 1)
        } else {
          colorsOfBlockAroundIt <- subset(blocksAround, blocksAround > 0)
          selectedColor <- sample(colorsOfBlockAroundIt, size = 1)
          df[row, col] <- selectedColor 
        }
        
        # Next, a fresh starting block will be selected
        zeros <- which(df == 0, arr.ind=TRUE)
        i <- sample(1:nrow(zeros), size = 1)
        row <- as.numeric(zeros[i, 1])
        col <- as.numeric(zeros[i, 2])
        
      } else {
        # If the block is not completely surrounded by colored blocks, move the next block up/down or left/right
        dir <- sample(0:1, size = 1, prob = c(leftprob + rightprob, upprob + downprob))
        if(dir == 0){
          direction <- sample(c("left", "right"), size = 1, prob = c(leftprob, rightprob))
          row <- switch(direction, "left" = row - 1, "right" = row + 1) 
        } else {
          direction <- sample(c("up", "down"), size = 1, prob = c(upprob, downprob))
          col <- switch(direction, "up" = col - 1, "down" = col + 1)  
        } 
      }
    }
    
    filled <- length(which(df > 0))
    if(filled%%1000 == 0)
      print(paste0(filled, " of ", width * height, " blocks filled"))
  }
  
  print("Coloring border blocks")
  
  # Color blocks on the border of the frame
  roworder <- 1:nrow(df)
  for(row in roworder){
    df[row, roworder[1]] <- df[row, roworder[2]]
    df[row, roworder[length(roworder)]] <- df[row, roworder[length(roworder)-1]]
  }
  
  colorder <- 1:ncol(df)
  for(col in colorder){
    df[colorder[length(colorder)], col] <- df[colorder[length(colorder) - 1], col]
    df[colorder[1], col] <- df[colorder[2], col]
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
