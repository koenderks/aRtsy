generate_function_painting <- function(formula, color, bgcolor)
{
  df <- seq(from = -pi, to = pi, by = 0.01) %>% 
          expand.grid(x_i = ., y_i = .) %>% 
          dplyr::mutate(!!!formula)
  
  painting <- df %>% ggplot2::ggplot(ggplot2::aes(x = x, y = y)) + 
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