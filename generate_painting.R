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

set.seed(as.numeric(Sys.Date()))

paintingType <- 2

if(paintingType == 1){
  
  bgcolor <- sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)
  if(bgcolor %in% c("#fafafa",  "#cc7722", "#a9d2c3", "#fc7c7c")){
    color <- sample(c("black", randomcoloR::randomColor(1, luminosity = "dark")), size = 1)
  } else {
    color <- randomcoloR::randomColor(1, luminosity = "light")
  }
  
  painting <- shape_painting(color = color, background = bgcolor)
  
} else if (paintingType == 2){
  
  palette <- randomColor(count = 10)
  palette <- c("#fafafa", palette)
  
  painting <- block_painting(width = 1500, height = 1500, p.takecol = 0.5, p.newcol = 0.5, palette = palette)
  
}

ggplot2::ggsave(painting, filename = paintingPNGname, scale = 1, dpi = 300)
ggplot2::ggsave(painting, filename = paintingSVGname, scale = 1, dpi = 300)
