block_painting <- function(){
  
  width  <- 1000
  height <- 1000
  
  df <- matrix(sample(x = 1, size = width * height, replace = TRUE), nrow = height, ncol = width)
  
  palette <- c("#fafafa", randomColor(count = 10))
  
  initialColor <- 1
  color.given <- FALSE
  
  for(x in 1:ncol(df)){
    for(y in 1:nrow(df)){
      # Determine if blocks around the current block are colored
      edge <- x == 1 || y == 1 || x == ncol(df) || y == nrow(df)
      if(edge){
        block.around.it.has.color <- FALSE
      } else {
        block.around.it.has.color <- df[x - 1, y - 1] > 1 || df[x - 1, y] > 1 || df[x - 1, y + 1] > 1 || df[x, y - 1] > 1 || df[x, y + 1] > 1 || df[x + 1, y - 1] > 1 || df[x + 1, y] > 1 || df[x + 1, y + 1] > 1
      }
      if(block.around.it.has.color){
        colorOfBlockAroundIt <- c(df[x - 1, y - 1], df[x - 1, y], df[x - 1, y + 1], df[x, y - 1], df[x, y + 1], df[x + 1, y - 1], df[x + 1, y], df[x + 1, y + 1])
        colorOfBlockAroundIt <- subset(colorOfBlockAroundIt, colorOfBlockAroundIt > 1)
        colorOfBlockAroundIt <- sample(colorOfBlockAroundIt, size = 1)
        df[x, y] <- colorOfBlockAroundIt
      } else {
        # Block gets a new color with probability
        get.new.color <- sample(c(FALSE, TRUE), size = 1, prob = c(0.1, 0.9))
        if(get.new.color){
          df[x, y] <- sample(2:length(palette), size = 1)
        } else {
          df[x, y] <- initialColor
        }
      }
    }
    print(paste0("Iteration ", x))
  }
  
  df <- reshape2::melt(df)
  colnames(df) <- c("x","y","z") # to name columns
  
  painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y, fill = z)) + 
    geom_raster(interpolate = TRUE) + 
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