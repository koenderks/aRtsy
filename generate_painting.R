# Packages required for painting

library(ggplot2)
library(dplyr)
library(tweenr)
library(randomcoloR)
library(svglite)
library(reshape2)

# Name of the painting

paintingPNGname <- paste0('png/', Sys.Date(), ".png")
paintingSVGname <- paste0('svg/', Sys.Date(), ".svg")

# Painting seed dependent on the date

set.seed(as.numeric(Sys.Date()))

paintingType <- 2

if(paintingType == 1){

painting_formulas <- list()

painting_formulas[[1]] <- list( 
  x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1)) * runif(1, -100, 100)),
  y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(1:6, 1) + runif(1, -100, 100))
)

painting_formulas[[2]] <- list(
  x = quote(sample(1:10, 1) * (x_i/sample(c(0.5, 1:6), 1)) * runif(1, -100, 100) * (sin(y_i) - asinh(x_i))),
  y = quote(sample(1:10, 1) * x_i - tanh(y_i) + (runif(1, -100, 100)))
)

painting_formula <- painting_formulas[[sample(1:length(painting_formulas), 1)]]

bgcolor <- sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)
if(bgcolor %in% c("#fafafa",  "#cc7722", "#a9d2c3", "#fc7c7c")){
  color <- sample(c("black", randomcoloR::randomColor(1, luminosity = "dark")), size = 1)
} else {
  color <- randomcoloR::randomColor(1, luminosity = "light")
}

df <- seq(from = -pi, to = pi, by = 0.01) %>% expand.grid(x_i = ., y_i = .) %>% dplyr::mutate(!!!painting_formula)

painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y)) + 
  ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20, color = color) + 
  ggplot2::theme_void() + 
  ggplot2::coord_fixed() + 
  ggplot2::coord_polar() + 
  theme(axis.title = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.line = element_blank(), 
        legend.position = "none", 
        panel.background = element_rect(fill = bgcolor, colour = bgcolor), 
        panel.border = element_blank(), 
        panel.grid = element_blank(), 
        plot.background = element_rect(fill = bgcolor, colour = bgcolor), 
        plot.margin = unit(rep(0, 4), "cm"), 
        strip.background = element_blank(), 
        strip.text = element_blank())

} else if (paintingType == 2){
  
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
          panel.background = element_rect(fill = bgcolor, colour = bgcolor), 
          panel.border = element_blank(), 
          panel.grid = element_blank(), 
          plot.background = element_rect(fill = bgcolor, colour = bgcolor), 
          plot.margin = unit(rep(0, 4), "cm"), 
          strip.background = element_blank(), 
          strip.text = element_blank())
  
}

ggplot2::ggsave(painting, filename = paintingPNGname, scale = 1, dpi = 300)
ggplot2::ggsave(painting, filename = paintingSVGname, scale = 1, dpi = 300)
