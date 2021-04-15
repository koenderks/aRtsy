# Packages required for painting

library(ggplot2)
library(dplyr)
library(tweenr)
library(randomcoloR)
library(reshape2)
library(RcppArmadillo)

# Load the painting functions
source("R/paint_shape.R")
source("R/paint_strokes.R")
source("R/paint_turmite.R")

# Name of the painting

paintingPNGname <- paste0('png/', Sys.Date(), ".png")

# Painting seed dependent on the date

seed <- as.numeric(Sys.Date())
set.seed(seed)

paintingType <- sample(1:3, size = 1)

paintingType <- 3

if (paintingType == 1){
  
  bgcolor <- sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)
  if(bgcolor %in% c("#fafafa",  "#cc7722", "#a9d2c3", "#fc7c7c")){
    color <- sample(c("black", randomcoloR::randomColor(1, luminosity = "dark")), size = 1)
  } else {
    color <- randomcoloR::randomColor(1, luminosity = "light")
  }
  
  painting <- paint_shape(color = color, 
                          background = bgcolor, 
                          seed = seed)
  
  ggplot2::ggsave(painting, filename = paintingPNGname, width = 7, height = 7, dpi = 300)
  
} else if (paintingType == 2){
  
  painting <- paint_strokes(width = 1500, 
                            height = 1500, 
                            p.newcol = runif(1, 0.0001, 0.01), 
                            palette = randomcoloR::randomColor(count = sample(5:15, size = 1)), 
                            seed = seed,
                            neighbors = sample(1:4, size = 1),
                            iter = sample(1:3, size = 1))
  
  ggplot2::ggsave(painting, filename = paintingPNGname, width = 7, height = 7, dpi = 300)
  
} else if (paintingType == 3){
  
  painting <- paint_turmite(width = 4500, 
                            height = 1500, 
                            seed = seed, 
                            iters = 1e8,
                            p.swap = runif(1, 0.2, 0.5),
                            color = "#fafafa",
                            background = "#1E90FF")
  
  ggplot2::ggsave(painting, filename = paintingPNGname, width = 7, height = 7, dpi = 300)
  
}
