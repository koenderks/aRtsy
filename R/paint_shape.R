paint_shape <- function(color, background, seed){
  
  set.seed(seed)
  
  painting_formulas <- list()
  
  painting_formulas[[1]] <- list( 
    x = quote(runif(1, -10, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1)) * runif(1, -100, 100)),
    y = quote(runif(1, -10, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(1:6, 1) + runif(1, -100, 100))
  )
  
  painting_formulas[[2]] <- list(
    x = quote(sample(1:10, 1) * (x_i/sample(c(0.5, 1:6), 1)) * runif(1, -100, 100) * (sin(y_i) - asinh(x_i))),
    y = quote(sample(1:10, 1) * x_i - tanh(y_i) + (runif(1, -100, 100)))
  )
  
  painting_formulas[[3]] <- list(
    x = quote(runif(1, -1, 10) * x_i^sample(c(0.5, 1:6), 1) - sin(y_i^sample(c(0.5, 1:6), 1))),
    y = quote(runif(1, -1, 10) * y_i^sample(c(0.5, 1:6), 1) - cos(x_i^sample(c(0.5, 1:6), 1)) * y_i^sample(c(0.5, 1:6), 1))
  )
  
  painting_formula <- painting_formulas[[sample(1:length(painting_formulas), 1)]]
  
  df <- seq(from = -pi, to = pi, by = 0.01) %>% expand.grid(x_i = ., y_i = .) %>% dplyr::mutate(!!!painting_formula)
  
  painting <- ggplot2::ggplot(data = df, ggplot2::aes(x = x, y = y)) + 
    ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20, color = color) + 
    ggplot2::theme_void() + 
    ggplot2::coord_fixed() + 
    ggplot2::coord_polar() + 
    theme(axis.title = element_blank(), 
          axis.text = element_blank(), 
          axis.ticks = element_blank(), 
          axis.line = element_blank(), 
          legend.position = "none", 
          panel.background = element_rect(fill = bgcolor, colour = bgcolor), 
          panel.border = element_blank(), 
          panel.grid = element_blank(), 
          plot.background = element_rect(fill = bgcolor, colour = bgcolor), 
          plot.margin = unit(rep(0, 4), "cm"), 
          strip.background = element_blank(), 
          strip.text = element_blank())
  
  return(painting)
  
}