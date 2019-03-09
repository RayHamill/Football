theme_ray <- function() {
  theme_bw() +
    theme(plot.background=element_rect(fill="#f7f7f7"),
          panel.background=element_rect(fill="#f7f7f7"),
          panel.border = element_blank(),
          plot.subtitle=element_text(colour="#303030", size=8),
          plot.title=element_text(colour="#333333", size=10, face='bold'),
          legend.position="none",
          panel.grid.minor=element_blank(),
          axis.ticks=element_blank(),
          axis.text.x=element_text(colour='#303030', size=8),
          axis.text.y=element_text(colour='#303030', size=8),
          axis.title.y=element_text(colour='#303030', size=8),
          axis.title.x=element_text(colour='#303030', size=8))
}