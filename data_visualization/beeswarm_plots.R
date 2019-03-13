library(tidyverse)
library('ggbeeswarm')
source("C:/Users/Ray/Desktop/Football Data/Opta Data/Football/data_visualization/theme_ray.R")
theme_set(theme_ray())

# Code to plot beeswarm plots of player stats 
# using geom_quasirandom from ggbeeswarm package.


df <- read_csv("C:/Users/Ray/Desktop/Football Data/Opta Data/tmp.csv")
# Five columns: player name, year, stat, value, percentile (1-5 representing 20% quantiles)

df$percentile <- as.factor(df$percentile)
df$stat <- factor(df$stat, levels=unique(df$stat))

player_ = "P. Dybala"
year_ = 19
ggplot(data=subset(df), aes(stat, value, color=percentile, fill=percentile))+
  geom_quasirandom(size=1.75, alpha=0.5, color='#d6d6d6')+
  geom_point(data=subset(df, (player==player_) & (year==year_)), alpha=0.9, shape=21, stroke=0.4, size=6.55, color='black')+
  geom_text(data=subset(df, (player==player_) & (year==year_)), aes(label=round(value, 2)), color='black', size=1.95, fontface='bold')+
  scale_fill_manual(values=c('#e55952', '#e59652', '#e5d852', '#bde552', '#79e552'))+
  coord_flip()+
  ggtitle('Paulo Dybala', subtitle='Attacking Midfield Comparison | Juventus | Serie A 2018/19')+
  labs(caption='\nAll stats per 90 mins\nGrey points represent AMs from big 5 leagues\n*Passes & carries that move the ball 10m closer to goal')+
  geom_vline(xintercept=0.5, color='grey50', size=0.4) +
  facet_wrap(~stat, scale='free', ncol=2)+
  theme(plot.caption = element_text(color='#606060', size=6.5),
        plot.subtitle=element_text(size=10, face='bold'),
        plot.title=element_text(size=15),
        strip.background = element_blank(),
        strip.text=element_text(colour="#444444", face="bold", size=8, hjust=0, vjust=0),
        panel.spacing=unit(1, "lines"),
        axis.text.x=element_text(face="bold", color='#444444'),
        axis.text.y=element_blank(),
        axis.title.y=element_blank(),
        axis.title.x=element_blank())

ggsave('tmp.png', width=5, height=6, dpi=1000)
