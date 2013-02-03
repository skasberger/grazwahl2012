######################################################
#           								 
#   Description: 
#        Prepare data of the Grazer Gemeinderatswahlen 2012 for processing and analyses
#
#   Author: Stefan Kasberger
#   Date: 29.11.2012
#   Version: 1.0
#	  Language: 2.15.2
#   Software: RStudio 0.97.311
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
eleData <- list(numDistricts, numVotDistricts, numberParties)
names(eleData) <- c("numDistricts", "numVotDistricts", "numberParties")
rm(numDistricts, numVotDistricts, numberParties)
  
workDir <- getwd()
folderRaw <- paste0(workDir, "/data/raw/grw2012")
folderSpatialRaw <- paste0(workDir, "/data/raw/spatial")

# column names
allVotesAbs <- "stimmen_abs"
validVotesAbs <- "stimmen_gueltig_abs"
validVotesRel <- "stimmen_gueltig_rel"
unvalidVotesAbs <- "stimmen_ungueltig_abs"
unvalidVotesRel <- "stimmen_ungueltig_rel"
authVotersAbs <- "wahlber_alle_abs"
authFemaleVotersAbs <- "wahlber_Frauen_abs"
authFemaleVotersRel <- "wahlber_Frauen_rel"
authMaleVotersAbs <- "wahlber_Maenner_abs"
authMaleVotersRel <- "wahlber_Maenner_rel"
listplace <- "Listenplatz"
district <- "bezirk"
parish <- "sprengel"
parishDistrict <- "bezirk_sprengel"
partyShortname <- "partei_kuerzel"
partyName <- "parteiname"
votes <- "stimmen"
colNames <- list(allVotesAbs, validVotesAbs, validVotesRel, unvalidVotesAbs, unvalidVotesRel, 
                 authVotersAbs, authMaleVotersRel, authMaleVotersAbs, authFemaleVotersRel, authFemaleVotersAbs,
                 listplace, district, parish, parishDistrict, partyName, partyShortname, votes)
rm(allVotesAbs, validVotesAbs, validVotesRel, unvalidVotesAbs, unvalidVotesRel, 
     authVotersAbs, authMaleVotersRel, authMaleVotersAbs, authFemaleVotersRel, authFemaleVotersAbs,
     listplace, district, parish, parishDistrict, partyName, partyShortname, votes)

#---                     ----
####  OPEN & REDUCE DATA  ####
#---                     ----

# open results of the districts and remove clutter
rawVotesDistrict <- read.csv2(paste0( folderRaw, "/GRW2012_Sprengelbezerg.csv" ), fileEncoding = "iso-8859-1")
votesDistrict <- rawVotesDistrict
votesDistrict <- votesDistrict[, c("beznr", "ptname", "listenplatz", "stimmen", "gueltig")]
  
# open results of the parishes and remove clutter
rawVotesParish <- read.csv2(paste0( folderRaw, "/GRW2012_Sprengelerg.csv" ), fileEncoding = "iso-8859-1")
votesParish <- rawVotesParish
votesParish <- votesParish[, c("sprengel", "ptname", "listenplatz", "stimmen", "gueltig")]

# open authorized voters and remove clutter
rawAvParish <- read.csv2(paste0( folderRaw, "/GRW2012_Wahlberechtigte.csv" ), fileEncoding = "iso-8859-1")
avParish <- rawAvParish
avParish <- avParish[, c("sprengel", "wahlbe_gesamt", "wahlbe_mann", "wahlbe_frau")]

# Check data
# CheckData(votesDistrict) DEBUG
# CheckData(votesDistrict) DEBUG
#
# conclusion:
# missing value short party name of Einsparkraftwerk
# everything else okay

#---
####  PREPARE DATA  ####
#---

# correct parish & district columns
# columns: bezirk, sprengel, bezirk_sprengel, gesamt, unguel, gueltig
avParish <- SplitParishAndDistrict(avParish, 1)
votesParish <- SplitParishAndDistrict(votesParish, 1)
authorizedVotersDistrict <- rawVotesDistrict[, c("beznr", "gesamt", "gueltig", "unguel", "sprengelanzahl")]
authorizedVotersParish <- rawVotesParish[, c("sprengel", "gesamt", "gueltig", "unguel")]
votesDistrict$beznr <- votesDistrict$beznr / 100
authorizedVotersDistrict$beznr <- authorizedVotersDistrict$beznr / 100
authorizedVotersParish <- SplitParishAndDistrict(authorizedVotersParish, 1)

# delete duplicate rows
authorizedVotersDistrict <- authorizedVotersDistrict[!duplicated(authorizedVotersDistrict),]
rownames(authorizedVotersDistrict) <- 1:eleData[["numDistricts"]]
authorizedVotersParish <- authorizedVotersParish[!duplicated(authorizedVotersParish),]

# correct party short name of Einsparkraftwerk
levels(votesDistrict$ptname)[1] = "EKW"
levels(votesParish$ptname)[1] = "EKW"

# assign allowed, valid and unvalid votes to every district
# column: add all votes, valid votes and unvalid votes
avParish <- cbind(avParish, authorizedVotersParish[, c("gesamt", "gueltig", "unguel")])


#---
####  SAVE DATA  ####
#---
save(rawAvParish, rawVotesDistrict, rawVotesParish, file="./data/raw_grw2012.rda")
rm(rawAvParish, rawVotesDistrict, rawVotesParish)
save(list=ls(), file="./data/prep_grw2012.rda")
rm(list=ls())

##  FINAL DATA 
#===============
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

