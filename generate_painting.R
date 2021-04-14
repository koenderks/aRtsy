# Packages required for painting

library(ggplot2)
library(dplyr)
library(tweenr)
library(randomcoloR)
library(svglite)
library(reshape2)

# Load the painting functions
source("R/shape_painting.R")
source("R/block_painting.R")

# Name of the painting

paintingPNGname <- paste0('png/', Sys.Date(), ".png")
paintingSVGname <- paste0('svg/', Sys.Date(), ".svg")

# Painting seed dependent on the date

seed <- as.numeric(Sys.Date())
set.seed(seed)

paintingType <- 2

if(paintingType == 1){
  
  bgcolor <- sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)
  if(bgcolor %in% c("#fafafa",  "#cc7722", "#a9d2c3", "#fc7c7c")){
    color <- sample(c("black", randomcoloR::randomColor(1, luminosity = "dark")), size = 1)
  } else {
    color <- randomcoloR::randomColor(1, luminosity = "light")
  }
  
  painting <- shape_painting(color = color, background = bgcolor, seed = seed)
  
} else if (paintingType == 2){
  
  palette <- randomcoloR::randomColor(count = sample(5:10, size = 1))
  
  painting <- block_painting(width = 1500, height = 1500, p.newcol = 0.001, palette = palette, seed = seed)
  
}

ggplot2::ggsave(painting, filename = paintingPNGname, scale = 1, dpi = 300)
ggplot2::ggsave(painting, filename = paintingSVGname, scale = 1, dpi = 300)
