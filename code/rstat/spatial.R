######################################################
#       										 
#   Description: Get the data into shape files and analyse it spatialy
#													 
#													 
#   Author: Stefan Kasberger
#   Date: 26.11.2012
#   Version: 1.0
#	  Language: 2.15.2
#   Software: 0.96.330
#   License: FreeBSD (2-clause BSD)
#   												 
######################################################


rm(list=ls())
load(paste0(getwd(), "/data/rstat/grazwahlPP2.rda"))
load(paste0(getwd(), "/data/rstat/environment.rda"))

library(foreign)

# Init Variables
environment[["folderDataRawShape"]] <- paste0(environment[["homeDir"]], "/data/raw/shape")
environment[["folderDataShape"]] <- paste0(environment[["homeDir"]], "/data/shape")

# read shapefile
dbfDistricts <- read.dbf(paste0(environment[["folderDataRawShape"]], "/bezirksgrenzen/bezirksgrenzen.dbf"), as.is = TRUE)

dbfDistricts <- dbfDistricts[, -c(3, 4, 5)]

tmp <- data.frame(number=1:17, BEZ_NAME=city[["nameDistricts"]], stringsAsFactors=FALSE)
tmp <- merge(dbfDistricts, tmp, by.x="BEZ_NR", by.y="number")

dbfDistricts <- tmp[, c(2, 1, 5, 3, 4)]
dbfDistricts <- merge(dbfDistricts, votesDistrict, by.x="BEZ_NR", by.y="numDistrict")

# re-order the table to the initial order
dbfDistricts <- dbfDistricts[c(15,4,10,16,7,12,17,11,6,8,1,14,13,2,3,9,5),]

# write dbf-file
environment[["filenameShapeDistrict"]] <- "bezirksgrenzen"
write.dbf(dbfDistricts, paste0(environment[["folderDataShape"]], "/", environment[["filenameShapeDistrict"]]))

rm(tmp)

# SAVE DATA


environment[["filenameDataSpatial"]] <- "grazwahlSpatial.rda"
rm(environment)
save(list=ls(), file="./data/rstat/grazwahlSpatial.rda")
rm(list=ls())
