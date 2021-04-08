generate_tree <- function(n, ntrees, dims) 
{
  
  paintingData <- list()
  for (i in 1:ntrees) {
    paintingData[[i]] <- mathart::rapidly_exploring_random_tree(X = dimensions, n = n, delta = runif(1, 1, 10)) %>% mutate(id = 1:nrow(.))
  }
  
  painting <- ggplot() +
    geom_segment(aes(x, y, xend = xend, yend = yend, size = -id, alpha = -id), paintingData[[i]], lineend = "round")
    coord_equal() +
    scale_size_continuous(range = c(0.1, 0.75)) +
    scale_alpha_continuous(range = c(0.1, 1)) +
    theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)
  
  return(painting)
}