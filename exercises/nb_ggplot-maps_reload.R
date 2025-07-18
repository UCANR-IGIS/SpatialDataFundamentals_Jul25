## This will load packages and data for nb_ggplot_maps.Rmd

library(sf)
library(dplyr)
library(ggplot2)
library(ggspatial)

## Load the conflicted package
library(conflicted)
conflict_prefer("filter", "dplyr", quiet = TRUE)
conflict_prefer("count", "dplyr", quiet = TRUE)
conflict_prefer("select", "dplyr", quiet = TRUE)
conflict_prefer("arrange", "dplyr", quiet = TRUE)

## Define a convenience constant
epsg_geo_wgs84 <- 4326

## City boundary
sf_citybnd_ll <- st_read("./data/sf_citybnd.geojson")

## City neighborhoods
sf_nb_ll <- st_read(dsn = "./data/sf_nb.geojson")

## Libraries
sf_libraries_ll <- read.csv("./data/sf_libraries_longlat.csv") %>% 
  st_as_sf(coords = c("long", "lat"), crs = epsg_geo_wgs84) %>% 
  select(-score, -locName, -status, -matchAddr, -side, -addressType)
