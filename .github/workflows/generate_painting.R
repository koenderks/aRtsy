# Packages required for painting
library(aRtsy)
library(randomcoloR)

# Name of the painting
paintingPNGname <- paste0('png/daily.png')

# Painting seed dependent on the date
seed <- as.numeric(Sys.Date())
set.seed(seed)

# Select painting type
paintingType <- sample(1:3, size = 1)

if (paintingType == 1){
  
  bgcolor <- sample(c("#fafafa", "#1a3657", "#343434", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)
  if(bgcolor %in% c("#fafafa",  "#cc7722", "#a9d2c3", "#fc7c7c")){
    color <- sample(c("black", randomcoloR::randomColor(1, luminosity = "dark")), size = 1)
  } else {
    color <- randomcoloR::randomColor(1, luminosity = "light")
  }
  
  painting <- aRtsy::paint_shape(color = color, background = bgcolor, seed = seed)
  
} else if (paintingType == 2){
  
  painting <- aRtsy::paint_strokes(palette = randomcoloR::randomColor(count = sample(5:15, size = 1)),
                                   neighbors = sample(1:4, size = 1),
                                   p = runif(1, 0.0001, 0.01),
                                   seed = seed,
                                   iter = sample(1:3, size = 1),
                                   width = 1500, 
                                   height = 1500)
  
} else if (paintingType == 3){
  
  bgcolor <- sample(c("#fafafa", "#cc7722", "#a9d2c3", "#fc7c7c"), size = 1)
  painting <- aRtsy::paint_turmite(color = "#000000",
                                   background = bgcolor,
                                   p = runif(1, 0.2, 0.5),
                                   seed = seed, 
                                   iterations = 1e7,
                                   width = 1500, 
                                   height = 1500)
  
}

ggplot2::ggsave(painting, filename = paintingPNGname, width = 7, height = 7, dpi = 300)
