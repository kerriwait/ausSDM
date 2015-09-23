library(maps)
library(mapdata)
library(maptools)
library(raster)
library(sp)
library(rgeos)

# Function to rescale the images from 0:1000 to 0:1 without normalising
rasterRescale<-function(r){
	r/1000
}

# Determine the directory that the script lives in
script.dir <- dirname(sys.frame(1)$ofile)
setwd(script.dir)

# Define the limits of the box that contains Australia
xc <- c(112.905, 153.995)
yc <- c(-43.725, -9.005)

# Base map of Australia with ocean coloured in
map("worldHires", "australia", xlim=xc, ylim=yc, bg="#B6D1D0")

# Load image and scale it to 0:1
rawimage <- raster('proj_current_Eudyptula.minor-2.tif')
scaledimage <- rasterRescale(rawimage)

# Define the colour range used for the legend
colfunc <- colorRampPalette(c('white', '#D60F19'))

# Plot the scaled image, restricted to Australian bounding box, with limit of 0:1 for probabilities
plot(scaledimage, add=TRUE, col=colfunc(11), xlim=c(112.905,153.995), ylim=c(-43.725, -9.005), zlim=c(0,1))

# Get spatial data for Australia on country and state levels
if (file.exists('australiancountry.shp')) {
	print("Australian country shapefile already exists...")
	aus <- readShapePoly('australiancountry')
} else {
	print("Fetching data from GADM...")
	gadm0 <- getData("GADM", country = "AUS", level = 0)
	aus <- gSimplify(gadm0, tol=0.01, topologyPreserve=TRUE)
}

if (file.exists('australianstates.shp')) {
	print("Australian state shapefile already exists...")
	states <- readShapePoly('australianstates')
} else {
	print("Fetching data from GADM...")
	gadm1 <- getData("GADM", country = "AUS", level = 1)
	states <- gSimplify(gadm1,tol=0.01, topologyPreserve=TRUE)
}

# Plot the country and states over the occurence data
plot(aus, add=TRUE, xlim=c(112.905,153.995), ylim=c(-43.725, -9.005))
plot(states, add=TRUE, xlim=c(112.905,153.995), ylim=c(-43.725, -9.005))