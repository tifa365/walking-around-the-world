set.seed(456)
#install.packages
library(tidyverse)
library(leaflet)
library(httr)

#read in csv
df <- read.csv(file = 'walk-the-world-videos.csv')

#drop index-column
video_df = subset(df, select = -c(X))

video_df$new <- gsub("\\[|\\]", "", video_df$lat.lon)

new_video <- video_df %>%
  separate(new, c("longitude", "latitude"), ", ")


#check whether all links exist with custom function

# urls <- select(video_df, video_url)
# 
# valid_url <- function(url_in,t=2){
#   con <- url(url_in)
#   check <- suppressWarnings(try(open.connection(con,open="rt",timeout=t),silent=T)[1])
#   suppressWarnings(try(close.connection(con),silent=T))
#   ifelse(is.null(check),TRUE,FALSE)
# }
# 
# sapply(urls,valid_url)

new_video$lat <- parse_number(new_video$latitude)
new_video$lon <- parse_number(new_video$longitude)

new_video$embedded_video_urls <- paste('<iframe width="310" height="175" src=\"', new_video$video_url, '\"title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>', sep = "")

icons <- awesomeIcons(
  icon = 'fa-youtube-play',
  library = 'fa',
  markerColor = 'red'
)
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addAwesomeMarkers(data=new_video,
                    lng=~lon, 
                    lat=~lat, 
                    icon=icons,
                    clusterOptions = markerClusterOptions(),
                    popup= ~paste(new_video$video_title, new_video$embedded_video_urls))
m  # Print the map




x <- GET(new_video$video_url)
new_video$status-code <- status_code(GET(new_video$video_url))

new_video$test <- map(new_video$video_url, GET())

check_url_status <- function(x) {
  temp_url <- GET(x)
  status <- status_code(temp_url)
  return(status)
}

new_video$url_status <- map(check_url_status, new_video$video_url)

new_video$url_status <- lapply(new_video$video_url, check_url_status)

#edit(new_video)