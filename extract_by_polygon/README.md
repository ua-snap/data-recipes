# How to use this script

This script can be used to create a timeseries CSV of averages for data over a spatial domain (shapefile) from SNAP downscaled climate data.

## Prequisites

 - R language (`Rscript`) V3.3.3 with `rgdal`, `raster` installed.
 - `git` installed

## Recipe

 1. Clone this repo to some location, say `~/repos/`: `cd ~/repos && git clone https://github.com/ua-snap/data-recipes`
 1. [Download this file](http://data.snap.uaf.edu/data/Base/AK_CAN_2km/projected/AR5_CMIP5_models/Projected_Monthy_and_Derived_Temperature_Products_2km_CMIP5_AR5/derived/tas_decadal_summaries_AK_CAN_2km_5modelAvg_rcp60.zip) and extract it to `~/repos/data-recipes/extract_by_polygon/source`.
 1. Copy just the data of interest into a working data directory&mdash;here, we will use `tas_decadal_mean_annual_mean` (annual decadal mean temperatures)&mdash;for the time series.  `cp source/tas_decadal_mean_annual_mean* data/`
 1. Run the R script: `Rscript ./R_extract_by_polygon_example.r`.  After it's done, there will be a file, `results.csv`, with the timeseries of averaged values over that time domain.

# How could this be extended?

 * Chose a different shapefile to examine change over time for a different area of interest
 * Use a different set of input files for a different variables or RCP.  Can you create a program that shows the differences between RCP4.5 and RCP6.0 for a given area of interest?

