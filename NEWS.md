# aRtsy 1.0.2

- Revert back to the kknn package.

# aRtsy 1.0.1

- Added `canvas_slime()`.
- Faster runtime of the `canvas_flame()` funtion.

# aRtsy 1.0.0

- Fixed a bug in the `canvas_flame()` code when `blend = FALSE` and `weighted = TRUE`.
- Added new logo!

# aRtsy 0.2.4

 - Added new color palettes `neo1`, `neo2`, `neo3`, `shell1`, `shell2` and `shell3`.
 - Added new function `canvas_lissajous()`.

# aRtsy 0.2.3

- Added new function `canvas_swirls()`.
- Added new function `canvas_tiles()`.
- Added argument `outline` to function `canvas_flow()`.
- Fixed a bug in `canvas_planets()` where no stars would be drawn.

# aRtsy 0.2.2

- New function `canvas_smoke()`.
- Added more variations to the function `canvas_mandelbrot()`.
- Added argument `flatten` (default = `FALSE`) to `canvas_chladni()` to flatten the colors in the output.
- The argument `size` in `canvas_segments()` now accepts a vector of sizes as input. The segments on the canvas receive a size sampled from the elements in this vector.

# aRtsy 0.2.1

- Added `symmetry` argument to the `canvas_flame()` function. This argument can be used to include dihedral or rotation symmetry into the flame.
- Added a new color palette `flag`, thanks to [jacobpstein](https://github.com/jacobpstein).

# aRtsy 0.2.0

- Fixed cpp warnings `warning: use of bitwise '&' with boolean operands [-Wbitwise-instead-of-logical]` in the flame algorithm.

# aRtsy 0.1.9

- Added new function `canvas_mesh()`.
- Added new function `canvas_flame()`.

# aRtsy 0.1.8

**New features**

- Added new function `canvas_splits()`.

# aRtsy 0.1.7

**New features**

- Added new function `canvas_petri()`.
- Added `polar` to `canvas_flow()`, thanks to @researchremora on twitter for the idea.
- Added more color palettes to the `colorPalette()` function.

# aRtsy 0.1.6

**New features**

- Added more color palettes to the `colorPalette()` function.
- Added more noise types for `canvas_flow()` and `canvas_chladni()` with the `ambient` package.
- Added `warp` to `canvas_chladni()` which now also warps the figure.

# aRtsy 0.1.5

**New features**

- Added `canvas_recaman()`. Thanks to @akident on Twitter for the suggestion.
- Added `canvas_phyllotaxis()`.
- Added `canvas_cobweb()`.
- Added `canvas_chladni()`.

**Major changes**

- `canvas_function()` is now able to take a vector of colors for the artwork.
- Removed the dependency on the `dplyr` package.

# aRtsy 0.1.4

**New features**

- Added `canvas_maze()`.

**Minor changes**

- The function `colorPalette()` now randomizes the `hsl` scale in the `random` color palette instead of the `rgb` scale.
- The function `colorPalette()` can now create a `complement` color palette consisting of complementing color (e.g., on the other side of the `hsl` color wheel).
- Removed the `resolution` parameter in `canvas_flow()` in favor of a `stepmax` parameter that determines the maximum proportion of the canvas covered by each iteration.

# aRtsy 0.1.3

**Minor changes**

- Fixed the `call of overloaded ‘ceil(int)’ is ambiguous` error on Solaris indicated by CRAN.

# aRtsy 0.1.2

**New features**

- Added new artwork `canvas_flow()`.
- Added new artwork `canvas_watercolors()`.

**Major changes**

- Changed the `width` and `height` arguments in all functions to `resolution`. If you want to save a non-square artwork, it is best to set a custom `height` and `width` the the preferred export / save function.

**Minor changes**

- Added `Rcpp::checkUserInterrupt()` to all `C++` functions.

# aRtsy 0.1.1

**New features**

- Added six new artworks to the package: `canvas_stripes()`, `canvas_gemstone()`, `canvas_blacklight()`, `canvas_mosaic()`, `canvas_forest()`, and `canvas_nebula()`.

**Minor changes**

- Artwork of the day is now created with `set.seed(Sys.Date())` instead of `set.seed(Sys.time())`.
- Removed unnecessary `ggpubr` from the Imports field in `DESCRIPTION` for CRAN submission.
- Fixed a memory leak in `canvas_ant()`.

# aRtsy 0.1.0

**New features**

- First implementation of the aRtsy package.
