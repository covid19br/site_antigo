##################################
# Biodiversity in National Parks #
# by Alessio Benedetti           #
# server.R file                  #
##################################

library(shiny)
library(tidyverse)
library(leaflet.extras)
library(rvest)

#####################
# SUPPORT FUNCTIONS #
#####################

# function to retrieve a park image from the park wiki page
park_image <- function (park_Name){
  
  #bug1_fix#
  park_WikiUrl <- gsub(" ","_",paste0("https://en.wikipedia.org/wiki/",park_Name))
  #bug1_fix#
  park_Img <- read_html(park_WikiUrl)
  park_Img <- park_Img %>% html_nodes("img")
  
  list_park_Img <- (grepl("This is a featured article", park_Img) | grepl("Question_book-new.svg.png", park_Img) | grepl("Listen to this article", park_Img) | grepl("This is a good article", park_Img))
  park_Img <- park_Img[min(which(list_park_Img == FALSE))]
  
  park_Img <- gsub("\"","'",park_Img)
  park_Img <- gsub("//upload.wikimedia.org","https://upload.wikimedia.org",park_Img)
  park_Img <- sub("<img","<img style = 'max-width:100%; max-height:200px; margin: 10px 0px 0px 0px; border-radius: 5%; border: 1px solid black;'",park_Img)
  
  return(park_Img)
  
}
  
# function that build the park card html pop up
park_card <- function (park_Name, park_Code, park_State, park_Acres, park_Latitude, park_Longitude) {
  
  card_content <- paste0("<style>div.leaflet-popup-content {width:auto !important;}</style>",
                    "<link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.7.1/css/all.css' integrity='sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr' crossorigin='anonymous'>",
                    "<table style='width:100%;'>",
                    "<tr>",
                    "<th><b><h2 style='text-align: left;'>",park_Name,"</h2></b></th>",
                    "<th><img style = 'border:1px solid black;' src='https://www.crwflags.com/art/states/",park_State,".gif' alt='flag' title='Flag of ",state.name[match(park_State,state.abb)]," ' width=80></th>",
                    "</tr>",
                    "</table>",
                    "<div class='flip-card'>",
                      "<div class='flip-card-inner'>",
                        "<div class='flip-card-front'>",
                          "<table style='width:100%;'>",
                            "<tr>",
                              "<td colspan='2'>",park_image(park_Name),"</td>",
                            "</tr>",
                            "<tr>",
                              "<td style='padding: 5px;'><h4><b>Code: </b>",park_Code,"</h4></td>",
                              "<td style='padding: 5px;'><h4><b>Acres: </b>",format(park_Acres, big.mark = ' '),"</h4></td>",
                            "</tr>",
                            "<tr>",
                              "<td style='padding: 5px;'><h4><b>Latitude: </b>",park_Latitude,"</h4></td>",
                              "<td style='padding: 5px;'><h4><b>Longitude: </b>",park_Longitude,"</h4></td>",
                            "</tr>",
                          "</table>",
                        "</div>",
                        "<div class='flip-card-back'>",
                          "<h3>Media links</h3> ",
                          "<hr>",
                          "<table style='width:80%;'>",
                            "<tr>",
                              "<td style='text-align: left; padding-left: 25px;'><h4>Official page:</h4></td>",
                              "<td><a style='color:white;' href='https://www.nps.gov/",park_Code,"/index.htm' target='_blank'><i class='fas fa-globe fa-2x'></i></a></td>",
                            "</tr>",
                            "<tr>",
                              "<td style='text-align: left; padding-left: 25px;'><h4>Wikipedia page:<h4></td>",
                              "<td><a style='color:white' href='https://en.wikipedia.org/wiki/",park_Name,"' target='_blank'><i class='fab fa-wikipedia-w fa-2x'></i></td></p>",
                            "</tr>",        
                            "<tr>",
                              "<td style='text-align: left; padding-left: 25px;'><h4>Pictures:<h4></td>",
                              "<td><a style='color:white' href='https://www.google.com/search?tbm=isch&q=",park_Name,"&tbs=isz:m' target='_blank'><i class='fas fa-images fa-2x'></i></a></td>",
                            "</tr>",
                            "<tr>",
                              "<td style='text-align: left; padding-left: 25px;'><h4>Youtube videos:<h4></td>",
                              "<td><a style='color:white' href='https://www.youtube.com/results?search_query=",park_Name,"' target='_blank'><i class='fab fa-youtube fa-2x'></i></td>",
                            "</tr>",
                          "</table>",
                        "</div>",
                      "</div>",
                    "</div>"
  )
  
  return(card_content)
  
}

##################
# DATA WRANGLING #
##################

# preprocessed parks file:
#   3 records were multi states parks, only was was attributed
#     DEVA,Death Valley National Park,CA/NV,4740912,36.24,-116.82  --> CA
#     GRSM,Great Smoky Mountains National Park,TN/NC,521490,35.68,-83.53 --> TN
#     YELL,Yellowstone National Park,WY/MT/ID,2219791,44.6,-110.5 --> WY
#   added (U.S.) suffix to Glacier National Park record for wiki disambigaution

parks <- read.csv("www/parks.csv")
species <- read.csv("www/species.csv")

# tidy & enrich dataframes
levels(species$Park.Name)[levels(species$Park.Name)=='Glacier National Park'] <- 'Glacier National Park (U.S.)'
parks$Acres <- as.numeric(parks$Acres)
parks$Latitude <- as.numeric(parks$Latitude)
parks$Longitude <- as.numeric(parks$Longitude)

parks <- parks %>%
  mutate(
    ParkRegion = state.region[match(parks$State,state.abb)]
  )

parks$ParkGroup <- ""
parks$ParkGroup[1:28] <- "First Group"
parks$ParkGroup[29:56] <- "Second Group"

species <- species %>%
  mutate(
    ParkRegion = parks$ParkRegion[match(substr(species$Species.ID,1,4),parks[,c("ParkCode")])]
  )

species <- species %>%
  mutate(
    ParkGroup = parks$ParkGroup[match(substr(species$Species.ID,1,4),parks[,c("ParkCode")])]
  )

species <- species %>%
  mutate(
    ParkState = parks$State[match(species$Park.Name,parks$ParkName)]
  )

# support structures
parksNames <- sort(as.character(unique(species[,c("Park.Name")])))
speciesCategories <- sort(as.character(unique(species[,c("Category")])))
speciesCategoriesByState <- species %>% group_by(Category, ParkState) %>% tally(sort=TRUE)
states <- states(cb=T)
speciesStates <- sort(as.character(unique(speciesCategoriesByState$ParkState[complete.cases(speciesCategoriesByState)]))) 

################
# SERVER LOGIC #
################

shinyServer(function(input, output) {
   
 # parks map
 output$parksMap <- renderLeaflet({
  leaflet(data=parks) %>% addProviderTiles(providers$Stamen.Watercolor, group = "Stamen Watercolor", options = providerTileOptions(noWrap = TRUE)) %>%#, minZoom = 4)) %>%
  addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map", options = providerTileOptions(noWrap = TRUE)) %>%
  addProviderTiles(providers$NASAGIBS.ViirsEarthAtNight2012, group = "Nasa Earth at Night", options = providerTileOptions(noWrap = TRUE)) %>%
  addProviderTiles(providers$Stamen.TerrainBackground, group = "Stamen Terrain Background", options = providerTileOptions(noWrap = TRUE)) %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Esri World Imagery", options = providerTileOptions(noWrap = TRUE)) %>%
  addFullscreenControl() %>%
  addMarkers(
    ~Longitude,
    ~Latitude,
    icon = makeIcon(
      iconUrl = "32px-US-NationalParkService-Logo.svg.png",
      shadowUrl = "32px-US-NationalParkService-Logo.svg - black.png",
      shadowAnchorX = -1, shadowAnchorY = -2
    ),
    clusterOptions = markerClusterOptions()
  ) %>%
  addLayersControl(
    baseGroups = c("Stamen Watercolor","Open Street Map","Nasa Earth at Night","Stamen Terrain Background","Esri World Imagery"),
    position = c("topleft"),
    options = layersControlOptions(collapsed = TRUE)
  )
 })
 
 
 # code to load the park card once the click event on a marker is intercepted 
 observeEvent(input$parksMap_marker_click, { 
   pin <- input$parksMap_marker_click
   #print(Sys.time()) #uncomment to log coords
   #print(pin) #uncomment to log coords
   selectedPoint <- reactive(parks[parks$Latitude == pin$lat & parks$Longitude == pin$lng,])
   leafletProxy("parksMap", data = selectedPoint()) %>% clearPopups() %>% 
   addPopups(~Longitude,
             ~Latitude,
             popup = ~park_card(selectedPoint()$ParkName, selectedPoint()$ParkCode, selectedPoint()$State, selectedPoint()$Acres, selectedPoint()$Latitude, selectedPoint()$Longitude)
   )
 })
 
 
 # DT table
 output$speciesDataTable <- renderDataTable(
   species[,-c(8,12,13,14,15,16,17,18)],
   filter = "top",
   colnames = c('Species ID', 'Park name', 'Category', 'Order', 'Family', 'Scientific name', 'Common name', 'Occurence', 'Nativeness' ,'Abundance')
   
 )
 
 # collapsible tree
 output$parkSelectComboTree <- renderUI({
     selectInput("selectedParkTree","Select a park:", parksNames)
 })
 
 output$categorySelectComboTree <- renderUI({
   selectInput("selectedCategoryTree","Select a category:", sort(as.character(unique(species[species$Park.Name==input$selectedParkTree, c("Category")]))))
 })
 
 speciesTree <- reactive(species[species$Park.Name==input$selectedParkTree & species$Category==input$selectedCategoryTree,
                                 c("Category", "Order", "Family","Scientific.Name")])
 
 output$tree <- renderCollapsibleTree(
   collapsibleTree(
     speciesTree(),
     root = input$selectedCategoryTree,
     attribute = "Scientific.Name",
     hierarchy = c("Order", "Family","Scientific.Name"),
     fill = "Green",
     zoomable = FALSE
   )
 )
 
 # ggplot2 charts
 output$categorySelectComboChart <- renderUI({
   selectInput("selectedCategoryChart","Select a category:", speciesCategories)
 })
 
 speciesGgplot1 <- reactive(species[species$ParkGroup == 'First Group' & species$Category==input$selectedCategoryChart,])
 speciesGgplot2 <- reactive(species[species$ParkGroup == 'Second Group' & species$Category==input$selectedCategoryChart,])
 
 output$ggplot2Group1 <- renderPlot({
   
   g1 <- ggplot(data = speciesGgplot1()) + stat_count(mapping = aes(x=fct_rev(Park.Name)), fill="green3") + labs(title="Species' count per park [A-Hal]", x ="Park name", y = paste0("Total number of ", input$selectedCategoryChart)) + coord_flip() + theme_classic() + geom_text(stat='count', aes(fct_rev(Park.Name), label=..count..), hjust=2, size=4)
   print(g1)
   
 })
 
 output$ggplot2Group2 <- renderPlot({
   
   g2 <- ggplot(data = speciesGgplot2()) + stat_count(mapping = aes(x=fct_rev(Park.Name)), fill="green3") + labs(title="Species' count per park [Haw-Z]", x ="Park name", y = paste0("Total number of ", input$selectedCategoryChart)) + coord_flip() + theme_classic() + geom_text(stat='count', aes(fct_rev(Park.Name), label=..count..), hjust=2, size=4)
   print(g2)
   
 })
 
 # leaflet choropleth
 output$statesSelectCombo <- renderUI({
   selectInput("statesCombo","Select a state:", paste0(state.name[match(speciesStates,state.abb)]," (",speciesStates,")"))
 })
 
 output$categorySelectComboChoro <- renderUI({
   selectInput("selectedCategoryChoro","Select a category:", speciesCategories)
 })
 
 selectedChoroCategory <- reactive(speciesCategoriesByState[speciesCategoriesByState$Category==input$selectedCategoryChoro,])
 selectedChoroCategoryJoinStates <- reactive(geo_join(states, selectedChoroCategory(), "STUSPS", "ParkState"))
 
 output$stateCategoryList <- renderTable({
   speciesCategoriesByState[speciesCategoriesByState$ParkState == substr(input$statesCombo,nchar(input$statesCombo)-2,nchar(input$statesCombo)-1), c("Category","n")]
 },colnames = FALSE) 
 
   
 output$choroplethCategoriesPerState <- renderLeaflet({

   leaflet(options = leafletOptions(zoomControl = FALSE)) %>% htmlwidgets::onRender("function(el, x) {L.control.zoom({ position: 'topright' }).addTo(this) }") %>%
     addProviderTiles("CartoDB.PositronNoLabels") %>%
     setView(-98.483330, 38.712046, zoom = 4) %>%
     addPolygons(data = selectedChoroCategoryJoinStates(),
                 fillColor = colorNumeric("Greens", domain=selectedChoroCategoryJoinStates()$n)(selectedChoroCategoryJoinStates()$n),
                 fillOpacity = 0.7,
                 weight = 0.2,
                 smoothFactor = 0.2,
                 highlight = highlightOptions(
                   weight = 5,
                   color = "#666",
                   fillOpacity = 0.7,
                   bringToFront = TRUE),
                 label = paste0("Total of ", as.character(selectedChoroCategoryJoinStates()$n)," species in ",as.character(selectedChoroCategoryJoinStates()$NAME)," (",as.character(selectedChoroCategoryJoinStates()$STUSPS),").")) %>%
     addLegend(pal = colorNumeric("Greens", domain=selectedChoroCategoryJoinStates()$n),
               values = selectedChoroCategoryJoinStates()$n,
               position = "bottomright",
               title = input$selectedCategoryChoro)

 })

})