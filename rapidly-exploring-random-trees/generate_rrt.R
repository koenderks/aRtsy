# Forest: Rapidly exploring tree visualizations

# 1. Load required packages
library(mathart)
library(dplyr)
library(ggforce)
library(ggplot2)

# 2. Give the painting a name
name <- "rrt1"

# 3. Set the painting options
set.seed(120495)
nTrees <- 3
dimensions <- 10000
n <- 10000

# 3. Simulate the rrt edges
paintingData <- list()
for (i in 1:nTrees) {
  paintingData[[i]] <- mathart::rapidly_exploring_random_tree(X = dimensions, n = n, delta = runif(1, 1, 10)) %>% mutate(id = 1:nrow(.))
}

# 4. Create the painting
painting <- ggplot() +
  coord_equal() +
  scale_size_continuous(range = c(0.1, 0.75)) +
  scale_alpha_continuous(range = c(0.1, 1)) +
  theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)

for (i in length(paintingData)) {
  painting <- painting + geom_segment(aes(x, y, xend = xend, yend = yend, size = -id, alpha = -id), paintingData[[i]], lineend = "round")
}

# 5. Save the painting
ggsave(paste0(name, ".png"), painting, scale = 1)
