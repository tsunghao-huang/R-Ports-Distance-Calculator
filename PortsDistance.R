library(rgdal)
library(raster)
library(gdistance)
library(foreach)
library(doParallel)

#Creat an empty raster
new = raster(ncol=360*3, nrow= 180*3)
projection(new) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

#Import Shapefile
map <- readOGR(dsn = "/Users/j22700126/Desktop/Project Seminar/Distance Calculator/ne_50m_admin_0_countries/" , layer = "ne_50m_admin_0_countries")
plot(map)
#rasterize the map to raster map
r <- rasterize(map, new)


#Replace value with 1, 99999 to the point where ship can go and cannot
values(r)[is.na(values(r))] <- 1
values(r)[values(r)>1] <- 99999
writeRaster(r, "/Users/j22700126/Desktop/map", format = "GTiff")
plot(r)
points(port$longitude, port$latitude, col = "red", cex = 0.01)

#Prepare transition object
p <- transition(r, function(x){1/mean(x)}, 8)
p <- geoCorrection(p)

#Imort and transform port data to dataframe object
ports <- data.frame(port)

#Self defined distance calculator, iput two pairs of longitude and latitude to get the shortest distance
DistanceCalculator <- function(port1, port2){
  path <- shortestPath(p, port1, port2, output = "SpatialLines")
  plot(r)
  lines(path)
  return(SpatialLinesLengths(path ,longlat=TRUE)*0.539957)
}

#Test 
ptm = proc.time()
DistanceCalculator(cbind(ports[2206,2],ports[2206,3]),cbind(ports[3505,2],ports[3505,3]))
proc.time() - ptm
#Loop 
x = data.frame(port1=character(), port2=character(), distance=numeric(), stringsAsFactors = FALSE)
for(i in 1:10){
  for(j in 1:i){
    x[nrow(x)+1, ] = c(ports$Port[j], ports$Port[1+i],
                       DistanceCalculator(cbind(ports[j,2],ports[j,3]),cbind(ports[1+i,2],ports[1+i,3])))
  }
}

#Just some other Tests not necessary to run
path <- shortestPath(p, cbind(port[1,2],port[1,3]),cbind(port[2392,2],port[2392,3]), output = "SpatialLines")
SpatialLinesLengths(path ,longlat=TRUE)
print(path)
lines(path)