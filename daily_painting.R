# Packages required for painting

library(ggplot2)
library(dplyr)
library(tweenr)
library(randomcoloR)

# Functions required for painting

source("generate_city_painting.R")
source("generate_function_painting.R")
source("generate_tree_painting.R")

# Name of the painting

name <- paste0('paintings/', Sys.Date(), ".png")

# Painting seed dependent on the date

set.seed(as.numeric(Sys.Date()))

# paintingType <- sample(1:3, 1, prob = c(0.4, 0.4, 0.2))
# 
# if (paintingType == 1) {
#   
#   # Credits to https://github.com/marcusvolz/mathart
#   
#   print(paste0("Creating a city painting on ", Sys.Date()))
#   
#   width <- sample(c(10000, 20000, 50000))
#   height <- width
#   
#   painting <- generate_city_painting(n = width, 
#                                      r = 75, 
#                                      delta = 2 * pi / 180, p_branch = runif(1, 0.1, 0.2),
#                                      initial_pts = sample(1:4, size = 1),
#                                      nframes = 500)
#   
#   ggsave(name, painting, width = width/1000, height = height/1000, units = "cm", dpi = 300)
#   
# } else if(paintingType == 2) {
  
  print(paste0("Creating a function painting on ", Sys.Date()))
  
  my_formula <- list(
    x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:5), 1) - sin(y_i^sample(c(0.5, 1, 2, 3, 4, 5), 1)) * runif(1, -100, 100)),
    y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:5), 1) - cos(x_i^sample(c(0.5, 1, 2, 3, 4, 5), 1)) * y_i^sample(1:5, 1) + runif(1, -100, 100))
  )
  
  bgcolor <- sample(c("#fafafa", "#1a3657", "#343434"), 1)
  if(bgcolor == "#fafafa"){
    color <- randomcoloR::randomColor(1, luminosity = "dark")
  } else {
    color <- randomcoloR::randomColor(1, luminosity = "light")
  }
  
  painting <- generate_function_painting(formula = my_formula, color = color, bgcolor = bgcolor)
  
  ggplot2::ggsave(painting, filename = name, scale = 1, dpi = 300)
  
# } else if (paintingType == 3) {
#   
#   print(paste0("Creating an expanding tree painting on ", Sys.Date()))
#   
#   # Credits to https://github.com/marcusvolz/mathart
#   
#   painting <- generate_tree_painting(n = 50000, dims = 5000, delta = 2.5)
#   
#   ggplot2::ggsave(painting, filename = name, scale = 1, dpi = 300)
#   
# }