generate_tree <- function(n, dims, delta) 
{
  
  points <- data.frame(x = numeric(n), y = numeric(n))
  points[1, ] <- runif(2, 0, dims)
  edges <- data.frame(x = numeric(n), y = numeric(n), xend = numeric(n), yend = numeric(n))
  edges[1, ] <- c(as.numeric(points[1, ]), as.numeric(points[1, ]))
  i <- 2
  
  while (i <= n) {
    valid <- FALSE
    while (!valid) {
      rp <- runif(2, 0, dims)
      temp <- points[1:(i - 1), ] %>% mutate(dist = sqrt((rp[1] - x)^2 + (rp[2] - y)^2)) %>% arrange(dist)
      np <- as.numeric(temp[1, c("x", "y")])
      if (temp$dist[1] > delta) {
        rp2 <- np + (rp - np)/temp$dist[1] * delta
        rp <- rp2
      }
      temp2 <- edges[1:(i - 1), ] %>% mutate(intersects = does_intersect(rp, np, c(x, y), c(xend, yend)))
      if (sum(temp2$intersects) <= 0) {
        points[i, ] <- rp
        edges[i, ] <- c(np, rp)
        valid <- TRUE
      }
    }
    i <- i + 1
    if(i%%1000 == 0)
      print(paste0("Iteration: ", i, " of ", n))
  }
  edges$id <- 1:nrow(edges)
  
  painting <- ggplot() +
    geom_segment(aes(x, y, xend = xend, yend = yend, size = -id, alpha = -id), edges, lineend = "round") +
    coord_equal() +
    scale_size_continuous(range = c(0.1, 0.75)) +
    scale_alpha_continuous(range = c(0.1, 1)) +
    theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)
  
  return(painting)
}