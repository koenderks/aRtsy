# Packages required for artworks
library(aRtsy)

# Name of the artwork
filename <- paste0('png/daily.png')

# Artwork seed dependent on the current date
seed <- as.numeric(Sys.Date())
set.seed(seed)

# Select artwork type
type <- sample(1:14, size = 1)

if (type == 1) {
  
  print("I'm painting a function today.")
  artwork <- aRtsy::canvas_function(color = sample(c("black", aRtsy::colorPalette('random', 1)), size = 1), 
                                    background = sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1))
  
} else if (type == 2) {
  
  print("I'm painting strokes today.")
  artwork <- aRtsy::canvas_strokes(colors = aRtsy::colorPalette('random', sample(5:15, size = 1)),
                                   neighbors = sample(1:4, size = 1),
                                   p = runif(1, 0.0001, 0.01),
                                   iter = sample(1:3, size = 1),
                                   width = 1500, 
                                   height = 1500,
                                   side = sample(c(TRUE, FALSE), size = 1))
  
} else if (type == 3) {
  
  print("I'm painting a turmite today.")
  artwork <- aRtsy::canvas_turmite(color = sample(c("#000000", aRtsy::colorPalette('random', 1)), size = 1),
                                   background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", aRtsy::colorPalette('random', 1)), size = 1),
                                   p = runif(1, 0.2, 0.5),
                                   iterations = 1e7,
                                   width = 1500, 
                                   height = 1500)
  
} else if (type == 4) {
  
  print("I'm painting an ant today.")
  dims <- sample(c(500, 1000, 1500), size = 1)
  artwork <- aRtsy::canvas_ant(colors = aRtsy::colorPalette('random', sample(6:20, size = 1)),
                               background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", aRtsy::colorPalette('random', 1)), size = 1),
                               iterations = 1e7,
                               width = dims, 
                               height = dims)
  
} else if (type == 5) {
  
  print("I'm painting squares today.")
  artwork <- aRtsy::canvas_squares(colors = aRtsy::colorPalette('random', sample(3:10, size = 1)),
                                   background = '#000000',
                                   cuts = sample(10:200, size = 1),
                                   ratio = 1.618,
                                   width = 100,
                                   height = 100)
  
} else if (type == 6) {
  
  print("I'm painting a planet today.")
  artwork <- aRtsy::canvas_planet(colors = list(aRtsy::colorPalette('random', 3)), 
                                  iterations = 30, 
                                  starprob = runif(1, 0.001, 0.1))
  
} else if (type == 7) {
  
  print("I'm painting a circlemap today.")
  artwork <- aRtsy::canvas_circlemap(colors = aRtsy::colorPalette('random', 3),
                                     x_min = runif(1, -4, 0),
                                     x_max = runif(1, 1, 14),
                                     y_min = 0,
                                     y_max = 1,
                                     iterations = sample(1:30, size = 1),
                                     width = 1500,
                                     height = 1500)
  
} else if (type == 8) {
  
  print("I'm painting ribbons today.")
  artwork <- aRtsy::canvas_ribbons(colors = aRtsy::colorPalette('random', sample(3:6, size = 1)),
                                   background = aRtsy::colorPalette('random', 1))
  
} else if (type == 9) {
  
  print("I'm painting polylines today.")
  artwork <- aRtsy::canvas_polylines(colors = aRtsy::colorPalette('random', sample(3:6, size = 1)),
                                     background = sample(c("#fafafa", "black", aRtsy::colorPalette('random', 1)), size = 1))
  
} else if (type == 10) {
  
  print("I'm painting diamonds today.")
  artwork <- aRtsy::canvas_diamonds(colors = aRtsy::colorPalette('random', sample(4:8, size = 1)), 
                                    background = sample(c("#fafafa", "black", aRtsy::colorPalette('random', 1)), size = 1),
                                    col.line = sample(c(NA, sample(c("#fafafa", "black", aRtsy::colorPalette('random', 1)), size = 1)), size = 1),
                                    radius = sample(c(1, 2, 2.5, 5, 7, 7.5), size = 1),
                                    p = sample(seq(0.1, 0.7, 0.1), size = 1))
  
} else if (type == 11) {
  
  print("I'm painting segments today.")
  artwork <- aRtsy::canvas_segments(colors = aRtsy::colorPalette('random', sample(1:8, size = 1)), 
                                    background = aRtsy::colorPalette('random', 1), 
                                    n = sample(c(100, 200, 300, 400, 500), size = 1),
                                    H = 0.1,
                                    p = sample(c(0.3, 0.4, 0.5, 0.6, 0.7), size = 1))
  
} else if (type == 12) {
  
  print("I'm painting a mandelbrot today.")
  artwork <- aRtsy::canvas_mandelbrot(colors = aRtsy::colorPalette('random', n = 5), 
                                      zoom = sample(seq(4, 21, by = 0.5), 1))
  
} else if (type == 13) {
  
  print("I'm painting a collatz today.")
  artwork <- aRtsy::canvas_collatz(colors = aRtsy::colorPalette('random', n = 5), 
                                   background = sample(c("black", "#fdf5e6", "#fafafa"), size = 1),
                                   n = sample(200:2000, size = 1),
                                   side = sample(c(TRUE, FALSE), size = 1))
  
} else if (type == 14) {
  
  print("I'm painting a mosaic today.")
  p1 <- aRtsy::canvas_mosaic(colors = aRtsy::colorPalette('random', n = sample(2:10, size = 1),
                             maxk = sample(c(1, 2, 3, 10, 50, 100), size = 1),
                             resolution = 1500)
  
}

aRtsy::saveCanvas(artwork, filename, width = ifelse(type == 13, yes = NA, no = 7), height = ifelse(type == 13, yes = NA, no = 7))
