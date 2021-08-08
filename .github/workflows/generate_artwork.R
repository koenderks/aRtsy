# Packages required for artworks
library(aRtsy)

# Name of the artwork
filename <- paste0('png/daily.png')

# Artwork seed dependent on the current time
seed <- as.numeric(Sys.time())
set.seed(seed)

# Select artwork type
type <- sample(1:11, size = 1)

if (type == 1) {
  
  artwork <- aRtsy::canvas_function(color = sample(c("black", aRtsy::colorPalette('random', 1)), size = 1), 
                                    background = sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1))
  
} else if (type == 2) {
  
  artwork <- aRtsy::canvas_strokes(colors = aRtsy::colorPalette('random', sample(5:15, size = 1)),
                                   neighbors = sample(1:4, size = 1),
                                   p = runif(1, 0.0001, 0.01),
                                   iter = sample(1:3, size = 1),
                                   width = 1500, 
                                   height = 1500,
                                   side = sample(c(TRUE, FALSE), size = 1))
  
} else if (type == 3) {
  
  artwork <- aRtsy::canvas_turmite(color = sample(c("#000000", aRtsy::colorPalette('random', 1)), size = 1),
                                   background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", aRtsy::colorPalette('random', 1)), size = 1),
                                   p = runif(1, 0.2, 0.5),
                                   iterations = 1e7,
                                   width = 1500, 
                                   height = 1500)
  
} else if (type == 4) {
  
  dims <- sample(c(500, 1000, 1500), size = 1)
  artwork <- aRtsy::canvas_ant(colors = aRtsy::colorPalette('random', sample(6:20, size = 1)),
                               background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", aRtsy::colorPalette('random', 1)), size = 1),
                               iterations = 1e7,
                               width = dims, 
                               height = dims)
  
} else if (type == 5) {
  
  artwork <- aRtsy::canvas_squares(colors = aRtsy::colorPalette('random', sample(3:10, size = 1)),
                                   background = '#000000',
                                   cuts = sample(10:200, size = 1),
                                   ratio = 1.618,
                                   width = 100,
                                   height = 100)
  
} else if (type == 6) {
  
  artwork <- aRtsy::canvas_planet(colors = list(aRtsy::colorPalette('random', 3)), 
                                  iterations = 30, 
                                  starprob = runif(1, 0.001, 0.1))
  
} else if (type == 7) {
  
  artwork <- aRtsy::canvas_circlemap(colors = aRtsy::colorPalette('random', 3),
                                     x_min = runif(1, -4, 0),
                                     x_max = runif(1, 1, 14),
                                     y_min = 0,
                                     y_max = 1,
                                     iterations = sample(1:30, size = 1),
                                     width = 1500,
                                     height = 1500)
  
} else if (type == 8) {
  
  artwork <- aRtsy::canvas_ribbons(colors = aRtsy::colorPalette('random', sample(3:6, size = 1)),
                                   background = aRtsy::colorPalette('random', 1))
  
} else if (type == 9) {
  
  artwork <- aRtsy::canvas_polylines(colors = aRtsy::colorPalette('random', sample(3:6, size = 1)),
                                     background = sample(c("#fafafa", "black", aRtsy::colorPalette('random', 1)), size = 1))
  
} else if (type == 10) {
  
  artwork <- aRtsy::canvas_diamonds(colors = aRtsy::colorPalette('random', sample(4:8, size = 1)), 
                                    background = sample(c("#fafafa", "black", aRtsy::colorPalette('random', 1)), size = 1),
                                    col.line = sample(c("#fafafa", "black", aRtsy::colorPalette('random', 1)), size = 1),
                                    radius = sample(c(2, 2.5, 5, 7, 7.5, 10), size = 1),
                                    p = sample(seq(0, 0.7, 0.1), size = 1),
                                    size = sample(c(0, 0.2), size = 1))
  
} else if (type == 11) {
  
  artwork <- aRtsy::canvas_segments(colors = aRtsy::colorPalette('random', sample(1:8, size = 1)), 
                                    background = aRtsy::colorPalette('random', 1), 
                                    n = sample(c(100, 200, 300, 400, 500), size = 1),
                                    H = 0.1,
                                    p = sample(c(0.3, 0.4, 0.5, 0.6, 0.7), size = 1))
  
}

aRtsy::saveCanvas(artwork, filename)
