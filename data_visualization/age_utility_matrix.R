library(tidyverse)
library(ggrepel)
source("C:/Users/Ray/Desktop/Football Data/Opta Data/Football/data_visualization/theme_ray.R")
theme_set(theme_ray())

# Code to plot a team's squad usage vs age.

df <- read_csv("C:/Users/Ray/Desktop/Football Data/Opta Data/tmp.csv")
# Three columns: player, age, mins_percentage, also optional are new signing and sold cols

ggplot(df, aes(age, mins_percentage)) +
  annotate("rect", xmin = 24, xmax = 29, ymin = 0, ymax = 1, alpha = 0.5, fill='red')+
  geom_point(data=subset(df, signing==0), size=1, color='#333333') +
  geom_point(data=subset(df, signing==1), size=1, color='#006600', alpha=0.6) +
  #geom_point(data=subset(df, sold==1), size=1, color='#CC3333', alpha=0.35) +
  scale_x_continuous(breaks = c(18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40))+
  geom_text_repel(data=subset(df, signing==0), aes(label=player), size=1.8, fontface="bold", segment.alpha = 0.6, segment.color = 'grey50', color='#333333')+
  annotate("text", x = 26.5, y = 0.05, color='#bc200b', size=2.2, label = "bold('Peak Years')", parse=TRUE)+
  geom_text_repel(data=subset(df, signing==1), aes(label=player), size=1.8, fontface="bold", segment.alpha = 0.6, segment.color = 'grey50', color='#006600', alpha=0.6)+
  #geom_text_repel(data=subset(df, sold==1), aes(label=player), size=1.8, fontface="bold", segment.alpha = 0.6, segment.color = 'grey50', color='#CC3333', alpha=0.35)+
  scale_y_continuous(labels = function(x) paste0(x*100, "%"), breaks=seq(0, 1, 0.25))+
  ggtitle("Bayern Munich Age-Utility Matrix")+
  labs(x="Age", y="Percentage of Mins Played", subtitle="Bundesliga 18/19")

ggsave('tmp.png', width=5, height=4, dpi=1000)
