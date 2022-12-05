library(sf)
library(rvest)
library(stringr)
library(tidyr)
library(shiny)
library(leaflet)
library(DT)

ui <- fluidPage(
  titlePanel("2022 Unofficial General Election Results"),        
  mainPanel(fluidRow(column(width = 8, leafletOutput("myMap")),
                     column(width = 4, 
                            selectInput("selectRace", label = h3("Select Race"), 
                                        choices = list("U.S. Senator"                                             = 212,
                                                       "Representative to Congress 13th District"                 = 213,
                                                       "Governor and Lieutenant Governor"                         = 204,
                                                       "Attorney General"                                         = 205,
                                                       "Auditor of State"                                         = 206,
                                                       "Secretary of State"                                       = 207,
                                                       "Treasurer of State"                                       = 208,
                                                       "Chief Justice of the Supreme Court"                       = 209,
                                                       "Justice of the Supreme Court FTC 1-1-2023"                = 210,
                                                       "Justice of the Supreme Court FTC 1-2-2023"                = 211,
                                                       "State Senator 27th District"                              = 214,
                                                       "State Representative 31st District"                       = 215,
                                                       "State Representative 32nd District"                       = 216,
                                                       "State Representative 33rd District"                       = 217,
                                                       "State Representative 34th District"                       = 218,
                                                       "State Representative 35th District"                       = 219,
                                                       "Judge of the Court of Appeals 9th District FTC 2-9-2023"  = 220,
                                                       "Judge of the Court of Appeals 9th District FTC 2-10-2023" = 221,
                                                       "Judge of the Court of Appeals 9th District FTC 2-11-2023" = 222,
                                                       "Member of County Council at Large"                        = 223,
                                                       "Member of County Council 6th District UTE 12-31-2024"     = 224,
                                                       "Member of State Board of Education 10th District"         = 225,
                                                       "Judge of the Court of Common Pleas FTC 1-5-2023"          = 226,
                                                       "Judge of the Court of Common Pleas UTE 1-1-2025"          = 227,
                                                       "Judge of the Court of Common Pleas FTC 1-6-2023"          = 228,
                                                       "Hudson Mayor"                                             = 229,
                                                       "Twinsburg Mayor"                                          = 230,
                                                       "Member of Council AKRON WARD 1 UTE 12-31-2023"            = 231), 
                                        selected = 212),
                            dataTableOutput("overallDT"))),
            fluidRow(DTOutput("precinctDT"))
  )
)