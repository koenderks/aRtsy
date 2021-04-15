# Generative Art Using R

I like pretty pictures and I like R. In this repository I combine those two things into what people generally call generative art.

* [Paint strokes](#paint-strokes)
* [Function shapes](#function-shapes)
* [LP records](#LP-records)

## Paint strokes

The `paint_strokes` algorithm is my first self-concocted algorithm for generative drawing on a grid-based canvas. The algorithm is based on the premisse that each next point on the grid has a large chance to take over the color of an adjacent colored point, but also has a slight change of generating a new color. Apparently this results in these paint-like strokes on the canvas. 

You can use the `paint_strokes()` function from `R/paint_strokes.R` to make your own unique portrait using this style. 

<p align="center">
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-21.png' width='260' height='260'>
  <br/>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-25.png' width='260' height='260'>
  <br/>
  <img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-20.png' width='260' height='260'>
</p>

<img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-21.png' width='390' height='390' align='left' margin-left='20' margin-right='20'/><img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-25.png' width='390' height='390' align='right' margin-left='20' margin-right='20'/>

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

<img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-12.png' width='390' height='390' align='left' margin-left='20' margin-right='20'/><img src='https://github.com/koenderks/Art-Gallery/raw/master/png/strokes/2021-03-20.png' width='390' height='390' align='right' margin-left='20' margin-right='20'/>

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

## Function shapes

To be honest, this type of painting is plainly and completely taken over from the [`generativeart`](https://github.com/cutterkom/generativeart) package, but it makes pretty pictures nonetheless. Here are some nice variations I found using the `paint_shape()` function from `R/paint_shape.R`.

<img src='https://github.com/koenderks/Art-Gallery/raw/master/png/shapes/2021-03-17.png' width='390' height='390' align='left' margin-left='20' margin-right='20'/><img src='https://github.com/koenderks/Art-Gallery/raw/master/png/shapes/2021-04-05.png' width='390' height='390' align='right' margin-left='20' margin-right='20'/>

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

<img src='https://github.com/koenderks/Art-Gallery/raw/master/png/shapes/2021-04-04.png' width='390' height='390' align='left' margin-left='20' margin-right='20'/><img src='https://github.com/koenderks/Art-Gallery/raw/master/png/shapes/2021-04-08.png' width='390' height='390' align='right' margin-left='20' margin-right='20'/>

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

## LP records

This type of painting is a special case of the shape painting created by `paint_shape()`. I like this specific type of painting because of its close resemblence to the LP record, making it ideal as a poster for a music room or something. You got to have a lucky seed for these though.

<img src='https://github.com/koenderks/Art-Gallery/raw/master/png/records/2021-03-16.png' width='390' height='390' align='left' margin-left='20' margin-right='20'/><img src='https://github.com/koenderks/Art-Gallery/raw/master/png/records/2021-03-15.png' width='390' height='390' align='right' margin-left='20' margin-right='20'/>