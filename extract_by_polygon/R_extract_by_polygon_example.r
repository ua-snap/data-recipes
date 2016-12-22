# This script takes a shapefile and a decadal set of a single climate variable (ex: 2010s-2090s LOGS) as inputs. It will compute the mean value of 
# each raster under the specified shapefile extent and output to a csv file.  

# Load the raster library
library(raster)

# Load the path to the data. R needs to have file paths written with forward slashes instead of backslashes. So, if you're copying a location from a Windows environment
# make sure to reorient the slashes. 
rcp45 <- "~/Downloads/decadal_mean"

# Load the shapefile we want to extract under. Obviously you will use the actual name of your shapefile, including the .shp extension. 
# SNAP data is in EPSG 3338: NAD83 Alaska Albers, or noted as Alaska Albers Equal Area Conic in ArcGIS. It is necessary that the
# shapefile and the rasters be in the same projection. 
shp <- shapefile("~/Downloads/Kenai_StudyArea.shp")

# List the .tif files in the directory. For this script to work correctly, the climate data should be the only .tif files in the folder. 
input <- list.files(rcp45, pattern=".tif$", full.names=T, recursive=F)

# Make a dataframe to store extracted values in. This line is specifying for the data frame to have one column that is the
# same length as the number of files in the directory, and initially, is filled with NA values that will be overwritten
# with real data in the next couple of steps. 
d <- data.frame(matrix(NA, nrow=length(input), ncol=1)) 

# Label the column as RCP 4.5
colnames(d) <- "RCP45"

# In a loop, take the mean value of each raster under the shapefile and then round it to a whole number. 
# The value is then placed into the data frame, d, and each file is counted after the loop executes on it. 
for(i in 1:length(input)){
	r <- raster(input[i])
	r.mean <- round(extract(r, shp, mean, na.rm=TRUE),1) 
	d[i,] <- r.mean
	print(length(input)-i+1)	
}

# Make a list of decades corresponding to each file. 
decades <- c("2010s", "2020s", "2030s", "2040s", "2050s", "2060s", "2070s", "2080s", "2090s")

# Add a new column at the beginning of the data frame with the decades and assign it the column name "Decade". 
d <- cbind(Decade=decades, d)

# Writing out the data frame to a csv file. 
write.csv(d, file = "~/results.csv", row.names=FALSE)

