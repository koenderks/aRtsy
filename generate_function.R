generate_function <- function(formula)
{
  df <- seq(from = -pi, to = pi, by = 0.01) %>% 
    expand.grid(x_i = ., y_i = .) %>% 
    dplyr::mutate(!!!formula)
  
  painting <- df %>% ggplot2::ggplot(ggplot2::aes(x = x, y = y)) + 
    ggplot2::geom_point(alpha = 0.1, size = 0, shape = 20, color = color) + 
    ggplot2::theme_void() + 
    ggplot2::coord_fixed() + 
    ggplot2::coord_polar() + 
    theme_blankcanvas(bg_col = "#fafafa", margin_cm = 0)
  
  return(painting)
}