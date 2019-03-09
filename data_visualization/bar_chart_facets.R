library(tidyverse)
library("ggimage")
source("C:/Users/Ray/Desktop/Football Data/Opta Data/Football/data_visualization/theme_ray.R")
theme_set(theme_ray())

# Code to plot facet wrapped bar charts with ggplot2.
# This example shows the xG leaderboard across European leagues.

df <- read_csv("C:/Users/Ray/Desktop/Football Data/Opta Data/tmp.csv")

ggplot(df, aes(reorder(player, xG), xG, image=image))+
  geom_col(width=0.8, fill='#4280b7')+
  geom_image(size=0.06, alpha=0.8, y=-0.045)+
  scale_y_continuous(limits = c(-0.03, 0.85))+
  geom_text(data = df, aes(label=round(xG, 2)), 
            size=2.2, hjust=-0.15, vjust=0.45, fontface="bold", colour="#333333")+
  ggtitle("xG per 90 2018/19")+
  labs(subtitle="Minimum 800 minutes played | Penalties not included")+
  facet_wrap( ~ tournament_id, nrow = 2, scale='free_y')+
  coord_flip()+
  theme(panel.grid.major=element_blank(),
        strip.background = element_blank(),
        strip.text=element_text(colour="#303030", face="bold", size=8, hjust = 0.15),
        axis.text.x=element_blank(),
        axis.title.x=element_blank())

ggsave('tmp.png', width=8.5, height=5, dpi=1000)
