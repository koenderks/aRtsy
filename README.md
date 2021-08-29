[![CRAN](https://img.shields.io/cran/v/aRtsy?color=yellow&label=CRAN&logo=r)](https://cran.r-project.org/package=aRtsy)
[![R_build_status](https://github.com/koenderks/aRtsy/workflows/Build/badge.svg)](https://github.com/koenderks/aRtsy/actions)
[![Codecov](https://codecov.io/gh/koenderks/aRtsy/branch/development/graph/badge.svg?token=ZoxIB8p8PW)](https://codecov.io/gh/koenderks/aRtsy)
[![Bugs](https://img.shields.io/github/issues/koenderks/aRtsy/bug?label=Bugs&logo=github&logoColor=%23FFF&color=brightgreen)](https://github.com/koenderks/aRtsy/issues?q=is%3Aopen+is%3Aissue+label%3Abug)
[![Monthly](https://cranlogs.r-pkg.org/badges/aRtsy?color=blue)](https://cranlogs.r-pkg.org)
[![Total](https://cranlogs.r-pkg.org/badges/grand-total/aRtsy?color=blue)](https://cranlogs.r-pkg.org)

# aRtsy: Generative Art with `R` and `ggplot2`

<img src='https://github.com/koenderks/aRtsy/raw/development/man/figures/logo.png' width='149' height='173' alt='logo' align='right' margin-left='20' margin-right='20'/>

*"If you laugh at a joke, what difference does it make if subsequently you are told that the joke was created by an algorithm?" - Marcus du Sautoy, The Creative Code*

`aRtsy` is an attempt at making generative art available for the masses in a simple and standardized format. The package provides various algorithms for creating artworks in `ggplot2` that incorporate some form of randomness (depending on the set `seed`). Each type of artwork is implemented in a separate function.

Good luck hunting for some good `seed`'s! Feel free to post a comment with your best artworks and the corresponding seed in the [GitHub discussions](https://github.com/koenderks/aRtsy/discussions).

Contributions to `aRtsy` are very much appreciated! If you want to add your own artwork to the package so that others can create unique versions of it, feel free to make a pull request to the [GitHub repository](https://github.com/koenderks/aRtsy). Don't forget to also adjust [generate-artwork.R](https://github.com/koenderks/aRtsy/blob/development/.github/workflows/generate_artwork.R) if you want the artwork to show up in the 'Artwork of the day' category and the twitter feed.

## Artwork of the day

Every 24 hours this repository generates and tweets a random artwork using the `aRtsy` package. The full collection of daily artworks is available on the [aRtsy twitter feed](https://twitter.com/aRtsy_package). This is today's artwork:

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/daily.png' width='400' height='400'>
</p>

## Installation

The most recently released version of `aRtsy` can be downloaded from [CRAN](https://cran.r-project.org/package=aRtsy) by running the following command in R:

```r
install.packages('aRtsy')
```

Alternatively, you can download the development version from GitHub using:

```r
devtools::install_github('koenderks/aRtsy')
```

After installation, the `aRtsy` package can be loaded with:

```r
library(aRtsy)
```

## Available artworks

*The Iterative collection*

* [`canvas_strokes()`](#paint-strokes)
* [`canvas_collatz()`](#collatz-conjecture)
* [`canvas_turmite()`](#turmite)
* [`canvas_ant()`](#langtons-ant)
* [`canvas_planet()`](#planets)
* [`canvas_stripes()`](#stripes)

*The Geometric collection*

* [`canvas_segments()`](#segments)
* [`canvas_diamonds()`](#diamonds)
* [`canvas_squares()`](#squares-and-rectangles)
* [`canvas_ribbons()`](#ribbons)
* [`canvas_polylines()`](#polylines)
* [`canvas_function()`](#functions)

*The Supervised collection*

* [`canvas_mosaic()`](#mosaics)
* [`canvas_forest()`](#forests)
* [`canvas_gemstone()`](#gemstones)
* [`canvas_nebula()`](#Nebula)
* [`canvas_blacklight()`](#blacklights)

*The Static collection*

* [`canvas_mandelbrot()`](#the-mandelbrot-set)
* [`canvas_cirlemap()`](#circle-maps)

### The Iterative collection

The Iterative collection mostly implements algorithms whose state depend on the previous state. These algorithms generally use a grid based canvas to draw on. On the grid, each point represents a pixel of the final image. By assigning a color to these points according to certain rules, one can create the images in this collection.

#### Paint strokes

When you think of the act of painting, you probably imagine stroking paint on a canvas. This type of artwork tries to mimic that activity. The paint strokes algorithm is based on the simple idea that each next point on a grid-based canvas has a chance to take over the color of an adjacent colored point, but also has a minor chance of generating a new color. Going over the canvas like this results in strokes of paint. Repeating this a number of times creates more faded strokes of paint.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/strokes/2021-03-21.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/strokes/2021-03-20.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/strokes/2021-03-10.png' width='270' height='270'>
</p>

You can use the `canvas_strokes()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_strokes(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'), 
               neighbors = 1, p = 0.01, iterations = 1, 
               width = 500, height = 500, side = FALSE)
```

#### Collatz conjecture

The Collatz conjecture is also known as `3x+1`. The algorithm draws lines according to a simple rule set:

1. Take a random positive number.
2. If the number is even, divide it by 2.
3. If the number is odd, multiply the number by 3 and add 1.
4. Repeat to get a sequence of numbers.

By visualizing the sequence for each number, overlaying sequences that are the same, and bending the edges differently for even and odd numbers in the sequence, organic looking coral structures can occur.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/collatzs/2021-08-09.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/collatzs/2021-08-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/collatzs/2021-08-10.png' width='270' height='270'>
</p>

You can use the `canvas_collatz()` function to make your own artwork using this algorithm.

```r
set.seed(2)
canvas_collatz(colors = '#000000', background = '#fafafa', n = 200, 
               angle.even = 0.0075, angle.odd = 0.0145, side = FALSE)
```

#### Turmite

According to [wikipedia](https://en.wikipedia.org/wiki/Turmite), a turmite is *"a Turing machine which has an orientation in addition to a current state and a "tape" that consists of an infinite two-dimensional grid of cells"*. The classic algorithm consists of repeating the three simple steps shown below. However, the algorithm in `aRtsy` is slightly modified so that the turmite does not go off the canvas, but instead bounces back onto the canvas.

1. Turn on the spot (left, right, up, or down),
2. Change the color of the block,
3. Move forward one block.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/turmites/2021-03-06.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/turmites/2021-03-09.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/turmites/2021-03-08.png' width='270' height='270'>
</p>

You can use the `canvas_turmite()` function to make your own artwork using this algorithm.

```r
set.seed(3)
canvas_turmite(colors = '#000000', background = '#fafafa', p = 0.5, 
               iterations = 1e7, width = 1500, height = 1500, noise = FALSE)
```

#### Langton's ant

According to [wikipedia](https://en.wikipedia.org/wiki/Langtons_ant), Langton's ant is a turmite with a very specific set of rules. In particular, the algorithm involves repeating the three rules shown below. Beware, the problem (or blessing) of Langton's ant is that it always moves off the canvas...

1. On a non-colored block: turn 90 degrees clockwise, un-color the block, move forward one block.
1. On a colored block: turn 90 degrees counter-clockwise, color the block, move forward one block.
1. The ant is able to cycle through different colors which correspond to different combinations of these rules.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ants/2021-03-03.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ants/2021-03-02.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ants/2021-03-01.png' width='270' height='270'>
</p>

You can use the `canvas_ant()` function to make your own artwork using this algorithm.

```r
set.seed(4)
canvas_ant(colors = '#000000', background = '#fafafa', iterations = 1e7,
           width = 200, height = 200)
```

#### Planets

We all love space, and this type of artwork puts you right between the planets. The algorithm creates one or multiple planets in space and uses a cellular automata (inspired by an idea from [Fronkonstin](https://fronkonstin.com/2021/01/02/neighborhoods-experimenting-with-cyclic-cellular-automata/)) to fill in their surfaces.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/planets/2021-02-26.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/planets/2021-02-27.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/planets/2021-02-28.png' width='270' height='270'>
</p>

You can use the `canvas_planet()` function to make your own artwork using this algorithm.

```r
# Sun behind Earth and Moon
set.seed(1)
colors <- list(c('khaki1', 'lightcoral', 'lightsalmon'),
               c('dodgerblue', 'forestgreen', 'white'), 
               c('gray', 'darkgray', 'beige'))
canvas_planet(colors, radius = c(800, 400, 150), 
              center.x = c(1, 500, 1100),
              center.y = c(1400, 500, 1000), 
              starprob = 0.005)
```

#### Stripes

This type of artwork is based on the concept of [Brownian motion](https://en.wikipedia.org/wiki/Brownian_motion). The algorithm generates a sequence of brownian motion steps on a two-dimensional surface for each row on the canvas. Next, it fills these according to their generated value. More colors usually make this artwork more interesting.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/stripes/2021-08-23.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/stripes/2021-08-24.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/stripes/2021-08-25.png' width='270' height='270'>
</p>

You can use the `canvas_stripes()` function to make your own artwork using this algorithm.

```r
set.seed(5)
canvas_stripes(colors = c('forestgreen', 'navyblue', 'goldenrod', 'firebrick'),
               n = 300, H = 1, burnin = 1)
```

### The Geometric collection

The Geometric collection mostly implements algorithms that draw a geometric shape and apply a random color to it.

#### Segments

This type of artwork mimics the style of the well-known paintings by the Dutch artist [Piet Mondriaan](https://nl.wikipedia.org/wiki/Piet_Mondriaan). The position and direction of each line segment is determined randomly.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-07.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-06.png' width='270' height='270'>
</p>

You can use the `canvas_segments()` function to make your own artwork using this algorithm.

```r
set.seed(6)
canvas_segments(colors = 'black', background = '#fafafa', n = 100, p = 0.5, H = 0.1)
```

#### Diamonds

This function creates a set of diamonds on a canvas. The diamonds are filled in using a random color assignment.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-06.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-04.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-05.png' width='270' height='270'>
</p>

You can use the `canvas_diamonds()` function to make your own artwork using this algorithm.

```r
set.seed(7)
canvas_diamonds(colors = c('forestgreen', 'navyblue', 'goldenrod', 'firebrick'), 
                background = '#fafafa', col.line = 'black', radius = 10, alpha = 1, 
                p = 0.2, width = 500, height = 500)
```

#### Squares and rectangles

This type of artwork is also a la Mondriaan, but uses a variety of squares and rectangles instead of lines. It works by repeatedly cutting into the canvas at random locations and coloring the area that these cuts create.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/squares/2021-03-01.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/squares/2021-02-28.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/squares/2021-02-29.png' width='270' height='270'>
</p>

You can use the `canvas_squares()` function to make your own artwork using this algorithm.

```r
set.seed(6)
canvas_squares(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'),
               cuts = 50, ratio = 1.618, width = 200, height = 200, noise = FALSE)
```

#### Ribbons

This function creates colored ribbons with (or without) a triangle that breaks their paths. This path of the ribbon polygon is creating by picking one point on the left side of the triangle and one point on the right side at random and using these points as nodes.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-16.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-15.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-14.png' width='270' height='270'>
</p>

You can use the `canvas_ribbons()` function to make your own artwork using this algorithm.

```r
set.seed(9)
canvas_ribbons(colors = c('forestgreen', 'firebrick', 'dodgerblue', 'goldenrod'),
               background = '#fdf5e6', triangle = TRUE)
```

#### Polylines

This function draws many points on the canvas and connects these points into a polygon. After repeating this for all the colors, the edges of all polygons are drawn on top of the artwork.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/polylines/2021-07-22.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/polylines/2021-07-23.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/polylines/2021-07-21.png' width='270' height='270'>
</p>

You can use the `canvas_polylines()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_polylines(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'), 
                 background = '#fafafa', ratio = 0.5, iterations = 1000, 
                 alpha = NULL, size = 0.1, width = 500, height = 500)
```

#### Functions

The idea for this type of artwork is taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package. In this algorithm, the position of every single point is calculated by a formula which has random parameters.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-03-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-04-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-04-04.png' width='270' height='270'>
</p>

You can use the `canvas_function()` function to make your own artwork using this algorithm.

```r
set.seed(14)
canvas_function(color = '#000000', background = '#fafafa')
```

### The Supervised collection

The artworks in the Supervised collection are inspired by decision boundary plots in machine learning tasks. The algorithms in this collection work by generating random data points on a two dimensional surface (with either a continuous or a categorical response variable), which they then try to model using the supervised learning algorithm. Next, they try to predict the color of each pixel on the canvas.

#### Mosaics

The first artwork in this collection is inspired by a supervised learning method called k-nearest neighbors. In short, the k-nearest neighbors algorithm computes the distance of each pixel on the canvas to each randomly generated data point and assigns it the color of the class of that data point. If you considers fewer neighbors the artwork looks like a mosaic, while higher values make the artwork look more smooth.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mosaics/2021-08-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mosaics/2021-08-19.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mosaics/2021-08-18.png' width='270' height='270'>
</p>

You can use the `canvas_mosaic()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_mosaic(colors = c('dodgerblue', 'forestgreen', 'white'), 
              kmax = 1, n = 1000, resolution = 500)
```

#### Forests

This artwork is inspired by a supervised learning method called random forest. It applies the same principle as described above, but uses a different predictive algorithm to fill in the color of the pixels.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/forests/2021-08-20.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/forests/2021-08-21.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/forests/2021-08-19.png' width='270' height='270'>
</p>

You can use the `canvas_forest()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_forest(colors = c('dodgerblue', 'forestgreen', 'firebrick', 'goldenrod'), 
              n = 1000, resolution = 500)
```

#### Gemstones

Returning to the previously mentioned k-nearest neighbors algorithm, this artwork uses a continuous response variable instread of a categorical one. The resulting pattern can sometimes resemble a gemstone.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/gemstones/2021-08-20.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/gemstones/2021-08-21.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/gemstones/2021-08-22.png' width='270' height='270'>
</p>

```r
set.seed(1)
canvas_gemstone(colors = c('dodgerblue', 'forestgreen', 'firebrick', 'goldenrod'), 
                n = 1000, resolution = 500)
```

You can use the `canvas_gemstone()` function to make your own artwork using this algorithm.

#### Nebula

Based on the very same principle as described in the artwork above in this next type of artwork. Howerever, it produces slightly different pictures. Sometimes these artworks can resemble nebulas in outer space.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/noise/2021-08-29.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/noise/2021-08-28.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/noise/2021-08-27.png' width='270' height='270'>
</p>

You can use the `canvas_nebula()` function to make your own artwork using this algorithm.

```r
canvas_nebula(colors = c('forestgreen', 'firebrick', 'goldenrod', 'navyblue'), k = 10)
```

#### Blacklights

This artwork is inspired by a supervised machine learning method called support vector machines. It applies the same principle as described above, but uses a different predictive algorithm to fill in the color of the pixels.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/blacklights/2021-08-22.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/blacklights/2021-08-21.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/blacklights/2021-08-20.png' width='270' height='270'>
</p>

You can use the `canvas_blacklight()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_blacklight(colors = c('dodgerblue', 'forestgreen', 'firebrick', 'goldenrod'), 
                  n = 1000, resolution = 500)
```

### The Static collection

The Static collection implements static images that produce nice pictures.

#### The Mandelbrot set

This type of artwork visualizes the [Mandelbrot set](https://en.wikipedia.org/wiki/Mandelbrot_set) fractal, a perfect example of a complex structure arising from the application of simple rules. You can zoom in on the set and apply some color to create these nice images.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mandelbrots/2021-08-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mandelbrots/2021-08-09.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mandelbrots/2021-08-07.png' width='270' height='270'>
</p>

You can use the `canvas_mandelbrot()` function to make your own artwork using this algorithm.

```r
canvas_mandelbrot(colors = c('forestgreen', 'firebrick', 'goldenrod', 'navyblue'), zoom = 10)
```

#### Circle maps

This type of artwork is based on the concept of an [Arnold tongue](https://en.wikipedia.org/wiki/Arnold_tongue). According to wikipedia, Arnold tongues *"are a pictorial phenomenon that occur when visualizing how the rotation number of a dynamical system, or other related invariant property thereof, changes according to two or more of its parameters"*.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/circlemaps/2021-04-22b.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/circlemaps/2021-04-22c.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/circlemaps/2021-04-22a.png' width='270' height='270'>
</p>

You can use the `canvas_circlemap()` function to make your own artwork using this algorithm.

```r
canvas_circlemap(colors = c('forestgreen', 'firebrick', 'goldenrod', 'navyblue'),
                 x_min = 0, x_max = 12.56, y_min = 0, y_max = 1, 
                 iterations = 10, width = 1500, height = 1500)
```

## Color palettes

The function `colorPalette()` can be used to generate a random color palette, or pick a pre-implemented color palette. Currently, the color palettes displayed below are implemented in `aRtsy`. Feel free to suggest or add a new palette!

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/man/figures/colors.svg'>
</p>