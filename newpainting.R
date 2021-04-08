# Packages

library(ggplot2)
library(mathart)
library(dplyr)
library(tweenr)
library(randomcoloR)

# Functions

source("generate_city.R")
source("generate_function.R")
source("generate_tree.R")

# Name

name <- paste0('paintings/', Sys.Date(), ".png")

# Seed

set.seed(as.numeric(Sys.Date()))  # Painting seed

if (as.numeric(Sys.Date())%%2 == 0) { # Odd days we make a city map
  
  # Credits to https://github.com/marcusvolz/mathart
  
  print(paste0("Creating a city map for ", Sys.Date()))
  
  width <- sample(c(10000, 20000, 50000))
  height <- width
  
  painting <- generate_city(n = width, 
                            r = 75, 
                            delta = 2 * pi / 180, p_branch = runif(1, 0.1, 0.2),
                            initial_pts = sample(1:4, size = 1),
                            nframes = 500)
  
  ggsave(name, painting, width = width/1000, height = height/1000, units = "cm", dpi = 300)
  
} else { # Even days
  
  print(paste0("Creating a non-city map for ", Sys.Date()))
  
  my_formula <- list(
    x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:5), 1) - sin(y_i^sample(c(0.5, 1, 2, 3, 4, 5), 1)) * runif(1, -100, 100)),
    y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:5), 1) - cos(x_i^sample(c(0.5, 1, 2, 3, 4, 5), 1)) * y_i^sample(1:5, 1) + runif(1, -100, 100))
  )
  
  color <- randomcoloR::randomColor(1, luminosity = "dark")
  
  painting <- generate_function(formula = my_formula)
  
  ggplot2::ggsave(painting, filename = name, scale = 1, dpi = 300)
  
}