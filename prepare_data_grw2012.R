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
####  INFORMATION  ####
#---
#
## DICTIONARY
#
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

# Constants
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

# Column Names
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

# open votes districts, save raw data, remove clutter and save district voting validity data
rawVotesDistrict <- read.csv2(paste0( folderRaw, "/GRW2012_Sprengelbezerg.csv" ), fileEncoding = "iso-8859-1")
votesDistrict <- rawVotesDistrict
votesDistrict <- votesDistrict[, c("beznr", "ptname", "listenplatz", "stimmen", "gueltig")]
authorizedVotersDistrict <- rawVotesDistrict[, c("beznr", "gesamt", "gueltig", "unguel", "sprengelanzahl")]

# open votes parishes, save raw data and remove clutter
rawVotesParish <- read.csv2(paste0( folderRaw, "/GRW2012_Sprengelerg.csv" ), fileEncoding = "iso-8859-1")
votesParish <- rawVotesParish
votesParish <- votesParish[, c("sprengel", "ptname", "listenplatz", "stimmen", "gueltig")]

# open authorized voters, save raw data, remove clutter and save parish voting validity data
rawAvParish <- read.csv2(paste0( folderRaw, "/GRW2012_Wahlberechtigte.csv" ), fileEncoding = "iso-8859-1")
avParish <- rawAvParish
avParish <- avParish[, c("sprengel", "wahlbe_gesamt", "wahlbe_mann", "wahlbe_frau")]
authorizedVotersParish <- rawVotesParish[, c("sprengel", "gesamt", "gueltig", "unguel")]

# save raw data as RDA file
save(rawAvParish, rawVotesDistrict, rawVotesParish, file="./data/raw_grw2012.rda")

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

# correct spatial columns of authorized voters and parish data
avParish <- SplitParishAndDistrict(avParish, 1)
votesParish <- SplitParishAndDistrict(votesParish, 1)
votesDistrict$beznr <- votesDistrict$beznr / 100
authorizedVotersDistrict$beznr <- authorizedVotersDistrict$beznr / 100
authorizedVotersParish <- SplitParishAndDistrict(authorizedVotersParish, 1)

# delete duplicate rows in voting validity data of district and parish
authorizedVotersDistrict <- authorizedVotersDistrict[!duplicated(authorizedVotersDistrict),]
rownames(authorizedVotersDistrict) <- 1:eleData[["numDistricts"]]
authorizedVotersParish <- authorizedVotersParish[!duplicated(authorizedVotersParish),]
rm(authorizedVotersDistrict)

# correct party short name of Einsparkraftwerk
levels(votesDistrict[, "ptname"])[1] = "EKW"
levels(votesParish[, "ptname"])[1] = "EKW"

# append votes done, valid votes and unvalid votes to parish
# column: add all votes, valid votes and unvalid votes
avParish <- cbind(avParish, authorizedVotersParish[, c("gesamt", "gueltig", "unguel")])
rm(authorizedVotersParish, rawAvParish, rawVotesDistrict, rawVotesParish)

#---
####  PROCESS DATA  ####
#---

# get voters participation of city
authVotersCity <- sum(avParish[, "wahlbe_gesamt"])
authMen <- sum(avParish[, "wahlbe_mann"])
authWomen <- sum(avParish[, "wahlbe_frau"])
allVotes <- sum(avParish[, "gesamt"])
validVotesCity <- sum(avParish[, "gueltig"])
unvalidVotesCity <- sum(avParish[, "unguel"])
electionPartCity <- validVotesCity / authVotersCity * 100
listCity <- list(authVotersCity, authMen, authWomen, allVotes, validVotesCity, unvalidVotesCity, electionPartCity)
names(listCity) <- c("authVoters", "authMen", "authWomen", "allVotes", "validVotes", "unvalidVotes", "electionPart")
rm(authVotersCity, validVotesCity, allVotes, unvalidVotesCity, electionPartCity, authMen, authWomen)

# generate votesCity with votes of parties (relative & absolute)
votesCity <- data.frame(tapply(votesParish[, "stimmen"], votesParish[, "ptname"], sum))
votesPartiesCityRel <- votesCity / listCity[["validVotes"]] * 100
votesCity <- cbind(rownames(votesCity), votesCity, votesPartiesCityRel)
colnames(votesCity) <- c("ptname", "votes_abs", "votes_rel") 
rm(votesPartiesCityRel)

# generate avDistrict with authorized voters and voting validity
authAll <- tapply(avParish[, "wahlbe_gesamt"], avParish$bezirk, sum, simplify = TRUE)[1:eleData[["numVotDistricts"]]]
authMen <- tapply(avParish[, "wahlbe_mann"], avParish$bezirk, sum, simplify = TRUE)[1:eleData[["numVotDistricts"]]]
authWomen <- tapply(avParish[, "wahlbe_frau"], avParish$bezirk, sum, simplify = TRUE)[1:eleData[["numVotDistricts"]]]
votesAll <- tapply(avParish[, "gesamt"], avParish$bezirk, sum, simplify = TRUE)[1:eleData[["numVotDistricts"]]]
votesValid <- tapply(avParish[, "gueltig"], avParish$bezirk, sum, simplify = TRUE)[1:eleData[["numVotDistricts"]]]
votesUnvalid <- tapply(avParish[, "unguel"], avParish$bezirk, sum, simplify = TRUE)[1:eleData[["numVotDistricts"]]]
avDistrict <- as.data.frame(cbind(1:eleData[["numVotDistricts"]], authAll, authMen, authWomen, votesAll, votesValid, votesUnvalid))
avDistrict[, 1] <- c(as.character(1:17), "27")
names(avDistrict) <- c("bezirk", "wahlbe_gesamt", "wahlbe_mann", "wahlbe_frau", "stimmen_gesamt", "stimmen_gueltig", "stimmen_ungueltig")
rownames(avDistrict) <- c(as.character(1:17), "27")
rownames(avParish) <- 1:dim(avParish)[1]
rm(authAll, authMen, authWomen, votesAll, votesUnvalid, votesValid)

# get relative amount of authorized men and women of parishes and districts
# get relative data always via absolute data, not by summing up relative data !
relMen <- avParish[, "wahlbe_mann"] / avParish[, "wahlbe_gesamt"] * 100
relWomen <- avParish[, "wahlbe_frau"] / avParish[, "wahlbe_gesamt"] * 100
avParish <- cbind(avParish, relMen, relWomen)
relMen <- avDistrict[, "wahlbe_mann"] / avDistrict[, "wahlbe_gesamt"] * 100
relWomen <- avDistrict[, "wahlbe_frau"] / avDistrict[, "wahlbe_gesamt"] * 100
avDistrict <- cbind(avDistrict, relMen, relWomen)
rm(relMen, relWomen)

# get relative amount of valid and unvalid votes of parishes and districts
# get relative data always via absolute data, not by summing up relative data !
relVal <- avParish[, "gueltig"] / avParish[, "gesamt"] * 100
relUnval <- avParish[, "unguel"] / avParish[, "gesamt"] * 100
avParish <- cbind(avParish, relVal, relUnval)
relVal <- avDistrict[, "stimmen_gueltig"] / avDistrict[, "stimmen_gesamt"] * 100
relUnval <- avDistrict[, "stimmen_ungueltig"] / avDistrict[, "stimmen_gesamt"] * 100
avDistrict <- cbind(avDistrict, relVal, relUnval)
rm(relVal, relUnval)

# get relative votes of parties of parish and district
relVotes <- votesParish[, "stimmen"] / votesParish[, "gueltig"] * 100
votesParish <- cbind(votesParish, relVotes)
relVotes <- votesDistrict[, "stimmen"] / votesDistrict[, "gueltig"] * 100
votesDistrict <- cbind(votesDistrict, relVotes)
rm(relVotes)

# get election participation of districts and parishes
relParticipation <- avDistrict[, "stimmen_gesamt"] / avDistrict[, "wahlbe_gesamt"] * 100
avDistrict <- cbind(avDistrict, relParticipation)
relParticipation <- avParish[, "gesamt"] / avParish[, "wahlbe_gesamt"] * 100
avParish <- cbind(avParish, relParticipation)
rm(relParticipation)

#---
####  QUALITY CHECK  ####
#---

# verify votes against sum of valid and unvalid votes
# all(authorizedVotersParish$gesamt == authorizedVotersParish$unguel + authorizedVotersParish$gueltig) DEBUG
# all(authorizedVotersDistrict$gesamt == authorizedVotersDistrict$unguel + authorizedVotersDistrict$gueltig) DEBUG

# verify all authorized voters against sum of authorized men and women (absolut and relative)
# all(avDistrict$vpAll == avDistrict$vpMen + avDistrict$vpWomen)
# all(avParish[, "wahlbe_mann"] / avParish[, "wahlbe_gesamt"] + avParish[, "wahlbe_frau"] / avParish[, "wahlbe_gesamt"] == 1, na.rm = TRUE)
# all(avDistrict[, "wahlbe_mann"] / avDistrict[, "wahlbe_gesamt"] + avDistrict[, "wahlbe_frau"] / avDistrict[, "wahlbe_gesamt"] == 1, na.rm = TRUE)

# val1 <- sum(avParish$gueltig)
# val2 <- sum(votesParish$stimmen)
# val3 <- sum(avDistrict$stimme_gueltig)
# diff <- val3 - sum(votesDistrict$stimmen) == avDistrict$stimme_gueltig[18]
# rm(val1, val2, val3)

#---
####  SAVE DATA  ####
#---
# save(list=ls(), file="./data/prep_grw2012.rda")
# rm(list=ls())

##  FINAL DATA 
#===============
#
# avParish 
#   rows: ascending number
#   cols: district, parish, district and parish, authorized voters, authorized male voters, authorized female voters, 
#         all votes, valid votes, unvalid votes, authorized male voters relative, authorized female voters relative
#         valid votes relative, unvalid votes relative, election participation relative
#
# avDistrict
#   rows: ascending number
#   cols: district, authorized voters, authorized male voters, authorized female voters, 
#         all votes, valid votes, unvalid votes, authorized male votes relative, authorized votes female relative, 
#         valid votes relative, unvalid votes relative, election participation relative
#
# votesDistrict
#   rows: ascending number
#   cols: district, short name party, list place, votes for party, valid votes in district, votes for party relative
#
# votesParish
#   rows: ascending number
#   cols: district, parish, district and parish, short name party, list place, votes, valid votes in parish, 
#         relative votes for party in parish
#
# listCity
#   elements: authoried voters of city, participated voters in city, election participation in percent 
#
# resultPartiesCity
#   elements: sum of votes of every party in Graz
#
#================================================







