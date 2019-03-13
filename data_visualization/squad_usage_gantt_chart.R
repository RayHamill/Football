library(tidyverse)
source("C:/Users/Ray/Desktop/Football Data/Opta Data/Football/data_visualization/theme_ray.R")
theme_set(theme_ray())

# Code to plot single line gantt chart for team squad usage

df <- read_csv("C:/Users/Ray/Desktop/Football Data/Opta Data/tmp.csv")
# 4 columns: match, start, end, player
# each row contains players start and end time on the field for each match

max_mins = max(df$match)*90
df$match <- as.factor(df$match)
df$player_id <- as.factor(df$player_id)
positions <- unique(df$player)

ggplot(df)+
  geom_segment(aes(x=start, xend=end, y=player, yend=player), size=6, alpha=0.45, color='#842742') +
  geom_hline(yintercept=seq(1,nrow(df), 1)+.5, color="#e7e7e7")+
  scale_y_discrete(limits = positions)+
  scale_x_continuous(minor_breaks = (seq(0, max_mins, by = 90)), breaks = (seq(0, max_mins, by = 450)), labels=c('0'='0', '450'='5', '900'='10', '1350'='15', '1800'='20', '2250'='25')) +
  ggtitle("Barcelona Squad Usage")+
  labs(subtitle="La Liga 2018/19", x='Match')+
  theme(panel.grid.major.y = element_blank(),
        plot.subtitle=element_text(size=11),
        plot.title=element_text(size=14),
        axis.text.y=element_text(face='bold'),
        axis.title.y=element_blank())

ggsave('tmp.png', width=5, height=5, dpi=1000)
