library(rgdal)
library(sp)
library(rgeos)
library(raster)
library(maptools)

# Get spatial data for Australia on country and state levels
gadm0 <- getData("GADM", country = "AUS", level = 0)
gadm1 <- getData("GADM", country = "AUS", level = 1)

# Resample to speed up plotting
aus = gSimplify(gadm0, tol=0.01, topologyPreserve=TRUE)
states = gSimplify(gadm1,tol=0.01, topologyPreserve=TRUE)

# Write states to shape file for later use
IDs <- sapply(slot(states, "polygons"), function(x) slot(x, "ID"))
dfs <- data.frame(rep(0, length(IDs)), row.names=IDs)
statesDF <- SpatialPolygonsDataFrame(states, dfs)
writePolyShape(statesDF, "australianstates")

# Write country to shape file for later use
IDa <- sapply(slot(aus, "polygons"), function(x) slot(x, "ID"))
dfa <- data.frame(rep(0, length(IDa)), row.names=IDa)
ausDF <- SpatialPolygonsDataFrame(aus, dfa)
writePolyShape(ausDF, "australiancountry")

# For fun, plot the country and states
plot(aus)
plot(states, add=TRUE)