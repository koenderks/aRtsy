convolution_indexes <- function(r, n){
  tidytable::crossing.(x = -r:r, y = -r:r) %>% 
    mutate(M = ((x != 0) | (y != 0)) * 1 ,
           N = (abs(x) + abs(y) <= r) * M,
           Mr = ((abs(x) == r) | (abs(y) == r)) * M,
           Nr = (abs(x) + abs(y) == r) * M,
           Cr = ((x == 0) | (y == 0)) * M,
           S1 = (((x > 0) & (y > 0))|((x < 0) & (y < 0))) * 1,
           Bl = (abs(x) == abs(y)) * M,
           D1 = (abs(x) > abs(y)) * M,
           D2 = ((abs(x) == abs(y)) | abs(x) == r) * M,
           C2 = M - N,
           Z = ((abs(y) == r) | (x == y)) * M,
           t = ((y == r) | (x == 0)) * M,
           U = ((abs(x) == r) | (y == -r)) * M,
           H = (abs(x) == r | y == 0) * M,
           TM = ((abs(x) == abs(y)) | abs(x) == r | abs(y) == r) * M,
           S2 = ((y==0) | ((x == r) & (y > 0)) |((x == -r) & (y < 0))) * M,
           M2 = ((abs(x) == r) | (abs(x) == abs(y) & y > 0)) * M) %>% 
    select(x, y, matches(n)) %>% 
    filter_at(3, all_vars(. > 0)) %>% 
    select(x,y)
}

paint_new <- function(width = 500, height = 500, palette, seed = 120495, range = 5, threshold = 3, max.iter = 10000){
  
  set.seed(seed)
  
  internalPalette <- c("#fafafa", palette)
  
  canvasColor <- 0
  
  # Initialize the painting
  df <- matrix(sample(x = seq_along(palette), size = width * height, replace = TRUE), nrow = height, ncol = width)
  
  col <- ceiling(width / 2)
  row <- ceiling(height / 2)
  iter <- 0
  
  neighbourhoords <- convolution_indexes(range, "M")
  
  while (iter < max.iter){
    
    for (row in 1:nrow(df)) {
      
      for (col in 1:ncol(df)){
        
        # Select the current block
        currentBlock <- df[row, col]
        
        # Count the state of each block in the neighborhood of the current block
        nnRows <- row + as.numeric(neighbourhoords$x)
        nnCols <- row + as.numeric(neighbourhoords$y)
        nnRows <- ifelse(nnRows < 1, yes = nrow(df) + (nnRows - 1), no = nnRows)
        nnRows <- ifelse(nnRows > nrow(df), yes = nnRows - nrow(df), no = nnRows)
        nnCols <- ifelse(nnCols < 1, yes = ncol(df) + (nnCols - 1), no = nnCols)
        nnCols <- ifelse(nnCols > ncol(df), yes = nnCols - ncol(df), no = nnCols)
        
        blocksAround <- df[nnRows, nnCols]
        
        # Calculate how many of these blocks have a state exactly one above the current block
        howmany <- length(which(blocksAround == currentBlock + 1))
        
        # If there are more than threshold blocks with that state, increase the state of the current block
        if(howmany > threshold){
          df[row, col] <- df[row, col] + 1%%length(palette)
        }
      }
      
      if(row%%100 == 0)
        print(paste0("Inside-iter ", row))
    }
    
    iter <- iter + 1
    if(iter%%1 == 0)
      print(paste0("Iter ", iter))
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
