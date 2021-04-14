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
  
  painting <- shape_painting()
  
} else if (paintingType == 2){
  
 painting <- block_painting(width = 1500, height = 1500, p.newcol = 0.01, palette = randomcoloR::randomColor(count = 20))
  
}

ggplot2::ggsave(painting, filename = paintingPNGname, scale = 1, dpi = 300)
ggplot2::ggsave(painting, filename = paintingSVGname, scale = 1, dpi = 300)
