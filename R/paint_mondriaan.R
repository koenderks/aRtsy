#' Paint a Mondriaan on a Canvas
#'
#' @description This function paints a Mondriaan.
#'
#' @usage paint_mondriaan(colors = '#fafafa', background = '#000000', cuts = 50,
#'                 ratio = 1.618, seed = 1, width = 200, height = 200)
#'
#' @param colors   	  the colors of the squares.
#' @param background  the color of the background (borders).
#' @param cuts        the number of cuts to make.
#' @param ratio       the \code{1:1} ratio for each cut.
#' @param seed        the seed for the painting.
#' @param width       the width of the painting in pixels.
#' @param height      the height of the painting in pixels.
#'
#' @return A \code{ggplot} object containing the painting.
#'
#' @author Koen Derks, \email{koen-derks@hotmail.com}
#'
#' @seealso \code{\link{paint_strokes}} \code{\link{paint_turmite}} \code{\link{paint_ant}} \code{\link{paint_function}}
#'
#' @examples
#' paint_mondriaan(colors = c('white', 'yellow', 'red'), 
#'                 background = '#000000', cuts = 20, ratio = 1.618, 
#'                 seed = 12, width = 200, height = 200)
#' 
#' @keywords paint
#'
#' @export

paint_mondriaan <- function(colors = '#fafafa', background = '#000000', cuts = 50, 
                            ratio = 1.618, seed = 1, width = 200, height = 200){
  if(length(background) > 1)
    stop("Can only take one background value.")
  if(cuts <= 1)
    stop("Cuts must be higher than 1.")
  x <- y <- z <- NULL
  set.seed(seed)
  palette <- c(background, colors)
  df <- matrix(0, nrow = height, ncol = width)  
  l <- nrow(df)
  w <- ncol(df)
  # Specify colors
  for(i in 1:cuts){
    cutx <- ceiling(l / ratio) # Determine the x value of the cut
    cuty <- ceiling(w / ratio) # Determine the y value of the cut
    cutfromtop <- sample(c(TRUE, FALSE), 1) # Determine whether to cut from the top
    cutfromleft <- sample(c(TRUE, FALSE), 1) # Determine whether to cut from the left
    # Cut
    if(cutfromtop && cutfromleft){
      df[1:cutx, 1:cuty] <- sample(1:(length(palette)-1), size = 1) 
    } else if(cutfromtop && !cutfromleft){
      df[cutx:ncol(df), 1:cuty] <- sample(1:(length(palette)-1), size = 1)
    } else if (!cutfromtop && cutfromleft){
      df[1:cutx, cuty:nrow(df)] <- sample(1:(length(palette)-1), size = 1)
    } else if(!cutfromtop && !cutfromleft){
      df[cutx:ncol(df), cuty:nrow(df)] <- sample(1:(length(palette)-1), size = 1)
    }
    # Reset for new cut
    l <- sample(1:ncol(df), 1)#cutx
    w <- sample(1:nrow(df), 1)#cuty
  }
  df_new <- df
  # Color borders
  for(i in 1:nrow(df_new)){
    for(j in 1:ncol(df_new)){
      # If the blocks around if contain more than one unique value it is an edge
      xleft <- ifelse(j - 1 < 0, yes = 0, no = j - 1)
      xright <- ifelse(j + 1 > ncol(df_new), yes = ncol(df_new), no = j + 1)
      ytop <- ifelse(i - 1 < 0, yes = 0, no = i - 1)
      ybottom <- ifelse(i + 1 > nrow(df_new), yes = nrow(df_new), no = i + 1)
      values <- c(df[ybottom, xleft], df[y, xleft], df[ytop, xleft], df[ybottom, x], df[ytop, x], df[ybottom, xright], df[y, xright], df[ytop, xright])
      if(!(length(unique(values)) == 1)){
        df_new[i, j] <- 0
      } 
    }
  }
  df_new <- reshape2::melt(df_new)
  colnames(df_new) <- c("y", "x", "z")
  painting <- ggplot2::ggplot(data = df_new, ggplot2::aes(x = x, y = y, fill = z)) +
    ggplot2::geom_raster(interpolate = FALSE, alpha = 1) + 
    ggplot2::coord_equal() +
    ggplot2::scale_fill_gradientn(colours = palette) +
    ggplot2::scale_y_continuous(expand = c(0,0)) + 
    ggplot2::scale_x_continuous(expand = c(0,0)) +
    ggplot2::theme(axis.title = ggplot2::element_blank(), 
                   axis.text = ggplot2::element_blank(), 
                   axis.ticks = ggplot2::element_blank(), 
                   axis.line = ggplot2::element_blank(), 
                   legend.position = "none", 
                   panel.border = ggplot2::element_blank(), 
                   panel.grid = ggplot2::element_blank(), 
                   plot.margin = ggplot2::unit(rep(-1.25,4),"lines"), 
                   strip.background = ggplot2::element_blank(), 
                   strip.text = ggplot2::element_blank())
  return(painting) 
}
