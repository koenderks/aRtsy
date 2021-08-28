# Packages required for artworks
library(aRtsy)

# Name of the artwork
filename <- paste0('png/daily.png')

# Artwork seed dependent on the current date
seed <- as.numeric(Sys.Date())
set.seed(seed)

# Select artwork type
type <- sample(1:18, size = 1)

artwork <- switch(type,
                  '1' = canvas_turmite(color = colorPalette('random', sample(4:10, size = 1)), background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", colorPalette('random', 1)), size = 1), p = runif(1, 0.2, 0.5), width = 2000, height = 2000, noise = "knn"),
                  '2' = canvas_strokes(colors = colorPalette('random', sample(5:15, size = 1)), neighbors = sample(1:4, size = 1), p = runif(1, 0.0001, 0.01), iterations = sample(1:3, size = 1), width = 1500, height = 1500, side = sample(c(TRUE, FALSE), size = 1)),
                  '3' = canvas_function(color = sample(c("black", colorPalette('random', 1)), size = 1), background = sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)),
                  '4' = canvas_ant(colors = colorPalette('random', sample(6:20, size = 1)), background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", colorPalette('random', 1)), size = 1), width = 1000, height = 1000),
                  '5' = canvas_squares(colors = colorPalette('random', sample(3:10, size = 1)), background = '#000000', cuts = sample(10:200, size = 1), width = 100, height = 100),
                  '6' = canvas_planet(colors = list(colorPalette('random', 3)), iterations = 30, starprob = runif(1, 0.001, 0.1)),
                  '7' = canvas_forest(colors = colorPalette('random', n = sample(2:12, size = 1)), resolution = 1500),
                  '8' = canvas_circlemap(colors = colorPalette('random', 3), xmin = runif(1, -4, 0), xmax = runif(1, 1, 14), iterations = sample(1:30, size = 1), width = 1500, height = 1500),
                  '9' = canvas_polylines(colors = colorPalette('random', sample(3:6, size = 1)), background = sample(c("#fafafa", "black", colorPalette('random', 1)), size = 1)),
                  '10' = canvas_diamonds(colors = colorPalette('random', sample(4:8, size = 1)), background = sample(c("#fafafa", "black", colorPalette('random', 1)), size = 1), col.line = sample(c(NA, sample(c("#fafafa", "black", colorPalette('random', 1)), size = 1)), size = 1), radius = sample(c(1, 2, 2.5, 5, 7, 7.5), size = 1), p = sample(seq(0.1, 0.7, 0.1), size = 1)),
                  '11' = canvas_segments(colors = colorPalette('random', sample(1:8, size = 1)), background = colorPalette('random', 1), n = sample(c(100, 200, 300, 400, 500), size = 1), H = 0.1, p = sample(c(0.3, 0.4, 0.5, 0.6, 0.7), size = 1)),
                  '12' = canvas_mandelbrot(colors = colorPalette('random', n = 5), zoom = sample(seq(4, 21, by = 0.5), 1)),
                  '13' = canvas_collatz(colors = colorPalette('random', n = 5), background = sample(c("black", "#fdf5e6", "#fafafa"), size = 1), n = sample(200:2000, size = 1), side = sample(c(TRUE, FALSE), size = 1)),
                  '14' = canvas_mosaic(colors = colorPalette('random', n = sample(3:10, size = 1)), maxk = sample(c(1, 2, 3, 10, 50, 100), size = 1), resolution = 1500),
                  '15' = canvas_stripes(colors = colorPalette("random", sample(10:20, size = 1)), burnin = sample(1:200, size = 1)),
                  '16' = canvas_gemstone(colors = colorPalette('random', n = sample(15:25, size = 1)), resolution = 1500),
                  '17' = canvas_blacklight(colors = colorPalette('random', n = sample(2:10, size = 1)), resolution = 1500),
                  '18' = canvas_ribbons(colors = colorPalette('random', sample(3:6, size = 1)), background = colorPalette('random', 1)))

saveCanvas(artwork, filename, width = ifelse(type == 13, yes = NA, no = 7), height = ifelse(type == 13, yes = NA, no = 7))
