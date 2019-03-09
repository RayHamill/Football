library(tidyverse)
library(ggrepel)
library("ggimage")
source("C:/Users/Ray/Desktop/Football Data/Opta Data/Football/data_visualization/theme_ray.R")
theme_set(theme_ray())

# Code to graph scatter plots with ggplot2.
# This example compares player goalscoring rates with their expected rate.

df <- read_csv("C:/Users/Ray/Desktop/Football Data/Opta Data/tmp.csv")

ggplot(data=subset(df), aes(xG, goals)) +
  geom_abline(intercept = 0, slope = 1, color='grey50', linetype='dashed') +
  geom_point(data=subset(df), aes(fill=diff), shape=21, stroke=0.4, size=2, alpha=0.8, color='#303030') +
  geom_text_repel(data=subset(df, (xG>0.25) | (goals>0.25)), aes(label=player), size=2, color='#303030',
                  fontface="bold", segment.alpha = 0.6, segment.color = 'grey50', point.padding = 0.005)+
  scale_x_continuous(limits = c(0, 0.8), breaks=seq(0, 0.8, 0.25))+
  scale_y_continuous(limits = c(0, 1.1), breaks=seq(0, 1, 0.25))+
  scale_fill_gradient2(low="red", high="green", mid='grey50', midpoint=1)+
  ggtitle("La Liga's Biggest Over/Under-Performers in Front of Goal")+
  labs(x="xG per 90", y="Goals per 90", subtitle="Minimum 1000 minutes played | 2018/19\nColour denotes total goals minus total xG")+

ggsave('tmp.png', width=5.5, height=5.5, dpi=1000)
