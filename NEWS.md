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
