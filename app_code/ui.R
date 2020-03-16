##################################
# Biodiversity in National Parks #
# by Alessio Benedetti           #
# ui.R file                      #
##################################

library(leaflet)
library(shinydashboard)
library(collapsibleTree)
library(shinycssloaders)
library(DT)
library(tigris)

###########
# LOAD UI #
###########

shinyUI(fluidPage(
  
  # load custom stylesheet
  includeCSS("www/style.css"),
  
  # load google analytics script
  tags$head(includeScript("www/google-analytics-bioNPS.js")),
  
  # remove shiny "red" warning messages on GUI
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  # load page layout
  dashboardPage(
    
    skin = "green",
      
    dashboardHeader(title="Covid-19 Brazil", titleWidth = 300),
    
    dashboardSidebar(width = 300,
      sidebarMenu(
        HTML(paste0(
          "<br>",
          "<a href='https://www.ift.unesp.br' target='_blank'><img style = 'display: block; margin-left: auto; margin-right: auto;' src='logo-vertical-branco-01.png' width = '186'></a>",
          "<br>",
          "<p style = 'text-align: center;'><small><a href='covid19br.github.io' target='_blank'>Covid-19 Observatory in Brazil</a></small></p>",
          "<br>"
        )),
        ####
        ####
        ####
        # CHANGE TAB NAMES AND ICONS ACCORDINGLY
        menuItem("Home", tabName = "home", icon = icon("home")),
        menuItem("Cases by state", tabName = "map", icon = icon("thumbtack")),
        menuItem("Doubling rate", tabName = "table", icon = icon("stats", lib = "glyphicon")),
        menuItem("Brazil compared to the World", tabName = "tree", icon = icon("map marked alt")),
        #menuItem("Species Charts", tabName = "charts", icon = icon("stats", lib = "glyphicon")),
        menuItem("Disclaimers", tabName = "choropleth", icon = icon("tasks")),
        menuItem("About", tabName = "releases", icon = icon("table")),
        HTML(paste0(
          "<br><br><br><br><br><br><br><br><br>",
          "<table style='margin-left:auto; margin-right:auto;'>",
            "<tr>",
              "<td style='padding: 5px;'><a href='https://www.facebook.com/nationalparkservice' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
              "<td style='padding: 5px;'><a href='https://www.youtube.com/nationalparkservice' target='_blank'><i class='fab fa-youtube fa-lg'></i></a></td>",
              "<td style='padding: 5px;'><a href='https://www.twitter.com/natlparkservice' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
              "<td style='padding: 5px;'><a href='https://www.instagram.com/nationalparkservice' target='_blank'><i class='fab fa-instagram fa-lg'></i></a></td>",
              "<td style='padding: 5px;'><a href='https://www.flickr.com/nationalparkservice' target='_blank'><i class='fab fa-flickr fa-lg'></i></a></td>",
            "</tr>",
          "</table>",
          "<br>"),
        HTML(paste0(
          "<script>",
            "var today = new Date();",
            "var yyyy = today.getFullYear();",
          "</script>",
          "<p style = 'text-align: center;'><small>&copy; - <a href='https://alessiobenedetti.com' target='_blank'>alessiobenedetti.com</a> - <script>document.write(yyyy);</script></small></p>")
        ))
      )
      
    ), # end dashboardSidebar
    
    dashboardBody(
      
      tabItems(
        
        tabItem(tabName = "home",
          
          # home section
          includeMarkdown("www/home.md")
          
        ),
        
        tabItem(tabName = "map",
        
          # parks map section
          leafletOutput("parksMap") %>% withSpinner(color = "green")
                
        ),
        
        tabItem(
          # species data section
          tabName = "table", dataTableOutput("speciesDataTable") %>% withSpinner(color = "green")
          
        ),
        
        tabItem(tabName = "tree", 
              
          # collapsible species tree section
          includeMarkdown("www/tree.md"),
          column(3, uiOutput("parkSelectComboTree")),
          column(3, uiOutput("categorySelectComboTree")),
          collapsibleTreeOutput('tree', height='700px') %>% withSpinner(color = "green")
          
        ),
      
        tabItem(tabName = "charts",
          
          # ggplot2 species charts section
          includeMarkdown("www/charts.md"),
          fluidRow(column(3, uiOutput("categorySelectComboChart"))),
          column(6, plotOutput("ggplot2Group1") %>% withSpinner(color = "green")),
          column(6, plotOutput("ggplot2Group2") %>% withSpinner(color = "green"))
          
        ), 
        
        tabItem(tabName = "choropleth",
          
          # choropleth species map section
          includeMarkdown("www/choropleth.md"),
          fluidRow(
            column(3, uiOutput("statesSelectCombo")),
            column(3, uiOutput("categorySelectComboChoro"))
          ),
          fluidRow(
            column(3,tableOutput('stateCategoryList') %>% withSpinner(color = "green")),
            column(9,leafletOutput("choroplethCategoriesPerState") %>% withSpinner(color = "green"))
          )
          
        ),
        
        tabItem(tabName = "releases", includeMarkdown("www/releases.md"))
              
      )
    
    ) # end dashboardBody
  
  )# end dashboardPage

))