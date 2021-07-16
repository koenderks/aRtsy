# aRtsy: Generative Art Using R

`aRtsy` is an R package that mimicks the ideas of multiple generative artists in the `ggplot2` language.

You can install and load the package by running the code below.

```
devtools::install_github('koenderks/aRtsy')
library(aRtsy)
```

Let's go hunting for some good `seed`'s!

## Overview

* [Painting of the day](#painting-of-the-day)
* [`paint_strokes()`](#paint-strokes)
* [`paint_turmite()`](#turmite)
* [`paint_ant()`](#langtons-ant)
* [`paint_planet()`](#planets)
* [`paint_mondriaan()`](#mondriaan)
* [`paint_cirlemap()`](#circle-maps)
* [`paint_arcs()`](#arcs)
* [`paint_function()`](#functions)

## Painting of the day

Every day this repository generates a random painting with the `aRtsy` package. This is today's painting:

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/daily.png' width='400' height='400'>
</p>

## Paint strokes

The `paint_strokes` algorithm is my first self-concocted algorithm for generative drawing on a grid-based canvas. This algorithm is based on the simple idea that each next point on the grid has a chance to take over the color of an adjacent colored point but also has a change of generating a new color. Going over the grid like this apparently results in these paint-like strokes on the canvas.

You can use the `paint_strokes()` function to make your own unique painting with this algorithm. 

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-21.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-25.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-20.png' width='270' height='270'>
</p>

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-11.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-12.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/strokes/2021-03-10.png' width='270' height='270'>
</p>

## Turmite

According to [wikipedia](https://en.wikipedia.org/wiki/Turmite), a turmite is *a Turing machine which has an orientation in addition to a current state and a "tape" that consists of an infinite two-dimensional grid of cells*. Basically, it's a moving block. The algorithm consists of the following three simple steps that are repeated, but I've added some logic so that the block does not go off the canvas. 

1. Turn on the spot (left, right, up, or down),
1. Change the color of the block,
1. Move forward one block.

You can use the `paint_turmite()` function to make your own unique painting with this algorithm. 

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-06.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-09.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-08.png' width='270' height='270'>
</p>

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-07.png' width='1000' height='270'>
</p>

## Langton's ant

According to [wikipedia](https://en.wikipedia.org/wiki/Langton%27s_ant), Langton's ant is a turmite with a very specific set of rules. In particular, it moves according to the three rules below. Langton's ant reminds me of a crayon painting. The problem with this thing is that it always moves off the canvas though...

1. On a non-colored block: turn 90 degrees clockwise, un-color the block, move forward one block.
1. On a colored block: turn 90 degrees counter-clockwise, color the block, move forward one block.
1. The ant is able to cycle through different colors which correspond to different combinations of these rules.

You can use the `paint_ant()` function to make your own unique painting with this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-03.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-02.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-01.png' width='270' height='270'>
</p> 

## Planets

This algorithm paints one or multiple planets in space and uses a cellular automata (inspired by an idea from [Fronkonstin](https://fronkonstin.com/2021/01/02/neighborhoods-experimenting-with-cyclic-cellular-automata/)) to fill in their surfaces.

You can use the `paint_planet()` function to make your own unique painting with this algorithm. 

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/planets/2021-02-26.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/planets/2021-02-27.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/planets/2021-02-28.png' width='270' height='270'>
</p>

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/planets/2021-02-29.png' width='800' height='225'>
</p>

## Mondriaan

This algorithm mimics the style of the well-known paintings by the Dutch artist [Piet Mondriaan](https://nl.wikipedia.org/wiki/Piet_Mondriaan). It works by repeatedly cutting into the canvas at random locations and coloring the square that these cuts create.

You can use the `paint_mondriaan()` function to make your own unique painting with this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/mondriaans/2021-03-01.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/mondriaans/2021-02-28.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/mondriaans/2021-02-29.png' width='270' height='270'>
</p> 

## Circle maps

This next painting is based on the concept of an [Arnold tongue](https://en.wikipedia.org/wiki/Arnold_tongue).

You can use the `paint_circlemap()` function to make your own unique painting with this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/circlemaps/2021-04-22b.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/circlemaps/2021-04-22c.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/circlemaps/2021-04-22a.png' width='270' height='270'>
</p> 

## Arcs

Inspired by the work of [@ijeamaka_a](https://twitter.com/ijeamaka_a), I wanted to make my own version of her beautiful [Arc Series](https://www.etsy.com/listing/1032142006/arcs-series-geometric-art-generative-art?ref=shop_home_recs_1&crt=1). The `paint_arcs()` function allows you to make one for your wall as well.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/arcs/2021-07-16.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/arcs/2021-07-14.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/arcs/2021-07-15.png' width='270' height='270'>
</p>

## Functions

To be honest, this last type of painting is plainly and completely taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package, but it makes pretty pictures nonetheless. In this algorithm, the position of every single point is calculated by a formula which has random parameters.

You can use the `paint_function()` function to make your own unique painting with this algorithm. 

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-03-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-04-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-04-04.png' width='270' height='270'>
</p>