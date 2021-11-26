library(ggpubr)
library(aRtsy)

palettes <- c(
  "blackwhite",
  "dark1",
  "dark2",
  "dark3",
  "flora",
  "house",
  "gogh",
  "jasp",
  "jfa",
  "jungle",
  "klimt",
  "kpd",
  "lava",
  "origami",
  "nature",
  "neon1",
  "neon2",
  "retro1",
  "retro2",
  "retro3",
  "sooph",
  "tuscany1",
  "tuscany2",
  "tuscany3",
  "vrolik1",
  "vrolik2",
  "vrolik3"
)

ncol <- 3
n <- length(palettes)
nrow <- ceiling(n / ncol)

plotList <- list()
for (i in 1:length(palettes)) {
  palette <- aRtsy::colorPalette(palettes[i])
  d <- data.frame(y = rep(1, length(palette)), col = palette)
  p <- ggplot2::ggplot(data = d, mapping = ggplot2::aes(y = y, group = col)) +
    ggplot2::geom_bar(fill = d$col) +
    ggplot2::xlab(palettes[i]) +
    ggplot2::theme(
      axis.title.x = ggplot2::element_text(size = 9),
      axis.title.y = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = NA, colour = NA),
      legend.position = "none",
      panel.border = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_blank()
    )
  plotList[[i]] <- p
}

plot <- do.call("ggarrange", c(plotList, nrow = nrow, ncol = ncol)) +
  ggplot2::theme(panel.background = ggplot2::element_rect(fill = NA, colour = NA))
ggplot2::ggsave(filename = "./man/figures/colors.svg", plot = plot, scale = 1, units = "px")
ggplot2::ggsave(filename = "./man/figures/colors.pdf", plot = plot, scale = 1, units = "in")
