# This script takes a shapefile and a decadal set of a single climate variable (ex: 2010s-2090s LOGS) as inputs. The
# inputs should consist of 9 files from decades 2010-2090 from either a single month, DOF/DOT, or LOGS. It will compute
# the mean value of each raster under the specified shapefile extent and output to a csv file.

# Install and load the raster library. During installation the user will be asked to choose a CRAN repository. Either the 
# cloud or one of the US repos are good. 
install.packages("raster")
library(raster)

# Load the path to the data. R needs to have file paths written with forward slashes instead of backslashes. So, if you're copying a location from a Windows environment
# make sure to reorient the slashes.
geotiff_data_path <- "./data"

# Load the shapefile we want to extract under. Obviously you will use the actual name of your shapefile, including the .shp extension.
# SNAP data is in EPSG 3338: NAD83 Alaska Albers, or noted as Alaska Albers Equal Area Conic in ArcGIS. It is necessary that the
# shapefile and the rasters be in the same projection. If not they will need to be re-projected so they are the same, and in most cases
# it would be easier to transform the shapefile.
shp <- shapefile("./Kenai_StudyArea.shp")

# If the shapefile was in the wrong projection the following line could be used to re-project it to NAD83 Alaska Albers using a proj4 string.
shp <- spTransform(shp, "+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

# Name of output data column, i.e. RCP45, RCP60, etc.
rcp <- "RCP60"

# List the .tif files in the directory. For this script to work correctly, the climate data should be the only .tif files in the folder.
input <- list.files(geotiff_data_path, pattern=".tif$", full.names=T, recursive=F)

# Make a dataframe to store extracted values in. This line is specifying for the data frame to have one column that is the
# same length as the number of files in the directory, and initially, is filled with NA values that will be overwritten
# with real data in the next couple of steps.
d <- data.frame(matrix(NA, nrow=length(input), ncol=1))

# Label the column with the correct RCP. RCP 6.0 is the example here and it was defined in line 6, but if using rasters from a different RCP then this line
# would need to reflect that.
colnames(d) <- rcp

# In a loop, take the mean value of each raster under the shapefile and then round it to one digit after the decimal.
# The value is then placed into the data frame, d, and each file is counted after the loop executes on it.
for(i in 1:length(input)){
    r <- raster(input[i])
    r.mean <- round(extract(r, shp, mean, na.rm=TRUE),1)
    d[i,] <- r.mean
    print(paste("Processing layer", input[i]))
}

# Make a list of decades corresponding to each file.
decades <- c("2010s", "2020s", "2030s", "2040s", "2050s", "2060s", "2070s", "2080s", "2090s")

# Add a new column at the beginning of the data frame with the decades and assign it the column name "Decade".
d <- cbind(Decade=decades, d)

# Writing out the data frame to a csv file using the full path. Be sure to include the variable in the filename so you know what
# kind of climate data these values represent. Example, "file = "/path/to/file/RCP45_JanTemp.csv".
write.csv(d, file = "./results.csv", row.names=FALSE)