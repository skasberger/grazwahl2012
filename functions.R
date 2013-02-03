######################################################
#           								 
#   Title: functions_grw2012.R
#   Description: Functions of the analyses of the 
#								 Grazer Gemeinderatswahlen 2012
#								
#
#   Author: Stefan Kasberger
#   Date: 02.12.2012
#   Version: 1.0
#	  Language: 2.15.2
#   Software: 0.96.330
#   License: FreeBSD (2-clause BSD)
#   												 
######################################################

# splits the spatial area field into parish and district
# variables => data: the whole dataframe; column: number of the dataframe
SplitParishAndDistrict <- function(data, column) {
  data[, column] <- AddZero(data[, column])
  colnames(data)[column] <- "bezirk_sprengel" # static value for column index DEBUG
  
  colDistrict <- substr(data[, column], 1, 2)
  colParish <- substr(data[, column], 3, 4)
  splitUp <- data.frame(cbind(as.integer(colDistrict), as.integer(colParish)))
  colnames(splitUp) <- c("bezirk", "sprengel")
  data <- cbind(splitUp, data)
  data
}

# adds Zero to a integer < 1000 and converts it to character
AddZero <- function(column) {
  for(i in seq_along(column)) {
    if( as.integer(column[i]) < 999) {
      column[i] <- paste0("0", as.character(column[i]))
    }
  }
  column
}

# checks the consistency of data
CheckData <- function(data) {
  head(data)
  tail(data)
  dim(data)
  names(data)
  summary(data)
  class(data)
  sapply(data[1,], class)
  unique(data$ptname)
  unique(data$ptlang)
}

# writes csv file
WriteCSV <- function(data, filename, folder = "QGIS", enc = "UTF-8") {
  write.csv(data, paste0(folder, "/", filename, "_comma[", enc, "].csv"), fileEncoding = enc)
  write.csv2(data, paste0(folder, "/", filename, "_semicolon[", enc, "].csv"), fileEncoding = enc)
}
