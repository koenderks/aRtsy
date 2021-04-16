# aRtsy: Generative Art Using R

I like pretty pictures and I like R. In the `R` package `aRtsy` I combine these two things into what people generally call generative art, resulting in some(times) nice looking pictures. I am lucky I got `R` because I cannot paint at all.

You can install and load the `aRtsy` package by running the code below.

```
devtools::install.github('koenderks/aRtsy')
library(aRtsy)
```

Let's go hunting for some good `seed`'s!

## Overview

* [Painting of the day](#painting-of-the-day)
* [Paint strokes](#paint-strokes)
* [Turmite](#turmite)
* [Langton's ant](#langtons-ant)
* [Function shapes](#function-shapes)
* [LP records](#LP-records)

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
1. The ant is able to cycle through different colors which correspond to different combinations of the rules above.

You can use the `paint_ant()` function to make your own unique painting with this algorithm.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-03.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-02.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/ants/2021-03-01.png' width='270' height='270'>
</p> 

## Functions

To be honest, this type of painting is plainly and completely taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package, but it makes pretty pictures nonetheless. In this algorithm, the position of every single point is calculated by a formula which has random parameters.

You can use the `paint_function()` function to make your own unique painting with this algorithm. 

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-03-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-04-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/functions/2021-04-04.png' width='270' height='270'>
</p>

## LP records

This type of painting is a special case of the shape painting created by `paint_function()`. I like this specific type of painting because of its close resemblance to the LP record, making it ideal as a poster for a music room or something. You got to find a lucky seed to get these though.

<p align="center">
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/records/2021-03-16.png' width='270' height='270'>
  <img src='https://github.com/koenderks/aRtsy/raw/master/png/records/2021-03-15.png' width='270' height='270'>
</p>