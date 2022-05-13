[![CRAN](https://img.shields.io/cran/v/aRtsy?color=yellow&label=CRAN&logo=r)](https://cran.r-project.org/package=aRtsy)
[![R_build_status](https://github.com/koenderks/aRtsy/workflows/Build/badge.svg)](https://github.com/koenderks/aRtsy/actions)
[![Codecov](https://codecov.io/gh/koenderks/aRtsy/branch/development/graph/badge.svg?token=ZoxIB8p8PW)](https://app.codecov.io/gh/koenderks/aRtsy)
[![Bugs](https://img.shields.io/github/issues/koenderks/aRtsy/bug?label=Bugs&logo=github&logoColor=%23FFF&color=brightgreen)](https://github.com/koenderks/aRtsy/issues?q=is%3Aopen+is%3Aissue+label%3Abug)
[![Total](https://cranlogs.r-pkg.org/badges/grand-total/aRtsy?color=blue)](https://cranlogs.r-pkg.org)

# aRtsy: Generative Art with `R` and `ggplot2`

<img src='https://github.com/koenderks/aRtsy/raw/development/man/figures/logo.png' width='149' height='173' alt='logo' align='right' margin-left='20' margin-right='20'/>

*"If you laugh at a joke, what difference does it make if subsequently you are told that the joke was created by an algorithm?" - Marcus du Sautoy, The Creative Code*

`aRtsy` aims to make generative art accessible to the general public in a straightforward and standardized manner. The package provides algorithms for creating artworks that incorporate some form of randomness and are dependent on the set `seed`. Each algorithm is implemented in a separate function with its own set of parameters that can be tweaked.

Good luck hunting for some good `seed`'s!

## Artwork of the day

Every 24 hours this repository randomly generates and tweets an artwork from the `aRtsy` library. The full collection of daily artworks is available on the [aRtsy twitter feed](https://twitter.com/aRtsy_package). This is today's artwork:

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/daily.png' width='400' height='400'>
</p>

## Installation

The most recently released version of `aRtsy` can be downloaded from [CRAN](https://cran.r-project.org/package=aRtsy) by running the following command in R:

```r
install.packages("aRtsy")
```

Alternatively, you can download the development version from GitHub using:

```r
devtools::install_github("koenderks/aRtsy")
```

After installation, the `aRtsy` package can be loaded with:

```r
library(aRtsy)
```

**Note:** Render times in RStudio can be quite long for some artworks. It is therefore recommended that you save the artwork to a file (e.g., `.png` or `.jpg`) before viewing it. You can save the artwork in an appropriate size and quality using the `saveCanvas()` function.

```r
artwork <- canvas_strokes(colors = c("black", "white"))
saveCanvas(artwork, filename = "myArtwork.png")
```

## Available artworks

*The Iterative collection*

* [`canvas_ant()`](#langtons-ant)
* [`canvas_cobweb()`](#cobwebs)
* [`canvas_collatz()`](#collatz-conjecture)
* [`canvas_chladni()`](#chladni-figures)
* [`canvas_flow()`](#flow-fields)
* [`canvas_maze()`](#mazes)
* [`canvas_petri()`](#petri-dishes)
* [`canvas_planet()`](#planets)
* [`canvas_splits()`](#split-lines)
* [`canvas_stripes()`](#stripes)
* [`canvas_strokes()`](#paint-strokes)
* [`canvas_phyllotaxis()`](#phyllotaxis)
* [`canvas_recaman()`](#recamáns-sequence)
* [`canvas_turmite()`](#turmite)
* [`canvas_watercolors()`](#watercolors)

*The Geometric collection*

* [`canvas_diamonds()`](#diamonds)
* [`canvas_function()`](#functions)
* [`canvas_polylines()`](#polylines)
* [`canvas_ribbons()`](#ribbons)
* [`canvas_segments()`](#segments)
* [`canvas_squares()`](#squares-and-rectangles)

*The Supervised collection*

* [`canvas_blacklight()`](#blacklights)
* [`canvas_forest()`](#forests)
* [`canvas_gemstone()`](#gemstones)
* [`canvas_mosaic()`](#mosaics)
* [`canvas_nebula()`](#Nebula)

*The Static collection*

* [`canvas_circlemap()`](#circle-maps)
* [`canvas_mandelbrot()`](#the-mandelbrot-set)

### The Iterative collection

The Iterative collection implements algorithms whose state depend on the previous state. These algorithms mostly use a grid based canvas to draw on. On this grid, each point represents a pixel of the final image. By assigning a color to these points according to certain rules, one can create the images in this collection.

#### Langton's ant

According to [Wikipedia](https://en.wikipedia.org/wiki/Langtons_ant), Langton's ant is a turmite with a very specific set of rules. In particular, after choosing a starting position the algorithm involves repeating the following three rules:

1. On a non-colored block: turn 90 degrees clockwise, un-color the block, move forward one block,
1. On a colored block: turn 90 degrees counter-clockwise, color the block, move forward one block,
1. If a certain number of iterations has passed, choose a different color which corresponds to a different combination of these rules.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ants/2021-03-03.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ants/2021-03-02.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ants/2021-03-01.png' width='250' height='250'>
</p>

You can use the `canvas_ant()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_ant(colors = colorPalette("house"))
# see ?canvas_ant for more input parameters of this function
```

#### Cobwebs

This function draws a lines in a structure that resemble cobwebs. The algorithm creates many [Fibonacci spirals](https://en.wikipedia.org/wiki/Golden_spiral) shifted by random noise from a normal distribution.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/cobwebs/2021-11-05.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/cobwebs/2021-11-07.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/cobwebs/2021-11-06.png' width='250' height='250'>
</p>

You can use the `canvas_cobweb()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_cobweb(colors = colorPalette("tuscany1"))
# see ?canvas_cobweb for more input parameters of this function
```

#### Collatz conjecture

The Collatz conjecture is also known as the `3x+1` equation. The algorithm draws lines according to a simple rule set:

1. Take a random positive number.
2. If the number is even, divide it by 2.
3. If the number is odd, multiply the number by 3 and add 1.
4. Repeat to get a sequence of numbers.

By visualizing the sequence for each number, overlaying sequences that are the same, and bending the edges differently for even and odd numbers in the sequence, organic looking structures can occur.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/collatzs/2021-08-09.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/collatzs/2021-08-08.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/collatzs/2021-08-10.png' width='250' height='250'>
</p>

You can use the `canvas_collatz()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_collatz(colors = colorPalette("tuscany3"))
# see ?canvas_collatz for more input parameters of this function
```

#### Chladni figures

This function draws [Chladni](https://en.wikipedia.org/wiki/Ernst_Chladni) figures on the canvas. It works by generating one or multiple sine waves on a square matrix. You can provide the waves to be added yourself. After generating the waves it is possible to warp them using a [domain warping](https://iquilezles.org/articles/warp/) technique. The angles and distances for the warp can be set manually or according to a type of noise.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/chladnis/2021-11-12.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/chladnis/2021-11-13.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/chladnis/2021-11-14.png' width='250' height='250'>
</p>

You can use the `canvas_chladni()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_chladni(colors = colorPalette("tuscany1"))
# see ?canvas_chladni for more input parameters of this function
```

#### Flow fields

This artwork implements a version of the algorithm described in the blog post [Flow Fields](https://tylerxhobbs.com/essays/2020/flow-fields) by Tyler Hobbs. It works by creating a grid of angles and determining how certain points will flow through this field. The angles in the field can be set manually or according to the predictions of a supervised learning method trained on randomly generated data.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/flows/2021-09-24.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/flows/2021-09-23.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/flows/2021-09-22.png' width='250' height='250'>
</p>

You can use the `canvas_flow()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_flow(colors = colorPalette("dark2"))
# see ?canvas_flow for more input parameters of this function
```

#### Mazes

This artwork creates mazes. The mazes are created using a random walk algorithm (described in the [mazegenerator](https://github.com/matfmc/mazegenerator) repository). The mazes can also be displayed with polar coordinates, creating some pretty cool effects.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mazes/2021-10-03.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mazes/2021-10-02.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mazes/2021-10-04.png' width='250' height='250'>
</p>

You can use the `canvas_maze()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_maze(color = "#fafafa")
# see ?canvas_maze for more input parameters of this function
```

#### Petri dishes

This artwork uses a space colonization algorithm (excellently described in [this blogpost](https://medium.com/@jason.webb/space-colonization-algorithm-in-javascript-6f683b743dc5) by Jason Webb) to draw Petri dish colonies. If you add a hole in the middle of the Petri dish, the colony grows around the hole.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/petris/2022-04-04.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/petris/2022-04-06.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/petris/2022-04-05.png' width='250' height='250'>
</p>

You can use the `canvas_petri()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_petri(colors = colorPalette("sooph"))
# see ?canvas_petri for more input parameters of this function
```

#### Planets

We all love space, and this type of artwork puts you right between the planets. The algorithm creates one or multiple planets in space and uses a cellular automata (described in the blog post [Neighborhoods: Experimenting with Cyclic Cellular Automata](https://fronkonstin.com/2021/01/02/neighborhoods-experimenting-with-cyclic-cellular-automata/) by Antonio Sánchez Chinchón) to fill in their surfaces. The color and placement of the planets can be set manually.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/planets/2021-02-26.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/planets/2021-02-27.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/planets/2021-02-28.png' width='250' height='250'>
</p>

You can use the `canvas_planet()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_planet(colors = colorPalette("retro3"))
# see ?canvas_planet for more input parameters of this function
```

#### Split Lines

This function generates a [fractal curve](https://en.wikipedia.org/wiki/Fractal_curve). It starts with four simple lines and proceeds to split each line in four new line segments. If this action is repeated for some time, and each time the same split is made, the end product is a fractal curve. The fractal curve in this function (optionally) uses some noise to create random distortions in the curve.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/splits/2022-05-03.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/splits/2022-05-01.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/splits/2022-05-02.png' width='250' height='250'>
</p>

You can use the `canvas_splits()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_splits(colors = colorPalette("origami"))
# see ?canvas_splits for more input parameters of this function
```

#### Stripes

This type of artwork is based on the concept of [Brownian motion](https://en.wikipedia.org/wiki/Brownian_motion). The algorithm generates a sequence of slightly increasing and decreasing values for each row on the canvas. Next, it fills these according to their generated value. More colors usually make this artwork more interesting.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/stripes/2021-08-23.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/stripes/2021-08-24.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/stripes/2021-08-25.png' width='250' height='250'>
</p>

You can use the `canvas_stripes()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_stripes(colors = colorPalette("random", n = 10))
# see ?canvas_stripes for more input parameters of this function
```

#### Paint strokes

When you think of the act of painting, you probably imagine stroking paint on a canvas. This type of artwork tries to mimic that activity. The algorithm is based on the simple idea that each next point on a grid-based canvas has a chance to take over the color of an adjacent colored point, but also has a minor chance of generating a new color. Going over the canvas like this results in something that looks like strokes of paint.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/strokes/2021-03-21.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/strokes/2021-03-20.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/strokes/2021-03-10.png' width='250' height='250'>
</p>

You can use the `canvas_strokes()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_strokes(colors = colorPalette("tuscany1"))
# see ?canvas_strokes for more input parameters of this function
```

#### Phyllotaxis

This function draws a [Phyllotaxis](https://en.wikipedia.org/wiki/Phyllotaxis) on the canvas. This structure represents the arrangement of leaves on a plant stem.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/phyllotaxis/2021-11-05.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/phyllotaxis/2021-11-03.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/phyllotaxis/2021-11-04.png' width='250' height='250'>
</p>

You can use the `canvas_phyllotaxis()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_phyllotaxis(colors = colorPalette("tuscany1"))
# see ?canvas_phyllotaxis for more input parameters of this function
```

#### Recamán's Sequence

This function draws Recamán's sequence on a canvas. The algorithm takes increasingly large steps backwards on the positive number line, but takes a step forward if it is unable to perform the step backwards.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/recamans/2021-11-02.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/recamans/2021-11-03.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/recamans/2021-11-04.png' width='250' height='250'>
</p>

You can use the `canvas_recaman()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_recaman(colors = colorPalette("random", n = 10))
# see ?canvas_recaman for more input parameters of this function
```

#### Turmite

According to [Wikipedia](https://en.wikipedia.org/wiki/Turmite), a turmite is *"a Turing machine which has an orientation in addition to a current state and a "tape" that consists of an infinite two-dimensional grid of cells"*. The classic algorithm consists of repeating the following three simple steps:

1. Turn on the spot (left, right, up, or down),
2. Change the color of the block,
3. Move forward one block.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/turmites/2021-03-06.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/turmites/2021-03-09.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/turmites/2021-03-08.png' width='250' height='250'>
</p>

You can use the `canvas_turmite()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_turmite(colors = colorPalette("dark2"))
# see ?canvas_turmite for more input parameters of this function
```

#### Watercolors

This artwork implements a version of the algorithm described in the blog post [A Guide to Simulating Watercolor Paint with Generative Art](https://tylerxhobbs.com/essays/2017/a-generative-approach-to-simulating-watercolor-paints) by Tyler Hobbs. It works by layering several geometric shapes and deforming each shape by repeatedly splitting its edges.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/watercolors/2021-09-23.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/watercolors/2021-09-22.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/watercolors/2021-09-21.png' width='250' height='250'>
</p>

You can use the `canvas_watercolors()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_watercolors(colors = colorPalette("tuscany2"))
# see ?canvas_watercolors for more input parameters of this function
```

### The Geometric collection

The Geometric collection mostly implements algorithms that draw a geometric shape and apply a random color to it.

#### Diamonds

This function creates a set of diamonds on a canvas. The diamonds are filled in (or left out) using a random color assignment.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-06.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-04.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-05.png' width='250' height='250'>
</p>

You can use the `canvas_diamonds()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_diamonds(colors = colorPalette("tuscany1"))
# see ?canvas_diamonds for more input parameters of this function
```

#### Functions

The idea for this type of artwork is taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package. In this algorithm, the position of every single point is calculated by a formula which has random parameters. You can supply your own formula.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-03-17.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-04-08.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-04-04.png' width='250' height='250'>
</p>

You can use the `canvas_function()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_function(colors = colorPalette("tuscany1"))
# see ?canvas_function for more input parameters of this function
```

#### Polylines

This function draws many points on the canvas and connects these points into a polygon. After repeating this for all the colors, the edges of all polygons are drawn on top of the artwork.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/polylines/2021-07-22.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/polylines/2021-07-23.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/polylines/2021-07-21.png' width='250' height='250'>
</p>

You can use the `canvas_polylines()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_polylines(colors = colorPalette("retro1"))
# see ?canvas_polylines for more input parameters of this function
```

#### Ribbons

This function creates colored ribbons with (or without) a triangle that breaks their paths. This path of the ribbon polygon is creating by picking one point on the left side of the triangle and one point on the right side at random and using these points as nodes.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-16.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-15.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-14.png' width='250' height='250'>
</p>

You can use the `canvas_ribbons()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_ribbons(colors = colorPalette("retro1")
# see ?canvas_ribbons for more input parameters of this function
```

#### Segments

This type of artwork is inspired by the style of the well-known paintings by the Dutch artist [Piet Mondriaan](https://nl.wikipedia.org/wiki/Piet_Mondriaan). The position and direction of each line segment is determined randomly.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-07.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-08.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-06.png' width='250' height='250'>
</p>

You can use the `canvas_segments()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_segments(colors = colorPalette("dark1"))
# see ?canvas_segments for more input parameters of this function
```

#### Squares and rectangles

This artwork uses a variety of squares and rectangles to fill the canvas. It works by repeatedly cutting into the canvas at random locations and coloring the area that these cuts create.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/squares/2021-03-01.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/squares/2021-02-28.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/squares/2021-02-29.png' width='250' height='250'>
</p>

You can use the `canvas_squares()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_squares(colors = colorPalette("retro2"))
# see ?canvas_squares for more input parameters of this function
```

### The Supervised collection

The artworks in the Supervised collection are inspired by decision boundary plots in machine learning tasks. The algorithms in this collection work by generating random data points on a two dimensional surface (with either a continuous or a categorical response variable), which they then try to model using the supervised learning algorithm. Next, they try to predict the color of each pixel on the canvas.

#### Blacklights

This artwork is inspired by a supervised machine learning method called support vector machines. It applies the principle as described above using a continuous response variable to fill the color of the pixels.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/blacklights/2021-08-22.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/blacklights/2021-08-21.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/blacklights/2021-08-20.png' width='250' height='250'>
</p>

You can use the `canvas_blacklight()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_blacklight(colors = colorPalette("random", n = 5))
# see ?canvas_blacklight for more input parameters of this function
```

#### Forests

This artwork is inspired by a supervised learning method called random forest. It applies the principle as described above using a continuous response variable to fill the color of the pixels.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/forests/2021-08-20.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/forests/2021-08-21.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/forests/2021-08-19.png' width='250' height='250'>
</p>

You can use the `canvas_forest()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_forest(colors = colorPalette("jungle"))
# see ?canvas_forest for more input parameters of this function
```

#### Gemstones

This artwork is inspired by a supervised learning method called k-nearest neighbors. It applies the principle as described above using a continuous response variable to fill the color of the pixels. In short, the k-nearest neighbors algorithm computes the distance of each pixel on the canvas to each randomly generated data point and assigns it the color of the value of that data point.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/gemstones/2021-08-20.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/gemstones/2021-08-21.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/gemstones/2021-08-22.png' width='250' height='250'>
</p>

You can use the `canvas_gemstone()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_gemstone(colors = colorPalette("dark3"))
# see ?canvas_gemstone for more input parameters of this function
```

#### Mosaics

This artwork also uses a k-nearest neighbors method but instead of a continuous response variable a categorical one is used, making it a classification problem. If you considers fewer neighbors the artwork looks like a mosaic, while higher values make the artwork look more smooth.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mosaics/2021-08-17.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mosaics/2021-08-19.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mosaics/2021-08-18.png' width='250' height='250'>
</p>

You can use the `canvas_mosaic()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_mosaic(colors = colorPalette("retro2"))
# see ?canvas_mosaic for more input parameters of this function
```

#### Nebula

Based on the very same principle as described in the artwork above is this next type of artwork. However, it produces slightly different pictures as it uses different code to create a form of k-nearest neighbors noise. Some of these artworks can resemble nebulas in outer space.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/nebulas/2021-08-29.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/nebulas/2021-08-28.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/nebulas/2021-08-27.png' width='250' height='250'>
</p>

You can use the `canvas_nebula()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_nebula(colors = colorPalette("tuscany1"))
# see ?canvas_nebula for more input parameters of this function
```

### The Static collection

The Static collection implements static images that produce nice pictures.

#### Circle maps

This type of artwork is based on the concept of an [Arnold tongue](https://en.wikipedia.org/wiki/Arnold_tongue). According to Wikipedia, Arnold tongues *"are a pictorial phenomenon that occur when visualizing how the rotation number of a dynamical system, or other related invariant property thereof, changes according to two or more of its parameters"*.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/circlemaps/2021-04-22b.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/circlemaps/2021-04-22c.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/circlemaps/2021-04-22a.png' width='250' height='250'>
</p>

You can use the `canvas_circlemap()` function to make your own artwork using this algorithm.

```r
canvas_circlemap(colors = colorPalette("dark2"))
# see ?canvas_circlemap for more input parameters of this function
```

#### The Mandelbrot set

This type of artwork visualizes the [Mandelbrot set](https://en.wikipedia.org/wiki/Mandelbrot_set) fractal, a perfect example of a complex structure arising from the application of simple rules. You can zoom in on the set and apply some color to create these nice images.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mandelbrots/2021-08-08.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mandelbrots/2021-08-09.png' width='250' height='250'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mandelbrots/2021-08-07.png' width='250' height='250'>
</p>

You can use the `canvas_mandelbrot()` function to make your own artwork using this algorithm.

```r
canvas_mandelbrot(colors = colorPalette("tuscany1"))
# see ?canvas_mandelbrot for more input parameters of this function
```

## Color palettes

The function `colorPalette()` can be used to generate a (semi-)random color palette, or pick a pre-implemented color palette. Currently, the color palettes displayed below are implemented in `aRtsy`. Feel free to suggest or add a new palette by making an [issue](https://github.com/koenderks/aRtsy/issues) on GitHub!

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/man/figures/colors.svg'>
</p>

## Contributing to the `aRtsy` package

Contributions to the `aRtsy` package are very much appreciated and you are free to suggest or add your own algorithms! If you want to add your own artwork to the package so that others can create unique versions of it, feel free to make a pull request to the [GitHub repository](https://github.com/koenderks/aRtsy). Don't forget to also adjust [generate-artwork.R](https://github.com/koenderks/aRtsy/blob/development/.github/workflows/generate_artwork.R) if you want the artwork to show up in the 'Artwork of the day' category and the twitter feed.
