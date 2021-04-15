# aRtsy: Generative Art Using R

I like pretty pictures and I like R. In the `R` package `aRtsy` I combine those two things into what people generally call generative art.

## Overview

* [Paint strokes](#paint-strokes)
* [Turmites](#turmites)
* [Function shapes](#function-shapes)
* [LP records](#LP-records)

## Paint strokes

The `paint_strokes` algorithm is my first self-concocted algorithm for generative drawing on a grid-based canvas. The algorithm is based on the simple idea that each next point on the grid has a chance to take over the color of an adjacent colored point but also has a change of generating a new color. Going over the grid like this apparently results in these paint-like strokes on the canvas.

You can use the `paint_strokes()` function to make your own unique portrait using this style. 

<p align="center">
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-21.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-25.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-20.png' width='270' height='270'>
</p>

<p align="center">
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-11.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-12.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-10.png' width='270' height='270'>
</p>

## Turmites

According to [wikipedia](https://en.wikipedia.org/wiki/Turmite), a turmite is a Turing machine which has an orientation in addition to a current state and a "tape" that consists of a two-dimensional grid of cells. The algorithm is simple: 1) turn on the spot (left, right, up, down) 2) change the color of the square 3) move forward one square.

You can use the `paint_turmite()` function to make your own unique portrait using this style. 

<p align="center">
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/turmites/2021-03-06.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/turmites/2021-03-09.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/turmites/2021-03-08.png' width='270' height='270'>
</p>

<p align="center">
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/turmites/2021-03-07.png' width='1000' height='270'>
</p>

## Function shapes

To be honest, this type of painting is plainly and completely taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package, but it makes pretty pictures nonetheless. Here are some nice variations I found.

You can use the `paint_shapes()` function to make your own unique portrait using this style. 

<p align="center">
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/shapes/2021-03-17.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/shapes/2021-04-08.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/shapes/2021-04-04.png' width='270' height='270'>
</p>

## LP records

This type of painting is a special case of the shape painting created by `paint_shape()`. I like this specific type of painting because of its close resemblence to the LP record, making it ideal as a poster for a music room or something. You got to have a lucky seed for these though.

<p align="center">
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/records/2021-03-16.png' width='270' height='270'>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/records/2021-03-15.png' width='270' height='270'>
</p>