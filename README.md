[![CRAN](https://img.shields.io/cran/v/aRtsy?color=yellow&label=CRAN&logo=r)](https://cran.r-project.org/package=aRtsy)
[![R_build_status](https://github.com/koenderks/aRtsy/workflows/Build/badge.svg)](https://github.com/koenderks/aRtsy/actions)
[![Codecov](https://codecov.io/gh/koenderks/aRtsy/branch/master/graph/badge.svg?token=ZoxIB8p8PW)](https://codecov.io/gh/koenderks/aRtsy)
[![Bugs](https://img.shields.io/github/issues/koenderks/aRtsy/bug?label=Bugs&logo=github&logoColor=%23FFF&color=brightgreen)](https://github.com/koenderks/aRtsy/issues?q=is%3Aopen+is%3Aissue+label%3Abug)
[![Monthly](https://cranlogs.r-pkg.org/badges/aRtsy?color=blue)](https://cranlogs.r-pkg.org)
[![Total](https://cranlogs.r-pkg.org/badges/grand-total/aRtsy?color=blue)](https://cranlogs.r-pkg.org)

# aRtsy: Generative Art with `R` and `ggplot2`

`aRtsy` is an attempt at making generative art available for the masses in a simple and standardized format. The package combines several algorithms for creating paintings in `ggplot2` that have the potential to be different (often depending on their `seed`). Each type of algorithm is implemented in a separate function.

Contributions to `aRtsy` are much appreciated. Good luck hunting for some great `seed`'s!

## Painting of the day

Every day this repository generates a random painting using the `aRtsy` package. This is today's painting:

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/daily.png' width='400' height='400'>
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

## Overview

* [`paint_strokes()`](#paint-strokes)
* [`paint_ribbons()`](#paint-ribbons)
* [`paint_turmite()`](#paint-turmite)
* [`paint_ant()`](#paint-ant)
* [`paint_planet()`](#paint-planets)
* [`paint_mondriaan()`](#paint-mondriaan)
* [`paint_cirlemap()`](#paint-circle-maps)
* [`paint_function()`](#paint-function)

## Paint strokes

When you think of the act of painting, you probably imagine stroking paint on a canvas. This type of painting tries to mimic that activity. The paint strokes algorithm is based on the simple idea that each next point on a grid-based canvas has a chance to take over the color of an adjacent colored point, but also has a minor change of generating a new color. Going over the canvas like this results in strokes of paint.

You can use the `paint_strokes()` function to make your own painting using this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-21.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-20.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-10.png' width='270' height='270'>
</p>

## Paint ribbons

This function paints colored ribbons with (or without) a triangle that breaks their paths. This path of the ribbon polygon is creating by picking one point on the left side of the triangle and one point on the right side at random and using these points as nodes.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ribbons/2021-07-16.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ribbons/2021-07-15.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ribbons/2021-07-14.png' width='270' height='270'>
</p>

## Paint turmite

According to [wikipedia](https://en.wikipedia.org/wiki/Turmite), a turmite is *a Turing machine which has an orientation in addition to a current state and a "tape" that consists of an infinite two-dimensional grid of cells*. The classic algorithm consists of repeating the three simple steps shown below. However, the algorithm in `aRtsy` is slightly modified so that the block does not go off the canvas, but instead bounces back onto the canvas.

1. Turn on the spot (left, right, up, or down),
2. Change the color of the block,
3. Move forward one block.

You can use the `paint_turmite()` function to make your own painting using this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-06.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-09.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-08.png' width='270' height='270'>
</p>

## Paint ant

According to [wikipedia](https://en.wikipedia.org/wiki/Langton%27s_ant), Langton's ant is a turmite with a very specific set of rules. In particular, the algorithm involves repeating the three rules shown below. The problem with this type of painting is that it always moves off the canvas though...

1. On a non-colored block: turn 90 degrees clockwise, un-color the block, move forward one block.
1. On a colored block: turn 90 degrees counter-clockwise, color the block, move forward one block.
1. The ant is able to cycle through different colors which correspond to different combinations of these rules.

You can use the `paint_ant()` function to make your own painting using this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-03.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-02.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-01.png' width='270' height='270'>
</p> 

## Paint planets

We all love space and this type of painting puts you right between the planets. The algorithm creates one or multiple planets in space and uses a cellular automata (inspired by an idea from [Fronkonstin](https://fronkonstin.com/2021/01/02/neighborhoods-experimenting-with-cyclic-cellular-automata/)) to fill in their surfaces.

You can use the `paint_planet()` function to make your own painting using this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/planets/2021-02-26.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/planets/2021-02-27.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/planets/2021-02-28.png' width='270' height='270'>
</p>

## Paint Mondriaan

This type of painting mimics the style of the well-known paintings by the Dutch artist [Piet Mondriaan](https://nl.wikipedia.org/wiki/Piet_Mondriaan). It works by repeatedly cutting into the canvas at random locations and coloring the square that these cuts create.

You can use the `paint_mondriaan()` function to make your own painting using this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/mondriaans/2021-03-01.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/mondriaans/2021-02-28.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/mondriaans/2021-02-29.png' width='270' height='270'>
</p> 

## Paint circle maps

This type of painting is based on the concept of an [Arnold tongue](https://en.wikipedia.org/wiki/Arnold_tongue).

You can use the `paint_circlemap()` function to make your own painting using this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/circlemaps/2021-04-22b.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/circlemaps/2021-04-22c.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/circlemaps/2021-04-22a.png' width='270' height='270'>
</p> 

## Paint function

The idea for this type of painting is taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package. In this algorithm, the position of every single point is calculated by a formula which has random parameters.

You can use the `paint_function()` function to make your own painting using this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-03-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-04-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-04-04.png' width='270' height='270'>
</p>