# Packages required for artworks
library(aRtsy)

# Name of the artwork
filename <- paste0('png/daily.png')

# Artwork seed dependent on the current date
seed <- as.numeric(Sys.Date())
set.seed(seed)

# Select artwork type
type <- sample(1:22, size = 1)

artwork <- switch(type,
                  '1' = canvas_turmite(colors = colorPalette('complement', sample(6:10, size = 1)), background = "#050505", p = runif(1, 0.2, 0.5), resolution = 2000, noise = TRUE, iterations = 1e7),
                  '2' = canvas_strokes(colors = colorPalette('complement', sample(5:15, size = 1)), neighbors = sample(1:4, size = 1), p = runif(1, 0.0001, 0.01), iterations = sample(1:3, size = 1), resolution = 1500, side = sample(c(TRUE, FALSE), size = 1)),
                  '3' = canvas_function(color = sample(c("black", colorPalette('random', 1)), size = 1), background = sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)),
                  '4' = canvas_ant(colors = colorPalette('complement', sample(6:20, size = 1)), background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", colorPalette('random', 1)), size = 1), resolution = 1000, iterations = 1e7),
                  '5' = canvas_squares(colors = colorPalette('complement', sample(3:10, size = 1)), background = '#000000', cuts = sample(10:200, size = 1), noise = TRUE),
                  '6' = canvas_planet(colors = colorPalette('complement', 3), iterations = 30, starprob = runif(1, 0.001, 0.1)),
                  '7' = canvas_forest(colors = colorPalette('complement', n = sample(2:12, size = 1)), resolution = 1500),
                  '8' = canvas_circlemap(colors = colorPalette('complement', sample(3:9, size = 1)), left = runif(1, -14, 1), right = runif(1, 1, 14), bottom = runif(1, -2, -1), top = runif(1, 1, 2), iterations = sample(1:30, size = 1), resolution = 1500),
                  '9' = canvas_polylines(colors = colorPalette('complement', sample(3:6, size = 1)), background = sample(c("#fafafa", "black", colorPalette('random', 1)), size = 1)),
                  '10' = canvas_diamonds(colors = colorPalette('complement', sample(4:8, size = 1)), background = sample(c("#fafafa", "black", colorPalette('random', 1)), size = 1), col.line = sample(c(NA, sample(c("#fafafa", "black", colorPalette('random', 1)), size = 1)), size = 1), radius = sample(c(1, 2, 2.5, 5, 7, 7.5), size = 1), p = sample(seq(0.4, 0.8, 0.05), size = 1)),
                  '11' = canvas_segments(colors = colorPalette('complement', sample(1:8, size = 1)), background = colorPalette('random', 1), n = sample(c(100, 200, 300, 400, 500), size = 1), H = 0.1, p = sample(c(0.3, 0.4, 0.5, 0.6, 0.7), size = 1)),
                  '12' = canvas_mandelbrot(colors = colorPalette('complement', n = 5), zoom = sample(seq(4, 21, by = 0.5), 1)),
                  '13' = canvas_nebula(colors = colorPalette('complement', sample(6:10, size = 1)), k = sample(50:100, size = 1), resolution = 2000),
                  '14' = canvas_mosaic(colors = colorPalette('complement', n = sample(3:10, size = 1)), maxk = sample(c(1, 2, 3, 10, 50, 100), size = 1), resolution = 1500),
                  '15' = canvas_stripes(colors = colorPalette("complement", sample(10:20, size = 1)), burnin = sample(1:200, size = 1)),
                  '16' = canvas_gemstone(colors = colorPalette('complement', n = sample(15:25, size = 1)), resolution = 1500),
                  '17' = canvas_blacklight(colors = colorPalette('complement', n = sample(2:10, size = 1)), resolution = 1500),
                  '18' = canvas_ribbons(colors = colorPalette('complement', sample(3:6, size = 1)), background = colorPalette('random', 1)),
                  '19' = canvas_collatz(colors = colorPalette('complement', n = 5), background = sample(c("black", "#fdf5e6", "#fafafa"), size = 1), n = sample(200:2000, size = 1), side = sample(c(TRUE, FALSE), size = 1)),
                  '20' = canvas_watercolors(colors = colorPalette("complement", n = sample(2:15, size = 1)), background = sample(c('#fafafa', "black", "#ebd5b3", "darkgoldenrod3", "lavenderblush2", "salmon1"), size = 1), layers = 50, depth = 3),
                  '21' = canvas_flow(colors = colorPalette("complement", n = sample(4:20, size = 1)), background = sample(c("#fafafa", "firebrick", "#f9f0e0", "black", "lavenderblush2"), size = 1), lines = sample(2000:3000, size = 1), lwd = sample(seq(0.04, 0.1, 0.01), size = 1), iterations = 500, stepmax = 0.01),
                  '22' = canvas_maze(color = colorPalette("random", 1), walls = colorPalette("random", 1), background = colorPalette("random", 1), resolution = sample(50:100, size = 1), polar = sample(c(TRUE, FALSE), size = 1)))

saveCanvas(artwork, filename, width = ifelse(type == 19, yes = NA, no = 7), height = ifelse(type == 19, yes = NA, no = 7))
