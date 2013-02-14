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
#   Software: RStudio 0.97.311
#   License: FreeBSD (2-clause BSD)
#   												 
######################################################

#
# Extracts the district out of the parish number
#
# variables
# data: the whole dataframe; 
# colParish: name of the column for the parish
# colDistrict: name of the column for the district
#

ExtractDistrict <- function(data, colParish="numParish", colDistrict="numDistrict") {
  library(stringr)
  temp <- data
  temp[[colParish]] <- NULL
  data <- as.character(data[[colParish]])
  length <- str_length(data)
  district <- str_sub(data, end = length - 2)
  data <- data.frame(as.numeric(data), as.numeric(district), temp)
  names(data)[1] <- colParish
  names(data)[2] <- colDistrict
  rm(temp, length, district)
  data
}

#
# reduce rows into one row per parish and transform the rows with votes per party into columns
#
# variables
#   data: the comlete table (dataframe)
#   colVotes: column name with the votes
#   colParty: column name with the party acronym
#

TransformVotes <- function(data, colVotes, colParty, numParties) {
  # save numbers of parishes and districts 
  tmp <- data[, c("numParish", "numDistrict")]
  tmp <- tmp[!duplicated(tmp),]
  
  # save 
  data <- data[, c("acrParty", "votes")]
  
  rows <- length(data[[colVotes]]) / numParties
  
  new <- data[[colVotes]]
  dim(new) <- c(numParties, rows)
  new <- data.frame(t(new))
  
  colNames <- lapply(data[1:numParties, colParty], paste0, "abs")
  names(new) <- colNames
  data <- cbind(tmp, new)
}


#
# DESCRIPTION
#
# variables
#

SaveJSON <- function(data) {
  filename <- paste0(environment[["folderDataJSON"]], names(data), ".json")
  write(data[[1]],filename)
}


#
# DESCRIPTION
#
# variables
#

WriteCSV <- function(data, filename, folder = "QGIS", enc = "UTF-8") {
  write.csv(data, paste0(folder, "/", filename, "_comma[", enc, "].csv"), fileEncoding = enc)
  write.csv2(data, paste0(folder, "/", filename, "_semicolon[", enc, "].csv"), fileEncoding = enc)
}

