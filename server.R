library(sf)
library(rvest)
library(stringr)
library(tidyr)
library(shiny)
library(leaflet)
library(DT)
library(leafpop)

overall.df <- read.csv("data/overall.df.csv")
election.df <- read.csv("data/election.df.csv")

colnames(election.df)[colnames(election.df) == "precName"] <- "Precinct"

dem_df <- st_read("data/dem_df.shp")
rep_df <- st_read("data/rep_df.shp")

dem_df[dem_df$RACE == "223", "MARGIN"] <- (dem_df[dem_df$RACE == "223", "MARGIN"]/3)[,1]
rep_df[rep_df$RACE == "223", "MARGIN"] <- (rep_df[rep_df$RACE == "223", "MARGIN"]/3)[,1]

dem_min_max_values <- range(abs(dem_df$MARGIN), na.rm = TRUE)
rep_min_max_values <- range(abs(rep_df$MARGIN), na.rm = TRUE)

#fix palettes
dem_palette <- colorNumeric(palette = "Blues", 
                            domain=c(dem_min_max_values[1], dem_min_max_values[[2]]))

rep_palette <- colorNumeric(palette = "Reds", 
                            domain=c(rep_min_max_values[1], rep_min_max_values[2]))

server <- function(input, output, session){ 
  overall <- reactive({
    overall.df[overall.df$raceNo %in% input$selectRace, c("Candidate", "Party", "Votes")]
  })
  
  output$overallDT <- renderDataTable(
    datatable(overall(),
              options = list(dom = 't'),
              rownames= FALSE) %>%
      formatCurrency("Votes", 
                     currency = "", 
                     interval = 3, 
                     mark = ",",
                     digits = 0)
    
  )
  
  precinct <- reactive({
    pivot_wider(data = election.df[election.df$raceNo %in% input$selectRace, c("precNo", "Precinct", "candName", "votes", "Turnout")], 
                names_from = candName, 
                values_from = votes,
                names_sort = TRUE, 
                names_glue = gsub("\\.", " ", "{candName}"))
  })
  
  output$precinctDT <- renderDataTable(
    datatable(precinct()[,-1])
  )
  
  dem_map <- reactive({
    merge(dem_df[dem_df$RACE %in% input$selectRace, c("PRECINC", "MARGIN", "geometry")], precinct(), by.x = "PRECINC", by.y = "precNo")
  })
  
  rep_map <- reactive({
    merge(rep_df[rep_df$RACE %in% input$selectRace, c("PRECINC", "MARGIN", "geometry")], precinct(), by.x = "PRECINC", by.y = "precNo")
  })

  output$myMap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron")  %>%
      
      addPolygons(
        data = dem_map(),
        fillColor = ~dem_palette(dem_map()$MARGIN),
        popup = popupTable(x = dem_map(),
                           zcol = c(-1:-2, -ncol(dem_map())),
                           row.numbers = F, 
                           feature.id = F),
        stroke = TRUE,
        smoothFactor = 0.2,
        fillOpacity = 2,
        color = "#666",
        weight = 1) %>%
      
      addPolygons(
        data = rep_map(),
        fillColor = ~rep_palette(rep_map()$MARGIN),
        popup = popupTable(x = rep_map(),
                           zcol = c(-1:-2, -ncol(rep_map())),
                           row.numbers = F, 
                           feature.id = F),
        stroke = TRUE,
        smoothFactor = 0.2,
        fillOpacity = 2,
        color = "#666",
        weight = 1)
  })
  
}