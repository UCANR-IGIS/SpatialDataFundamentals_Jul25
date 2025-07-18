## Required packages
pkgs_req <- c("sf", "leaflet", "tmap", "tmaptools", "leaflet", "ggmap", 
              "RColorBrewer", "raster", "maps", "tidyverse",  "jsonlite", 
              "rasterVis", "nngeo", "lwgeom", "remotes", 
              "conflicted", "tigris", "tidycensus", "stars",
              "googlesheets4", "httr", "rjson", "usethis", "rinat",
              "ggspatial", "rosm", "ggimage", "wrkshputils", "palmerpenguins", "here",
              "terra")

## See which ones are missing
(pkgs_missing <- pkgs_req[!(pkgs_req %in% installed.packages()[,"Package"])])

## Install missing ones
if (length(pkgs_missing)) install.packages(pkgs_missing, dependencies=TRUE,
                                           repos = c('https://cloud.r-project.org', 
                                                     'https://ajlyons.r-universe.dev'))

## Re-run the check for missing packages
pkgs_missing <- pkgs_req[!(pkgs_req %in% installed.packages()[,"Package"])]
if (length(pkgs_missing)==0) cat("ALL PACKAGES WERE INSTALLED SUCCESSFULLY \n")

##########################################
## TIPS
##
## If you are prompted by the question, 'Do you want to install from sources the 
## package which needs compilation?', select 'No'.
##
## If you get an error message that a package can't be installed because 
## it's already loaded and can't be stopped, restart R (Session >> Restart R), 
## and try again.
##
##########################################

