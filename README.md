# aRtsy: Generative Art Using R

I like pretty pictures and I like R. In the `R` package `aRtsy` I combine these two things into what people generally call generative art, resulting in some(times) nice looking pictures. I am lucky I got `R`, because I cannot paint at all.

You can install and load the `aRtsy` package by running the code below.

```
devtools::install.github('koenderks/aRtsy')
library(aRtsy)
```

## Overview

* [Painting of the day](#painting-of-the-day)
* [Paint strokes](#paint-strokes)
* [Turmites](#turmites)
* [Landon's ant](#langdons-ant)
* [Function shapes](#function-shapes)
* [LP records](#LP-records)

## Painting of the day

Every day this repository generates a random painting with the `aRtsy` package. This is today's painting:

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/daily.png' width='400' height='400'>
</p>

## Paint strokes

The `paint_strokes` algorithm is my first self-concocted algorithm for generative drawing on a grid-based canvas. This algorithm is based on the simple idea that each next point on the grid has a chance to take over the color of an adjacent colored point but also has a change of generating a new color. Going over the grid like this apparently results in these paint-like strokes on the canvas.

You can use the `paint_strokes()` function to make your own unique painting in this style. 

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

## Turmites

According to [wikipedia](https://en.wikipedia.org/wiki/Turmite), a turmite is a Turing machine which has an orientation in addition to a current state and a trail that consists of a two-dimensional grid of cells. Basically, it's a moving block. The algorithm consists of three simple steps that are repeated: 

- Turn on the spot (left, right, up, or down),
- Change the color of the square,
- Move forward one square.

You can use the `paint_turmite()` function to make your own unique painting in this style. 

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-06.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-09.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-08.png' width='270' height='270'>
</p>

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/turmites/2021-03-07.png' width='1000' height='270'>
</p>

## Langdon's ant

According to [wikipedia](https://en.wikipedia.org/wiki/Langton%27s_ant), Langdon's ant is a turmite with a very specific set of rules. In particular, it moves according to the rules below:

- On a non-colored square, turn 90 degrees clockwise, flip the color of the square, move forward one unit;
- On a colored square, turn 90 degrees counter-clockwise, flip the color of the square, move forward one unit.
- Different colors may correspond different combinations of these mechanics.

I like Langdon's Ant, it reminds me of a crayon painting. The problem with this thing is that it always moves off the canvas though...

You can use the `paint_ant()` function to make your own unique painting in this style.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-03.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-02.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-01.png' width='270' height='270'>
</p> 

## Function shapes

To be honest, this type of painting is plainly and completely taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package, but it makes pretty pictures nonetheless. Here are some nice variations I found.

You can use the `paint_shapes()` function to make your own unique painting in this style. 

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/shapes/2021-03-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/shapes/2021-04-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/shapes/2021-04-04.png' width='270' height='270'>
</p>

## LP records

This type of painting is a special case of the shape painting created by `paint_shape()`. I like this specific type of painting because of its close resemblence to the LP record, making it ideal as a poster for a music room or something. You got to find a lucky seed to get these though.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/records/2021-03-16.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/records/2021-03-15.png' width='270' height='270'>
</p>