library(DT)
library(shiny)
library(shinydashboard)

ui <- shinyUI(dashboardPage(
  dashboardHeader(title = "Global Terrorism Database"),
  dashboardSidebar(
    
    sidebarUserPanel(''),
    
    #creates three differents tabs
    sidebarMenu(
      menuItem("Map", tabName = "Map", icon = icon("map")),
      menuItem("Graph", tabName = "Graph", icon = icon("database")),
      menuItem("About", tabName = "About", icon = icon("hand-point-right"))
      
    )),
  dashboardBody(
    #building each tab
    tabItems(
      tabItem(tabName = "About",
              #Below is a description/overview of the project
              fluidRow(box(title = "About", width = 12,
                           footer = HTML(
                             "This rShiny project was built by Ben Rosen while
                             attending the NYC Data Science Academy. View the code
                             here: https://github.com/brosen255/ds_projects"
                           ))),
              fluidRow(box(title = "Data", width = 12,
                           footer = HTML(
                             "The Global Terrorism Database provided 135 variables, 
                             which provided characteristics of each attack, including the
                             location, type, motive, weapons used, targets and many more characteristics. 
                             Only 10 variables were used in this analysis.
                             The data was retrieved from Kaggle at https://www.kaggle.com/bstaff/global-terrorism-database
                             "
                           )))),
      tabItem(tabName = "Map",
              fluidRow(
                headerPanel("Global Terrorism"),
                #displays leaflet map created in server file
                leafletOutput("Map"),

                #sliderInput is used to filter the data by year
                sliderInput("period","Time Period:", min = min(df9$imonth), max = max(df9$imonth), value=df9$imonth, step = 1, sep = "", animate = TRUE
                ),
                #button to display or remove points
                actionButton('show', "Show Points"),
                actionButton('not_show', "Remove Points"))),
      
      tabItem(tabName = "Graph",
                headerPanel("Visualization"),
              #user selects which regions to display on stacked bar graph
              #default choice is North America & South America
              fluidRow(column(12, checkboxGroupInput("region", label = "Select Region", inline = TRUE, selected = 
                                                       c("North America","South America"), choices = unique(grouped_file$region_txt)))),
              fluidRow(column(12, plotOutput("plot1"))),
              
              #user selects regions
              fluidRow(column(12, checkboxGroupInput("region1", label = "Select Region", choices = unique(graph_data$region_txt), 
                                                     width = '100%', inline = TRUE, selected = 
                                                       c("North America","South America")))),
              fluidRow(column(12, plotOutput("plot2"))))
  ))))