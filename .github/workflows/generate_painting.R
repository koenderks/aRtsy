# Packages required for painting
library(ggart)
library(randomcoloR)

# Name of the painting
paintingPNGname <- paste0('png/daily.png')

# Painting seed dependent on the date
seed <- as.numeric(Sys.time())
set.seed(seed)

# Select painting type
paintingType <- sample(1:9, size = 1)

if (paintingType == 1){
  
  painting <- ggart::paint_function(color = sample(c("black", randomcoloR::randomColor(1)), size = 1), 
                                    background = sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1), 
                                    seed = seed)
  
} else if (paintingType == 2){
  
  painting <- ggart::paint_strokes(colors = randomcoloR::randomColor(count = sample(5:15, size = 1)),
                                   neighbors = sample(1:4, size = 1),
                                   p = runif(1, 0.0001, 0.01),
                                   seed = seed,
                                   iter = sample(1:3, size = 1),
                                   width = 1500, 
                                   height = 1500,
								   side = sample(c(TRUE, FALSE), size = 1))
  
} else if (paintingType == 3){
  
  painting <- ggart::paint_turmite(color = sample(c("#000000", randomColor(count = 1)), size = 1),
                                   background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", randomColor(count = 1)), size = 1),
                                   p = runif(1, 0.2, 0.5),
                                   seed = seed, 
                                   iterations = 1e7,
                                   width = 1500, 
                                   height = 1500)
  
} else if (paintingType == 4){
  
  painting <- ggart::paint_ant(colors = randomcoloR::randomColor(count = sample(1:20, size = 1)),
                               background = sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c", randomColor(count = 1)), size = 1),
                               seed = seed, 
                               iterations = 1e7,
                               width = 500, 
                               height = 500)
  
} else if(paintingType == 5){

  painting <- ggart::paint_mondriaan(colors = randomcoloR::randomColor(count = sample(3:10, size = 1)),
                                     background = '#000000',
									 cuts = sample(5:200, size = 1),
									 ratio = 1.618,
									 seed = seed,
									 width = 100,
									 height = 100)

} else if (paintingType == 6) {
  
  painting <- ggart::paint_planet(colors = list(randomcoloR::randomColor(3)), 
  								  iterations = 30, 
								  seed = seed, 
								  starprob = runif(1, 0.001, 0.1))

} else if (paintingType == 7) {
	
	painting <- ggart::paint_circlemap(colors = randomcoloR::randomColor(3, luminosity = "dark"),
	                   x_min = runif(1, -4, 0),
									   x_max = runif(1, 1, 14),
									   y_min = 0,
									   y_max = 1,
									   iterations = sample(1:30, size = 1),
									   seed = seed,
									   width = 1500,
									   height = 1500)
	
} else if (paintingType == 8) {
  
  painting <- ggart::paint_arcs(colors = randomcoloR::randomColor(3, luminosity = "dark"), 
                                background = randomcoloR::randomColor(1, luminosity = "light"), 
                                nrow = NULL,
                                ncol = NULL,
                                n = sample(c(4, 6, 9, 12, 16), size = 1), 
                                dir = sample(c("right", "left"), size = 1),
                                starts = sample(c("clockwise", "random"), size = 1))

} else if (paintingType == 9) {

  painting <- ggart::paint_ribbons(colors = randomcoloR::randomColor(sample(3:6, size = 1), luminosity = "dark"),
                                   background = randomcoloR::randomColor(1, luminosity = "light"),
                                   seed = seed)

}

ggplot2::ggsave(painting, filename = paintingPNGname, width = 7, height = 7, dpi = 300)
