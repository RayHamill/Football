library(tidyverse)
library("ggimage")
source("C:/Users/Ray/Desktop/Football Data/Opta Data/Football/data_visualization/theme_ray.R")
theme_set(theme_ray())

# Code to plot stacked bar chart with ggplot2.
# Used to visualize proportions (in this case player similarity).

df <- read_csv("C:/Users/Ray/Desktop/Football Data/Opta Data/tmp.csv")
# Three columns: player name, similarity (to given player), team logo (path)

ggplot(df, aes(reorder(player, similarity), similarity, image=image))+
  geom_col(aes(reorder(player, similarity), 1), width=0.8, fill='#dee1e5')+
  geom_col(width=0.8, fill='#4280b7')+
  coord_flip()+
  geom_image(size=0.055, alpha=0.8, y=-0.04)+
  scale_y_continuous(limits = c(-0.02, 1), breaks=seq(0, 1, 0.25))+
  geom_text(data = df, aes(label=round(similarity, 2)), 
            size=2.5, hjust=1.2, vjust=0.45, fontface="bold", colour="#f7f7f7")+
  ggtitle("Europe's Most Similar Players to Lionel Messi")+
  labs(subtitle="Similarity Scores Based on 2018/19 League Data")+
  theme(axis.text.y=element_text(face="bold", color='#3f3f3f'),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())

ggsave('tmp.png', width=4.6, height=4, dpi=1000)
