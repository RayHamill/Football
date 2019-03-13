library(tidyverse)

df <- read_csv("C:/Users/Ray/Desktop/Football Data/Opta Data/tmp.csv")

ggplot(df, aes(X1))+
  #geom_segment(aes(x=0, y=0.01, xend=38, yend=0.1), size=1, alpha=0.8, colour="#333333")+
  geom_hline(yintercept=0, color='grey50', linetype='dashed') +
  geom_line(aes(y=xgd), colour="#CC0000", size=1, alpha=0.8)+
  geom_line(aes(y=gd), colour="#33CC33", size=1, alpha=0.8)+
  #geom_line(aes(y=rolling_xgdD), colour="#CCCCCC", size=0.9, alpha=0.8)+
  geom_ribbon(aes(ymin=gd+0.01,ymax=ifelse(gd<xgd, xgd-0.01, gd)), fill="#CC0000", alpha="0.3", color=NA) +
  geom_ribbon(aes(ymin=xgd+0.01,ymax=ifelse(gd>xgd, gd-0.01, xgd)), fill="#33CC33", alpha="0.3", color=NA) +
  scale_y_continuous(breaks=seq(-1, max(df$gd)+0.5, 0.5), limits=c(min(df$gd)-0.5, max(df$gd)+0.5), 0.5)+
  scale_x_continuous(breaks = (seq(152, 228, by = 38)), labels=c("152" = "2016/17", "190" = "2017/18", "228" = "2018/19")) +
  ggtitle('Valencia')+
  labs(subtitle= "La Liga 2017-2019 | 12 game rolling average"~bold('goal difference')~"and"~bold('xG difference'))+
  theme(plot.background=element_rect(fill="#f7f7f7"),
        panel.background=element_rect(fill="#f7f7f7"),
        panel.border=element_blank(),
        plot.subtitle=element_text(colour="#333333", size=10),
        plot.title=element_text(colour="#333333", size=13, face='bold'),
        legend.position="right",
        panel.grid.minor=element_blank(),
        axis.ticks=element_blank(),
        axis.text.y=element_text(size=8),
        axis.text.x=element_text(size=8, face='bold'),
        axis.title.y=element_blank(),
        axis.title.x=element_blank())

ggsave('tmp2.png', width=6, height=3, dpi=1000)