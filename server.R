server <- function(input, output, session) {
#filtering data according input on slider
  slider_data <- reactive({
    filter(df9, imonth == input$period)
  })
  #filtering data according to which reigions were selected for both graphs
   grouped_type <- reactive({
     filter(grouped_file, region_txt %in% input$region)
   })
    grouped_year <- reactive({
      
      filter(graph_data, region_txt %in% input$region1)
    })
  
  output$Map <- renderLeaflet({
    Map
})
     
  output$plot1 <- renderPlot({
   #displays a stacked bar graph and plots type of attack vs. frequency of each type
    ggplot(grouped_type(), aes(x = attacktype1_txt, y = freq, fill = region_txt)) + 
    geom_bar(position = "stack", stat='identity') + 
    labs(x="Type Of Attack", y = "Frequency", title= "Global Terrorism Types") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    guides(fill=guide_legend(title="Regions"))
    
  })
  output$plot2 <- renderPlot({
    
    #displays a stacked bar graph and plots time vs. frequency of attack
    ggplot(grouped_year(), aes(x = iyear, y = freq, fill = region_txt)) + 
      geom_bar(position = "stack", stat='identity') +
      labs(x="Year", y = "Frequency", title= "Terrorism Over Time") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      guides(fill=guide_legend(title="Regions"))
     
    
  })


  #updates the markers on the map if user selects this option
  observeEvent(input$show, {
    leafletProxy('Map', data = slider_data()) %>% 
      clearMarkers() %>% 
      addCircleMarkers(lng = ~longitude, lat = ~latitude, radius = ~nkill*.001) 
    updateSliderInput(session,"period",value = input$period)
  })
  
  #removes the markers on map if user selects this option
  observeEvent(input$not_show, {
    leafletProxy('Map', data = slider_data()) %>% clearMarkers()
  })
}