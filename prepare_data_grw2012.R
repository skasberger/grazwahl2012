######################################################
#           								 
#   Description: 
#        Prepare data of the Grazer Gemeinderatswahlen 2012 for processing and analyses
#
#   Author: Stefan Kasberger
#   Date: 29.11.2012
#   Version: 1.0
#	  Language: 2.15.2
#   Software: 0.96.330
#   License: FreeBSD (2-clause BSD)
#   												 
######################################################

#---
####  DICTIONARY  ####
#---

# Sprengel = parish
# Bezirk = district
# berechtigte WählerInnen = authorized voters
# Wahlbeteiligung = voters participation

#---
####  INITIALIZE  ####
#---

rm(list=ls())

# Load Functions
source("functions.R")

# Initialize Variables
nameDistricts <- (c("Innere Stadt", "St. Leonhard", "Geidorf", "Lend", "Gries", 
                "Jakomini", "Liebenau", "St. Peter", "Waltendorf", "Ries", "Mariatrost", 
                "Andritz", "Gösting", "Eggenberg", "Wetzelsdorf", "Straßgang", "Puntigam"))
numDistricts <- length(nameDistricts)
numVotDistricts <- numDistricts + 1
numberParties <- 11L

workDir <- getwd()
folderRaw <- paste0(workDir, "/data/raw/grw2012")
folderSpatialRaw <- paste0(workDir, "/data/raw/spatial")

# column names
colNameAllVotesAbs <- "stimmen_abs"
colNameValidVotesAbs <- "stimmen_gueltig_abs"
colNameValidVotesRel <- "stimmen_gueltig_rel"
colNameUnvalidVotesAbs <- "stimmen_ungueltig_abs"
colNameUnvalidVotesRel <- "stimmen_ungueltig_rel"
colNameAuthVotersAbs <- "wahlber_alle_abs"
colNameAuthFemaleVotersAbs <- "wahlber_Frauen_abs"
colNameAuthFemaleVotersRel <- "wahlber_Frauen_rel"
colNameAuthMaleVotersAbs <- "wahlber_Maenner_abs"
colNameAuthMaleVotersRel <- "wahlber_Maenner_rel"
colNameListplace <- "Listenplatz"
colNameDistrict <- "bezirk"
colNameParish <- "sprengel"
colNameParishDistrict <- "bezirk_sprengel"
colNamePartyShortname <- "partei_kuerzel"
colNamePartyName <- "parteiname"
colNameVotes <- "stimmen"

#---                     ----
####  OPEN & CHECK DATA  ####
#---                     ----

# open results of the districts and remove clutter
rawVotesDistrict <- read.csv2(paste0( folderRaw, "/GRW2012_Sprengelbezerg.csv" ), fileEncoding = "iso-8859-1")
votesDistrict <- rawVotesDistrict
votesDistrict <- votesDistrict[, c("beznr", "ptname", "listenplatz", "stimmen")]
  
# open results of the parishes and remove clutter
rawVotesParish <- read.csv2(paste0( folderRaw, "/GRW2012_Sprengelerg.csv" ), fileEncoding = "iso-8859-1")
votesParish <- rawVotesParish
votesParish <- votesParish[, c("sprengel", "ptname", "listenplatz", "stimmen")]

# open authorized voters and remove clutter
rawAvParish <- read.csv2(paste0( folderRaw, "/GRW2012_Wahlberechtigte.csv" ), fileEncoding = "iso-8859-1")
avParish <- rawAvParish
avParish <- avParish[, c("sprengel", "wahlbe_gesamt", "wahlbe_mann", "wahlbe_frau")]

# Check data
# CheckData(votesDistrict) DEBUG
# CheckData(votesDistrict) DEBUG
# conclusion:
# missing value short party name of Einsparkraftwerk
# everything else okay

#---
####  TIDY DATA  ####
#---

# correct parish & district columns
# columns: bezirk, sprengel, bezirk_sprengel, gesamt, unguel, gueltig
avParish <- SplitParishAndDistrict(avParish, 1)
votesParish <- SplitParishAndDistrict(votesParish, 1)
authorizedVotersDistrict <- rawVotesDistrict[, c("beznr", "gesamt", "unguel", "gueltig", "sprengelanzahl")]
authorizedVotersParish <- rawVotesParish[, c("sprengel", "gesamt", "unguel", "gueltig")]
votesDistrict$beznr <- votesDistrict$beznr / 100
authorizedVotersDistrict$beznr <- authorizedVotersDistrict$beznr / 100
authorizedVotersParish <- SplitParishAndDistrict(authorizedVotersParish, 1)

# delete duplicate rows
authorizedVotersDistrict <- authorizedVotersDistrict[!duplicated(authorizedVotersDistrict),]
rownames(authorizedVotersDistrict) <- 1:numDistricts
authorizedVotersParish <- authorizedVotersParish[!duplicated(authorizedVotersParish),]

# correct party short name of Einsparkraftwerk
levels(votesDistrict$ptname)[1] = "EKW"
levels(votesParish$ptname)[1] = "EKW"

# assign allowed, valid and unvalid votes to every district
# column: add all votes, valid votes and unvalid votes
avParish <- cbind(avParish, authorizedVotersParish[, c("gesamt", "gueltig", "unguel")])


##  FINAL DATA 
#================================================
#
# avParish 
#   rows: ascending number
#   cols: district, parish, district and parish, authorized voters, authorized male voters, authorized female voters, 
#         all votes, valid votes, unvalid votes, 
#
# votesDistrict
#   rows: ascending number
#   cols: district, short name party, list place, votes
#
# votesParish
#   rows: ascending number
#   cols: district, parish, district and parish, short name party, list place, votes
#
#================================================
