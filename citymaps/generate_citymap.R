# Metropolis: Generative city visualisations

# 1. Packages
library(mathart)
library(ggplot2)
library(tweenr)
library(viridis)

# 2. Make reproducible
set.seed(120495)

# 3. Parameters
n <- 10000 # iterations
r <- 75 # neighbourhood
width <- 10000 # canvas width
height <- 10000 # canvas height
delta <- 2 * pi / 180 # angle direction noise
p_branch <- 0.1 # probability of branching
initial_pts <- 3 # number of initial points
nframes <- 500 # number of tweenr frames

# 4. Initialise data frames
points <- data.frame(x = numeric(n), y = numeric(n), dir = numeric(n), level = integer(n))
edges <-  data.frame(x = numeric(n), y = numeric(n), xend = numeric(n), yend = numeric(n), level = integer(n))

if(initial_pts > 1) {
  i <- 2
  while(i <= initial_pts) {
    points[i, ] <- c(runif(1, 0, width), runif(1, 0, height), runif(1, -2*pi, 2*pi), 1)
    i <- i + 1
  }
}

# 5. Main loop ----
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
  print(i)
}

edges <- edges %>% filter(level > 0)
sand <- data.frame(alpha = numeric(0), x = numeric(0), y = numeric(0))
perp <- data.frame(x = numeric(0), y = numeric(0), xend = numeric(0), yend = numeric(0))

# 6. Create painting
painting <- ggplot() +
  geom_segment(aes(x, y, xend = xend, yend = yend, size = -level), edges, lineend = "round") +
  #geom_segment(aes(x, y, xend = xend, yend = yend), perp, lineend = "round", alpha = 0.15) +
  #geom_point(aes(x, y), points) +
  #geom_point(aes(x, y), sand, size = 0.05, alpha = 0.05, colour = "black") +
  xlim(0, 10000) +
  ylim(0, 10000) +
  coord_equal() +
  scale_size_continuous(range = c(0.5, 0.5)) +
  #scale_color_viridis() +
  theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)

# 8. Save painting
ggsave("citymap1.png", painting, width = 20, height = 20, units = "cm", dpi = 300)