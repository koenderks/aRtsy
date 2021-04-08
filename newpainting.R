# Load required packages

library(ggplot2)
library(mathart)
library(dplyr)
library(tweenr)
library(randomcoloR)

name <- paste0('paintings/', Sys.Date(), ".png")

set.seed(as.numeric(Sys.Date()) - 199)      # World seed

# Give the painting dimensions

if (as.numeric(Sys.Date())%%2 == 0) { # Odd days we make a city map
  
  # Credits to https://github.com/marcusvolz/mathart
  
  print(paste0("Creating a city map for ", Sys.Date()))
  
  width <- sample(c(10000, 20000, 50000))
  height <- width
  
  # Set the painting options
  
  n <- width                            # Iterations
  r <- 75                               # Neighborhood
  delta <- 2 * pi / 180                 # Angle direction noise
  p_branch <- runif(1, 0.1, 0.2)        # Probability of branching
  initial_pts <- sample(1:4, size = 1) # Number of initial points
  nframes <- 500                        # Number of tweenr frames
  
  # Initialize the empty painting data
  
  points <- data.frame(x = numeric(n), y = numeric(n), dir = numeric(n), level = integer(n))
  edges <-  data.frame(x = numeric(n), y = numeric(n), xend = numeric(n), yend = numeric(n), level = integer(n))
  
  if(initial_pts > 1) {
    i <- 2
    while(i <= initial_pts) {
      points[i, ] <- c(runif(1, 0, width), runif(1, 0, height), runif(1, -2*pi, 2*pi), 1)
      i <- i + 1
    }
  }
  
  # Create the painting data
  
  for (i in (initial_pts + 1):n) {
    valid <- FALSE
    while (!valid) {
      random_point <- sample_n(points[seq(1:(i-1)), ], 1) # Pick a point at random
      branch <- ifelse(runif(1, 0, 1) <= p_branch, TRUE, FALSE)
      alpha <- random_point$dir[1] + runif(1, -(delta), delta) + (branch * (ifelse(runif(1, 0, 1) < 0.5, -1, 1) * pi/2))
      v <- c(cos(alpha), sin(alpha)) * r * (1 + 1 / ifelse(branch, random_point$level[1]+1, random_point$level[1])) # Create directional vector
      xj <- random_point$x[1] + v[1]
      yj <- random_point$y[1] + v[2]
      lvl <- random_point$level[1]
      lvl_new <- ifelse(branch, lvl+1, lvl)
      if(xj < 0 | xj > width | yj < 0 | yj > height) {
        next
      }
      points_dist <- points %>% mutate(d = sqrt((xj - x)^2 + (yj - y)^2))
      if (min(points_dist$d) >= 1 * r) {
        points[i, ] <- c(xj, yj, alpha, lvl_new)
        edges[i, ] <- c(xj, yj, random_point$x[1], random_point$y[1], lvl_new)
        # Add a building if possible
        buiding <- 1
        valid <- TRUE
      }
    }
    if(i%%1000 == 0)
      print(paste0("Iteration ", i, " of ", n))
  }
  
  edges <- edges %>% filter(level > 0)
  edges <- cbind(index = 1:nrow(edges), edges)
  
  # Create the painting
  
  painting <- ggplot() +
    geom_segment(mapping = aes(x, y, xend = xend, yend = yend, size = -level), 
                 data = edges, lineend = "round") +
    xlim(0, width) +
    ylim(0, height) +
    coord_equal() +
    scale_size_continuous(range = c(0.5, 0.5)) +
    theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)
  
  ggsave(name, painting, width = width/1000, height = height/1000, units = "cm", dpi = 300)
  
} else { # Even days we make an expanding tree
  
  print(paste0("Creating a non-city map for ", Sys.Date()))
  
  my_formula <- list(
    x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:5), 1) - sin(y_i^sample(c(0.5, 1, 2, 3, 4, 5), 1)) * runif(1, -100, 100)),
    y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:5), 1) - cos(x_i^sample(c(0.5, 1, 2, 3, 4, 5), 1)) * y_i^sample(1:5, 1) + runif(1, -100, 100))
  )

  color <- randomcoloR::randomColor(1, luminosity = "dark")

  df <- seq(from = -pi, to = pi, by = 0.01) %>% 
    expand.grid(x_i = ., y_i = .) %>% 
    dplyr::mutate(!!!my_formula)
  
  painting <- df %>% ggplot2::ggplot(ggplot2::aes(x = x, y = y)) + 
    ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20, color = color) + 
    ggplot2::theme_void() + 
    ggplot2::coord_fixed() + 
    ggplot2::coord_polar() + 
    theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)
  
  ggplot2::ggsave(painting, filename = name, scale = 1, dpi = 300)
  
}