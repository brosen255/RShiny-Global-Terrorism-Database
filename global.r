library(shinydashboard)
library(shiny)
library(maps)
library(leaflet)
library(dplyr)
library(maptools)
library(htmltools)
library(htmlwidgets)
library(shinythemes)
library(ggplot2)
library(readr)
library(rgdal)
library(sp)
library(GISTools)
library(rgdal)


df9 <- read_csv("df9.csv")
grouped_csv = read_csv("grouped_csv.csv")
grouped_file = read_csv("grouped_file.csv")
graph_data = read_csv("graph_data.csv")
world_spdf=readOGR(dsn= getwd() , layer="TM_WORLD_BORDERS_SIMPL-0.3")
sp_df <- merge(world_spdf, grouped_csv, by.x="ISO3", by.y="abb")


mybins=c(1, 16, 50 ,75,400, 1000, 2000, 5000, 25000)
mypalette = colorBin(palette="YlOrBr", domain=sp_df@data$freq, na.color="transparent", bins=mybins)

              
mytext=paste0('<strong>', 'Country: ',sp_df@data$NAME,'</strong>', '<br/>',
              "Total: ", sp_df@data$freq,"<br>","Most Common... ","<br/>", "Attack Type: ", 
            sp_df@data$mode_type, "<br>", "Target: ", sp_df@data$mode_target, "<br/>", 
            "Weapon: ", sp_df@data$mode_weapontype, sep="") %>% 
            lapply(htmltools::HTML)
  

Map <- leaflet(sp_df) %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  setView(lng = 48.567215, lat = 41.822582, zoom = 1) %>%
  addPolygons(fillColor = ~mypalette(freq), stroke = TRUE, fillOpacity = .6, color = "white", weight = .3,
              highlight = highlightOptions( weight = 5, fillOpacity = 0.8, bringToFront = TRUE),
              label = mytext,
              labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "11px", direction = "auto")) %>%
  addLegend(pal=mypalette, values=~freq, opacity=0.9, title = "Total Number of Attacks", position = "bottomleft" )





# # # # # # # # # # # # 
# The code below is how I created the grouped datasets and merged the spatial objects with
# dataframe objects

#grouped_file <- terror_df %>% group_by(region_txt,attacktype1_txt) %>%
  #summarise(freq = n(),)

# grouped_csv <- terror_df %>% group_by(country_txt) %>%
#   summarise(mode_type = tail(names(sort(table(attacktype1_txt))), 1),
#             mode_targ = tail(names(sort(table(targtype1_txt))), 1),
#             avg_success = mean(success),
#              mode_weapontype = tail(names(sort(table(weaptype1_txt))), 1))



#
# 
#grooper <- read_csv("~/Desktop/grouped_csv.csv")
#download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="world_shape_file.zip")
#system("unzip world_shape_file.zip")
# world_spdf=readOGR( dsn= getwd() , layer="TM_WORLD_BORDERS_SIMPL-0.3")
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "New Hebrides",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Republic of the Congo",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "East Germany (GDR)",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "West Germany (FRG)",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Czechoslovakia",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Serbia-Montenegro",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "South Vietnam",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Kosovo",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Macau",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Rhodesia",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Soviet Union",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Yugoslavia",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "North Yemen",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "South Yemen",]
#grouped_csv <- grouped_csv[!grouped_csv$country_txt == "Zaire",]
# grouped_csv <- grouped_csv[!grouped_csv$country_txt == "International",]
# grouped_csv[139,2] <- "RUS"
# grouped_csv[140,2] <- "RWA"
# rownames(grouped_csv)=NULL
# require(sp)
#sp_df<- merge(world_spdf, grouped_csv, by.x="ISO3", by.y="abb")
# writeOGR(sp_df, dsn = '/Users/Ben/Desktop/DSA', layer = 'sp_df', driver="ESRI Shapefile")

#graph_data <- terror_df %>% group_by(iyear,region_txt,country_txt) %>%
#summarise(freq = n(),)
#country_group <- terror_df %>% group_by(iyear,region_txt,country_txt) %>%
#summarise(freq = n(),)

#df9<- terror_df[terror_df[, "iyear"] == 2017,]
#df9 <- df9 %>% select(iyear,country_txt,latitude,longitude,success, suicide,attacktype1_txt,imonth,targtype1_txt,nkill)

