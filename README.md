[![CRAN](https://img.shields.io/cran/v/aRtsy?color=yellow&label=CRAN&logo=r)](https://cran.r-project.org/package=aRtsy)
[![R_build_status](https://github.com/koenderks/aRtsy/workflows/Build/badge.svg)](https://github.com/koenderks/aRtsy/actions)
[![Codecov](https://codecov.io/gh/koenderks/aRtsy/branch/development/graph/badge.svg?token=ZoxIB8p8PW)](https://codecov.io/gh/koenderks/aRtsy)
[![Bugs](https://img.shields.io/github/issues/koenderks/aRtsy/bug?label=Bugs&logo=github&logoColor=%23FFF&color=brightgreen)](https://github.com/koenderks/aRtsy/issues?q=is%3Aopen+is%3Aissue+label%3Abug)
[![Monthly](https://cranlogs.r-pkg.org/badges/aRtsy?color=blue)](https://cranlogs.r-pkg.org)
[![Total](https://cranlogs.r-pkg.org/badges/grand-total/aRtsy?color=blue)](https://cranlogs.r-pkg.org)

# aRtsy: Generative Art with `R` and `ggplot2`

<img src='https://github.com/koenderks/aRtsy/raw/development/man/figures/logo.png' width='149' height='173' alt='logo' align='right' margin-left='20' margin-right='20'/>

*"Why would anyone want to make art using computers?" - Marcus du Sautoy, The Creative Code*

`aRtsy` is an attempt at making generative art available for the masses in a simple and standardized format. The package combines several algorithms for creating artworks in `ggplot2` that incorporate some form of randomness (depending on the set `seed`). Each type of artwork is implemented in a separate function.

Contributions to `aRtsy` are very much appreciated! If you want to add your own type of artwork to the package so that others can use them, feel free to make a pull request to the [GitHub repository](https://github.com/koenderks/aRtsy). Don't forget to adjust [generate-artwork.R](https://github.com/koenderks/aRtsy/blob/development/.github/workflows/generate_artwork.R) if you also want the artwork to show up in the 'Artwork of the day' category and the twitter feed.

Good luck hunting for some good `seed`'s!

## Artwork of the day

Every 24 hours this repository generates a random artwork using the `aRtsy` package. This is today's artwork:

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/daily.png' width='400' height='400'>
</p>

The full collection of daily artworks is available on the [aRtsy twitter feed](https://twitter.com/aRtsy_package).

## Installation

You can download the `aRtsy` package from GitHub using:

```r
devtools::install_github('koenderks/aRtsy')
```

After installation, the `aRtsy` package can be loaded with:

```r
library(aRtsy)
```

## Available artworks

* [`canvas_strokes()`](#paint-strokes)
* [`canvas_ribbons()`](#ribbons)
* [`canvas_polylines()`](#polylines)
* [`canvas_turmite()`](#turmite)
* [`canvas_ant()`](#langtons-ant)
* [`canvas_planet()`](#planets)
* [`canvas_diamonds()`](#diamonds)
* [`canvas_mondriaan()`](#mondriaan)
* [`canvas_cirlemap()`](#circle-maps)
* [`canvas_function()`](#functions)

## Paint strokes

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
               width = 500, height = 500, side = FALSE))
```

## Ribbons

This function creates colored ribbons with (or without) a triangle that breaks their paths. This path of the ribbon polygon is creating by picking one point on the left side of the triangle and one point on the right side at random and using these points as nodes.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-16.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-15.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/ribbons/2021-07-14.png' width='270' height='270'>
</p>

You can use the `canvas_ribbons()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_ribbons(colors = c("forestgreen", "firebrick", "dodgerblue", "goldenrod"),
               background = '#fdf5e6', triangle = TRUE)
```

## Polylines

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

## Turmite

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
set.seed(1)
canvas_turmite(color = "#000000", background = "#fafafa", p = 0.5, 
               iterations = 1e7, width = 1500, height = 1500)
```

## Langton's ant

According to [wikipedia](https://en.wikipedia.org/wiki/Langton%27s_ant), Langton's ant is a turmite with a very specific set of rules. In particular, the algorithm involves repeating the three rules shown below. Beware, the problem (or blessing) of Langton's ant is that it always moves off the canvas...

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
canvas_ant(colors = '#000000', background = '#fafafa', iterations = 1e7,
           width = 200, height = 200)
```

## Planets

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
colors <- list(c("khaki1", "lightcoral", "lightsalmon"),
               c("dodgerblue", "forestgreen", "white"), 
               c("gray", "darkgray", "beige"))
canvas_planet(colors, radius = c(800, 400, 150), 
              center.x = c(1, 500, 1100),
              center.y = c(1400, 500, 1000), 
              starprob = 0.005)
```

## Diamonds

This function creates a set of diamonds on a canvas. The diamonds are filled in using a random color assignment.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-06.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-04.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/diamonds/2021-08-05.png' width='270' height='270'>
</p>

You can use the `canvas_diamonds()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_diamonds(colors = c("forestgreen", "navyblue", "goldenrod", "firebrick"), 
                background = '#fafafa', col.line = 'black', radius = 10, alpha = 1, 
                size = 0.25, p = 0.2, width = 500, height = 500)
```

## Mondriaan

This type of artwork mimics the style of the well-known paintings by the Dutch artist [Piet Mondriaan](https://nl.wikipedia.org/wiki/Piet_Mondriaan). It works by repeatedly cutting into the canvas at random locations and coloring the square that these cuts create.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mondriaans/2021-03-01.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mondriaans/2021-02-28.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/mondriaans/2021-02-29.png' width='270' height='270'>
</p>

You can use the `canvas_mondriaan()` function to make your own artwork using this algorithm.

```r
set.seed(6)
canvas_mondriaan(colors = c('forestgreen', 'goldenrod', 'firebrick', 'navyblue'),
                 cuts = 50, ratio = 1.618, width = 100, height = 100)
```

## Segments

This type of artwork is also a la Mondriaan, but uses a variety of lines instead of squares. The position and direction of each line segment is determined randomly.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-07.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/segments/2021-08-06.png' width='270' height='270'>
</p>

You can use the `canvas_segments()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_segments(colors = 'black', background = '#fafafa', n = 100, H = 0.1)
```

## Circle maps

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

## Functions

The idea for this type of artwork is taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package. In this algorithm, the position of every single point is calculated by a formula which has random parameters.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-03-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-04-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/development/png/functions/2021-04-04.png' width='270' height='270'>
</p>

You can use the `canvas_function()` function to make your own artwork using this algorithm.

```r
set.seed(1)
canvas_function(color = '#000000', background = '#fafafa')
```
