# Packages required for artworks
library(aRtsy)

# Name of the artwork
filename <- paste0("png/daily.png")

# Artwork seed dependent on the current date
seed <- as.numeric(Sys.Date())
set.seed(seed)

# Select artwork type
type <- sample(1:28, size = 1)

# Create artwork with random palette, feel free to suggest a new pallette at https://github.com/koenderks/aRtsy/issues
artwork <- switch(type,
  "1" = canvas_turmite(colors = colorPalette("random-palette"), background = "#050505", p = runif(1, 0.2, 0.5), resolution = 2000, noise = TRUE, iterations = 1e7),
  "2" = canvas_strokes(colors = colorPalette("random-palette"), neighbors = sample(1:4, size = 1), p = runif(1, 0.0001, 0.01), iterations = sample(1:3, size = 1), resolution = 1500, side = sample(c(TRUE, FALSE), size = 1)),
  "3" = canvas_function(color = colorPalette("random-palette"), background = sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)),
  "4" = canvas_ant(colors = colorPalette("random-palette"), background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", colorPalette("random", 1)), size = 1), resolution = 1000, iterations = 1e7),
  "5" = canvas_squares(colors = colorPalette("random-palette"), background = "#000000", cuts = sample(10:200, size = 1), noise = TRUE),
  "6" = canvas_planet(colors = colorPalette("random-palette", n = 3), iterations = 30, starprob = runif(1, 0.001, 0.1)),
  "7" = canvas_forest(colors = colorPalette("random-palette"), resolution = 1500),
  "8" = canvas_circlemap(colors = colorPalette("random-palette"), left = runif(1, -14, 1), right = runif(1, 1, 14), bottom = runif(1, -2, -1), top = runif(1, 1, 2), iterations = sample(1:30, size = 1), resolution = 1500),
  "9" = canvas_polylines(colors = colorPalette("random-palette"), background = sample(c("#fafafa", "black", colorPalette("random", 1)), size = 1)),
  "10" = canvas_diamonds(colors = colorPalette("random-palette"), background = sample(c("#fafafa", "black", colorPalette("random", 1)), size = 1), col.line = sample(c(NA, sample(c("#fafafa", "black", colorPalette("random", 1)), size = 1)), size = 1), radius = sample(c(1, 2, 2.5, 5, 7, 7.5), size = 1), p = sample(seq(0.4, 0.8, 0.05), size = 1)),
  "11" = canvas_segments(colors = colorPalette("random-palette"), n = sample(c(300, 400, 500, 600, 700), size = 1), H = 0.1, p = sample(c(0.3, 0.4, 0.5, 0.6, 0.7), size = 1)),
  "12" = canvas_mandelbrot(colors = colorPalette("random-palette"), zoom = sample(seq(4, 21, by = 0.5), 1)),
  "13" = canvas_nebula(colors = colorPalette("random-palette"), k = sample(50:100, size = 1), resolution = 2000),
  "14" = canvas_mosaic(colors = colorPalette("random-palette"), resolution = 1500),
  "15" = canvas_stripes(colors = colorPalette("random-palette"), burnin = sample(1:200, size = 1)),
  "16" = canvas_gemstone(colors = colorPalette("random-palette"), resolution = 1500),
  "17" = canvas_blacklight(colors = colorPalette("random-palette"), resolution = 1500),
  "18" = canvas_ribbons(colors = colorPalette("random-palette"), background = colorPalette("random", 1)),
  "19" = canvas_collatz(colors = colorPalette("random-palette"), background = sample(c("black", "#fdf5e6", "#fafafa"), size = 1), n = sample(200:2000, size = 1), side = sample(c(TRUE, FALSE), size = 1)),
  "20" = canvas_watercolors(colors = colorPalette("random-palette"), background = sample(c("#fafafa", "black", "#ebd5b3", "darkgoldenrod3", "lavenderblush2", "salmon1"), size = 1), layers = 50, depth = 3),
  "21" = canvas_flow(colors = colorPalette("random-palette"), background = sample(c("#fafafa", "firebrick", "#f9f0e0", "black", "lavenderblush2", "#215682"), size = 1), lines = sample(2000:3000, size = 1), lwd = sample(seq(0.3, 0.6, 0.01), size = 1), iterations = 500, stepmax = 0.01, polar = sample(c(TRUE, FALSE), size = 1)),
  "22" = canvas_maze(color = colorPalette("random", 1), walls = colorPalette("random", 1), background = colorPalette("random", 1), resolution = sample(50:100, size = 1)),
  "23" = canvas_recaman(colors = colorPalette("random-palette"), background = colorPalette("random", 1), iterations = sample(100:1000, size = 1), curvature = sample(1:15, size = 1), start = sample(1:100, size = 1), angle = sample(c(0, 45), size = 1)),
  "24" = canvas_phyllotaxis(colors = colorPalette("random-palette"), iterations = sample(1000:100000, size = 1), p = runif(1, 0.5, 0.9), background = colorPalette("random", 1), angle = runif(1, 0, 1000), size = 0.01, alpha = runif(1, 0.3, 1)),
  "25" = canvas_cobweb(colors = colorPalette("random-palette"), background = colorPalette("random", 1), lines = sample(500:1000, size = 1), iterations = sample(20:100, size = 1)),
  "26" = canvas_chladni(colors = colorPalette("random-palette"), waves = sample(3:10, size = 1), resolution = sample(c(500, 1000), size = 1), warp = runif(1, 0, 1.5)),
  "27" = canvas_petri(colors = colorPalette("random-palette"), background = colorPalette("random", 1), dish = colorPalette("random", 1), attractors = 5000, iterations = sample(10:20, size = 1), hole = sample(c(0, 0.7, 0.8), size = 1)),
  "28" = canvas_split(colors = colorPalette("random-palette"), background = colorPalette("random", 1), iterations = sample(6:8, size = 1), sd = abs(rnorm(1, sd = 0.2)))
)

saveCanvas(artwork, filename, width = ifelse(type == 19, yes = NA, no = 7), height = ifelse(type == 19, yes = NA, no = 7))
