######################################################
#           								 
#   Title: grazwahl2012_prepdata.R
#   Description: Prepare data for Analyses and Visualization in R
#													 
#													 
#   Author: Stefan Kasberger
#   Date: 29.11.2012
#   Version: 1.0
#	  Language: 2.15.2
#   Software: 0.96.330
#   License: FreeBSD (2-clause BSD)
#   												 
######################################################

# function to divide bezirk from sprengel in the dataframe
split_sprengel <- function(data) {
  data$sprengel <- add_zero(data$sprengel)
  data <- cbind(data, as.integer(substr(data$sprengel, 1, 2)))
  data$sprengel <- as.integer(substr(data$sprengel, 3, 4))
  names(data)[dim(data)[2]] <- "bezirk"
  data
}

add_zero <- function(data) {
  for(i in seq_along(data)) {
    if(as.integer(data[i]) < 999) {
      data[i] <- paste0("0", as.character(data[i]))
    }
  }
  data
}

##### GEMEINDERATSWAHLEN #####
graz_grw2003_bez <- read.csv2("raw/Graz/2003_grw_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_grw2003_bez$beznr <- graz_grw2003_bez$beznr / 100
graz_grw2003_spr <- read.csv2("raw/Graz/2003_grw_sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_grw2003_spr <- graz_grw2003_spr[, 1:9]
graz_grw2003_spr <- split_sprengel(graz_grw2003_spr)

graz_grw2008_bez <- read.csv2("raw/Graz/2008_grw_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_grw2008_bez$beznr <- graz_grw2008_bez$beznr / 100
graz_grw2008_spr <- read.csv2("raw/Graz/2008_grw_sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_grw2008_spr <- graz_grw2008_spr[,1:9]
graz_grw2008_spr <- split_sprengel(graz_grw2008_spr)

graz_grw2012_bez <- read.csv2("raw/Graz/GRW2012_Sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_grw2012_bez$beznr <- graz_grw2012_bez$beznr / 100
graz_grw2012_spr <- read.csv2("raw/Graz/GRW2012_Sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_grw2012_spr <- graz_grw2012_spr[, 1:10]
graz_grw2012_wb <- read.csv2("raw/Graz/GRW2012_Wahlberechtigte.csv", fileEncoding = "iso-8859-1")
graz_grw2012_spr <- split_sprengel(graz_grw2012_spr)
graz_grw2012_wb <- split_sprengel(graz_grw2012_wb)


##### LANDTAGSSWAHLEN #####
graz_ltw2005_bez <- read.csv2("raw/Graz/2005_ltw_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_ltw2005_bez$beznr <- graz_ltw2005_bez$beznr / 100
graz_ltw2005_spr <- read.csv2("raw/Graz/2005_ltw_sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_ltw2005_spr <- graz_ltw2005_spr[, 1:9]
graz_ltw2005_spr <- split_sprengel(graz_ltw2005_spr)

graz_ltw2010_bez <- read.csv2("raw/Graz/ltw_2010_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_ltw2010_bez$beznr <- graz_ltw2010_bez$beznr / 100
graz_ltw2010_spr <- read.csv2("raw/Graz/ltw_2010_sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_ltw2010_wb <- read.csv2("raw/Graz/ltw_2010_sprengel_wahlbe.csv")
graz_ltw2010_spr <- split_sprengel(graz_ltw2010_spr)

##### NATIONALRATSWAHLEN #####
graz_nrw2006_bez <- read.csv2("raw/Graz/2006_nrw_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_nrw2006_bez$beznr <- graz_nrw2006_bez$beznr / 100
graz_nrw2006_spr <- read.csv2("raw/Graz/2006_nrw_sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_nrw2006_spr <- graz_nrw2006_spr[, 1:9]
graz_nrw2006_spr <- split_sprengel(graz_nrw2006_spr)

graz_nrw2008_bez <- read.csv2("raw/Graz/2008_nrw_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_nrw2008_bez$beznr <- graz_nrw2008_bez$beznr / 100
graz_nrw2008_spr <- read.csv2("raw/Graz/2008_nrw_sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_nrw2008_spr <- split_sprengel(graz_nrw2008_spr)

