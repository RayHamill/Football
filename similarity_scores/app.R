library(shiny)
library(tidyverse)
library(shinyWidgets)
library("ggimage")
source("theme_ray.R")
theme_set(theme_ray())

#df <- read_csv("data/scaled_similarity_df.csv")

ui <- fluidPage(
  setBackgroundColor("#fcfcfc"),
  titlePanel('Player Similarity Scores'),
  sidebarLayout(
    sidebarPanel(
      p("Search for a player below to see who they profile most similarly to across Europe's big 5 leagues."),
      br(),
      selectizeInput("player", 
                     label = 'Player',
                     choices = unique(df$player),
                     options = list(placeholder = 'Player Search',
                                    onInitialize = I('function() { this.setValue(""); }'))),
      
      sliderInput("age", "Max Age",  
                  min = 19, max = 40, value = 40),
      
      br(),
      h4('Powered by'),
      img(src='opta_logo.png', height=65, width=155)
      
    ),
    
    mainPanel(
      plotOutput(outputId = "similarityPlot")
    )
  )
)

server <- function(input, output) {
  
#  output$selectTeam <- renderUI({
#    selectInput("team", "Team", choices = unique(ptl_1819[ptl_1819$tournament==input$tournament, "team"]))
#  })
  
  dat <- reactive({
    req(input$player)
    
    col_index = which(names(df) == input$player)
    
    tmp1 <- select(df, 1, 2, 3, 4, 5, 6)
    tmp2 <- df[col_index]
    
    data <- cbind(tmp1, tmp2)
    names(data)[7]<-"similarity"
    data <- data[order(desc(data$similarity)),]
    data <- data[(data$age <= input$age) & (data$player != input$player),]
    data <- data[c(1: 21), ]
    data
  }
  )
  
  output$similarityPlot <- renderPlot(res=80,{
    req(input$player)
    ggplot(dat(), aes(reorder(player, similarity), similarity))+
      geom_col(aes(reorder(player, similarity), 1), width=0.8, fill='#dee1e5')+
      geom_col(width=0.8, fill='#4280b7')+
      coord_flip()+
      #geom_image(size=0.055, alpha=0.8, y=-0.04)+
      scale_y_continuous(limits = c(0, 1), breaks=seq(0, 1, 0.25))+
      geom_text(aes(label=round(similarity, 2)), 
                size=4.6, hjust=1.2, vjust=0.45, fontface="bold", colour="#f7f7f7")+
      ggtitle(paste(input$player))+
      labs(subtitle="Similarity Scores Based on 2018/19 League Data")+
      theme(axis.text.y=element_text(face="bold", color='#444444', size=14),
            axis.text.x=element_blank(),
            plot.title=element_text(size=20, color='#444444'),
            plot.subtitle=element_text(size=14),
            panel.grid.major=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            plot.background=element_rect(fill="#fcfcfc", color='#fcfcfc'),
            panel.background=element_rect(fill="#fcfcfc"))
  },
  height = 550,
  width = 550)
}
shinyAppDir(".")
shinyApp(ui = ui, server = server)

# reorder players alphabetically.

# find duplicate players in python with groupby.
# find where they're being duplicated? By Name or ID?


## One or two sentences outlining what similarity scores are.
## Not too detailed on method.
## Can expand on method in searching for unique players blog post.

## Player Selection Section

## League & Team Selection Options - Default to All.
## Player Search and Dropdown Option - What Default?


## Filtering Section

## Age
## League
## Mins?

## Remove goalkeepers
## Change title to just player name, no subtitle.
## Explainer text, with links to GitHub and Twitter.
## Widget to display more players. Default at like 15.
## Add team crests.
## Explore with different configs. Diff PCA amount. Diff features. Etc.
## Remove duplicate players, fix ages. Beware of players who have switched clubs.
## check: maxi gomez, juan mata, 
## Think about how it adapts to devices. Most commonly used on phone.
## include ggsave button.

## NO NEED TO RUSH. BETTER TO GET IT RIGHT.


