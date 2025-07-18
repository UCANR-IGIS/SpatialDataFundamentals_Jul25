## We can switch to 'interactive map mode' by running `tmap_mode()`:
  
tmap_mode("view")

## tmap_mode("plot")  # go back to plot mode

# Now that we're in 'view' mode, tmap objects be rendered as little interactive
# maps. We can 'redraw' the last tmap object using `tmap_last()`:

tmap_last()

# Switch-out the basemap:

tm_shape(yose_bnd_utm |> st_geometry()) + 
  tm_polygons(col = "darkgreen", alpha = 0.2, border.col = "darkgreen", lwd = 2) +
tm_shape(yose_roads_utm |> st_geometry()) +
  tm_lines(col = "gray50") +
tm_shape(yose_celltwrs_utm |> st_geometry()) +
  tm_symbols(col = "blue", size = 0.5) +
tm_shape(yose_campgrounds_utm |> st_geometry()) +
  tm_symbols(col = "red", size = 0.5) +
  tm_basemap("Esri.WorldTopoMap")

# Configure Pop-ups

# Lastly we'll disable interactivity (i.e., hover-over text and popup windows)
# on all layers except for the campgrounds:

tm_shape(yose_bnd_utm |> st_geometry()) + 
  tm_polygons(col = "darkgreen", alpha = 0.2, border.col = "darkgreen", lwd = 2, interactive = FALSE) +
  tm_shape(yose_roads_utm |> st_geometry()) +
  tm_lines(col = "gray50", interactive = FALSE) +
  tm_shape(yose_celltwrs_utm |> st_geometry()) +
  tm_symbols(col = "blue", size = 0.5, interactive = FALSE) +
  tm_shape(yose_campgrounds_utm |> select(POINAME)) +
  tm_symbols(col = "red", size = 0.5, id = "POINAME") +
  tm_basemap("Esri.WorldTopoMap")

## Geocode Example
locations_url <- "https://ucdavis.box.com/shared/static/dcer2ucmsc68t810rfvb1zh7pd55o7z7.txt"
locations_chr <- readLines(locations_url)
locations_chr

library(tmaptools)
locations_gc_df <- geocode_OSM(locations_chr)
head(locations_gc_df)

## Turn the data frame object into a sf object
locations_sf <- locations_gc_df |> 
  st_as_sf(coords = c("lon", "lat"), crs = 4236) |> 
  select(query) |> 
  rename(city = query)

tm_shape(locations_sf) + 
  tm_symbols(col = "blue", size = 0.5)

## Leaflet
library(leaflet)
leaflet(locations_sf) |> 
  addTiles() |> 
  addCircleMarkers(radius = 5, popup = ~city,
                   clusterOptions = markerClusterOptions())

