

vehicle_data <- vehicle_data
content <- paste(sep = "<br/>","***************NYPD***************","<br/>","MOTOR VEHICLE COLLISION DATA",
                 "<br/>"," FROM: 07/01/2012 to 07/01/2018","<br/>","Click To Continue")

shinyServer(function(input, output, session) {
  
output$map <- renderLeaflet({
  leaflet(Andrew) %>%
    addProviderTiles("Esri.WorldStreetMap") %>%
    setView(lng = -73.97,lat = 40.75, zoom = 12)%>%
    
    addTiles() %>%
    addPopups( lng =-73.97, lat =40.75,content,options = popupOptions(closeOnClick = TRUE,closeButton = FALSE))
  })

output$mytable = DT::renderDataTable({
  datatable(clean_data,options = list(scrollX = TRUE), rownames=FALSE) %>%
    formatStyle(input$selected, background="skyblue", fontWeight='bold')
  })

observe({
  proxy <- leafletProxy("map") %>%
    clearMarkers() %>%   
    clearMarkerClusters() %>% 
    addCircleMarkers(data = vehicle_data %>% filter(BOROUGH == input$borough1),
                     lng = ~LONGITUDE,lat = ~LATITUDE,color = 'Red',radius =1,
                     clusterOptions = markerClusterOptions(),group = 'CLUSTER(BOROUGH)') %>%
    
    addCircleMarkers(data = vehicle_data %>% filter(BOROUGH == input$borough1),
                     lng = ~LONGITUDE,lat = ~LATITUDE,color = 'Red',radius =3,group = 'CIRCLE(BOROUGH)') %>%
    
    addCircleMarkers(data = vehicle_data %>% filter(YEAR == input$year),
                     lng = ~LONGITUDE,lat = ~LATITUDE,color = 'Green',radius =1,group = 'SQUARE(YEAR)') %>%
  
    addLayersControl(
      baseGroups = c("CLUSTER(BOROUGH)","CIRCLE(BOROUGH)", "SQUARE(YEAR)"),
      options = layersControlOptions(collapsed = TRUE),
      position = c("topleft"))
  })


output$hist <- renderPlot({
  hist(vehicle_data$YEAR,
       main = "Accidents By Year",
       xlab = "Year (2012 - 2018)",
       col = c("red", "blue", "green", 'orange',"violet", "pink","yellow",'cyan'),
       border = 'white')
  })
ggthemr('earth',text_size = 15)
output$plot1 <- renderPlot({
  
  vehicle_data %>% group_by(YEAR) %>% arrange(YEAR) %>%
    summarise(Accidents = n()) %>% 
    ggplot(aes(x = YEAR,y = Accidents )) +
    geom_line(aes(color = "Accidents")) + 
    geom_point(show.legend = TRUE,size = 6, color = 'red') +
    geom_text(aes(label = Accidents ),vjust =-1) +
    labs(title = 'NYC Motor Vehicle Collisions 2012 - 2018',x = 'Year', y = 'Number of Accidents') +
    theme(plot.title = element_text(hjust = 0.5))
  })

output$plot2 <- renderPlot({
  
  vehicle_data %>% group_by(DAY,BOROUGH) %>% 
    arrange(DAY) %>% summarise(n = n()) %>% 
    ggplot(aes(x = DAY,y= n)) +
    geom_col(aes(fill = DAY)) + 
    facet_grid(~BOROUGH) + 
    ggtitle("WHO LOVES FRIDAY...UGHHHH?") + 
    theme(plot.title = element_text(hjust = 0.5)) +
    ylab("Number of collision") + xlab("Day") +
    theme(axis.text.x=element_text(angle =75,hjust=1))
  
  })

output$plot3 <- renderPlot({
  
  vehicle_data %>% group_by(TIME,BOROUGH) %>% summarise(Collisions = n()) %>%
    ggplot(aes(x = BOROUGH,y = TIME)) + 
    geom_raster(aes(fill = Collisions)) + 
    scale_fill_gradient(low = "darkgreen",high = "yellow") +
    ggtitle("Heatmap of hour of day has most number of collision") +
    theme(plot.title = element_text(hjust = 0.5))
  
  })

output$plot4 <- renderPlot({
  
  vehicle_data %>% group_by(YEAR,CONTRIBUTING.FACTOR.VEHICLE.1) %>% 
    summarise(Collision = n()) %>% 
    filter(CONTRIBUTING.FACTOR.VEHICLE.1 != 'Unspecified' & CONTRIBUTING.FACTOR.VEHICLE.1!= 'Traffic Control Device Improper/Non-Working' & CONTRIBUTING.FACTOR.VEHICLE.1!= 'Driverless/Runaway Vehicle' & CONTRIBUTING.FACTOR.VEHICLE.1!= 'Pedestrian/Bicyclist/Other Pedestrian Error/Confusion') %>%
    ggplot(aes(y = CONTRIBUTING.FACTOR.VEHICLE.1,x = YEAR)) +
    geom_raster(aes(fill = Collision)) + 
    scale_x_continuous(breaks = seq(2012,2018)) + 
    scale_fill_gradient(low = "darkgreen",high = "yellow") + 
    ylab("Contributing Factor") + 
    ggtitle("Heatmap of contributing factor vs Year") +
    theme(plot.title = element_text(hjust = 0.5))
  
  })


#output$plot5 <- renderPlot({
 # 
  #vehicle_data %>% group_by(BOROUGH,YEAR) %>% 
   # summarise(person_injured = sum(NUMBER.OF.PERSONS.INJURED),injured = sum(NUMBER.OF.PEDESTRIANS.INJURED),n()) %>%
    #ggplot(aes(x =YEAR,y = person_injured )) + 
    #geom_line(aes(color = BOROUGH)) + 
    #geom_point(aes(color = BOROUGH)) + 
    #geom_text(aes(label = injured),vjust =-1,size = 4,check_overlap = FALSE) + 
    #scale_x_continuous(breaks = seq(2012,2018)) + 
    #ggtitle("Pedestrian Injured vs Year(Boroughwise)") +
    #theme(plot.title = element_text(hjust = 0.5))
  #
  #})

output$plot6 <- renderPlot({
  
  vehicle_data %>% group_by(YEAR,VEHICLE.TYPE.CODE.1) %>% 
    summarise(Pedestrian_injured = sum(NUMBER.OF.PERSONS.INJURED))  %>% 
    ggplot(aes(y =VEHICLE.TYPE.CODE.1,x = YEAR)) +
    geom_raster(aes(fill = Pedestrian_injured)) + 
    scale_x_continuous(breaks = seq(2012,2018)) + 
    scale_fill_gradient(low = "white",high = "red") + 
    ylab("Contributing Vehicle") +
    ggtitle("Heatmap of Contributing Vehicle vs Pedestrian Injured")
  
  })

output$plot7 <- renderPlot({
  vehicle_data %>% group_by(BOROUGH,YEAR) %>% 
    summarise(n = n()) %>% ggplot(aes(x = YEAR,y= n)) + 
    geom_col(aes(fill = BOROUGH)) + 
    facet_grid(~BOROUGH) + 
    ggtitle("Number of Collision by Borough and Year ") + 
    ylab("Number of collision") +
    theme(plot.title = element_text(hjust = 0.5)) + 
    scale_x_continuous(breaks = seq(2012,2018)) + 
    theme(axis.text.x=element_text(angle =45,hjust=1))
  
  })

output$plot8 <- renderPlot({
  vehicle_data %>% group_by(YEAR,WEATHER) %>% 
    summarise(n = n()) %>% ggplot(aes(x = YEAR,y= n)) + 
    geom_col(aes(fill =WEATHER)) + 
    facet_grid(~YEAR) + 
    ggtitle("Number of Collision by Weather Type ") + 
    ylab("Number of collision") +
    theme(plot.title = element_text(hjust = 0.5)) + 
    scale_x_continuous(breaks = seq(2012,2018)) + 
    theme(axis.text.x=element_text(angle =45,hjust=1))
  
})

output$plot9 <- renderPlot({
  vehicle_data %>% group_by(BOROUGH,YEAR,MONTH) %>% 
    summarise(n = n()) %>% ggplot(aes(x = YEAR,y= n)) + 
    geom_col(aes(fill = BOROUGH)) + 
    facet_grid(~MONTH) + 
    ggtitle("Number of Collision by Borough and Month ") + 
    ylab("Number of collision") +
    scale_x_continuous(breaks = seq(2012,2018)) + 
    theme(axis.text.x=element_text(angle =45,hjust=1))
  
})


output$toptable <- DT::renderDataTable({
  df <- read.csv('data/most_accidents.csv')
  datatable(df,options = list(scrollX = TRUE), rownames=FALSE) %>%
    formatStyle(input$selected, background="skyblue", fontWeight='bold')
    #mutate(Action = paste('<a class="go-map" href="" data-lat="', LATITUDE, '" data-long="', LONGITUDE, '" data-zip="', BOROUGH, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    #action <- DT::dataTableAjax(session, df)
    #DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
    
  })
})

  