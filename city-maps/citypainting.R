# Metropolis: Generative city visualizations (https://github.com/marcusvolz/metropolis/blob/master/metropolis.R)

# 1. Load required packages

library(ggplot2)
library(mathart)
library(dplyr)
library(tweenr)

# 2. Give the painting a name and dimensions

width <- 50000
height <- 50000

# 3. Set the painting options

set.seed(runif(1))        # World seed
n <- 5000                 # Iterations
r <- 75                   # Neighborhood
delta <- 2 * pi / 180     # Angle direction noise
p_branch <- 0.1           # Probability of branching
initial_pts <- 4          # Number of initial points
nframes <- 500            # Number of tweenr frames

# 4. Initialize the empty painting data

points <- data.frame(x = numeric(n), y = numeric(n), dir = numeric(n), level = integer(n))
edges <-  data.frame(x = numeric(n), y = numeric(n), xend = numeric(n), yend = numeric(n), level = integer(n))

if(initial_pts > 1) {
  i <- 2
  while(i <= initial_pts) {
    points[i, ] <- c(runif(1, 0, width), runif(1, 0, height), runif(1, -2*pi, 2*pi), 1)
    i <- i + 1
  }
}

# 5. Create the painting data

i <- initial_pts + 1
while (i <= n) {
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
  i <- i + 1
  print(paste0("Iteration ", i, " of ", n))
}

edges <- edges %>% filter(level > 0)
edges <- cbind(index = 1:nrow(edges), edges)

# 6. Create the painting

painting <- ggplot() +
  geom_segment(aes(x, y, xend = xend, yend = yend, size = -level), edges, lineend = "round") +
  xlim(0, width) +
  ylim(0, height) +
  coord_equal() +
  scale_size_continuous(range = c(0.5, 0.5)) +
  theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)

# 7. Save the painting

name <- paste0('city-maps/', Sys.Date(), ".png")
ggsave(name, painting, width = 50, height = 50, units = "cm", dpi = 300)