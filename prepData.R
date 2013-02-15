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

####  INFORMATION  ####

## DICTIONARY
#
# Sprengel = parish
# Bezirk = district
# berechtigte WählerInnen = authorized voters
# Wahlbeteiligung = voters participation


####  INITIALIZE  ####


rm(list=ls())

# init libraries
library(RJSONIO)
library(stringr)

# load functions
source("functions.R")

# set city data
city <- list()
environment <- list()

city[["nameDistricts"]] <-c("Innere Stadt", "St. Leonhard", "Geidorf", "Lend", "Gries", 
                    "Jakomini", "Liebenau", "St. Peter", "Waltendorf", "Ries", "Mariatrost", 
                    "Andritz", "Gösting", "Eggenberg", "Wetzelsdorf", "Straßgang", "Puntigam")
city[["numDistricts"]] <- length(city[["nameDistricts"]])
city[["numParties"]] <- 11L
city[["leftMurNumDistricts"]] <- c(1, 2, 3, 6, 7, 8, 9, 10, 11, 12)
city[["rightMurNumDistricts"]] <- c(4, 5, 13, 14, 15, 16, 17)

# set environment data
environment[["workDir"]] <- paste0(getwd(), "/")
environment[["folderData"]] <- paste0(environment[["workDir"]], "data/")
environment[["folderDataRawCSV"]] <- paste0(environment[["workDir"]], "data/raw/csv/")
environment[["folderDataRawR"]] <- paste0(environment[["workDir"]], "data/raw/rstat/")
environment[["folderDataJSON"]] <- paste0(environment[["workDir"]], "data/json/")
environment[["folderDataR"]] <- paste0(environment[["workDir"]], "data/rstat/")

# partycolors
# kpö cc3333, fpö 0e428e, spö ce000c, green 87b52a, piraten 4c2582, bzö ee7f00
city[["partycolors"]] <- c("#ce000c", "#666666", "#0e428e", "#87b52a", "#cc3333", "#ee7f00", "#ffffff", "#4c2582", "#ffffff", "#ffffff", "#ffffff")
names(city[["partycolors"]]) <- city[["acrParties"]]

# party short names variations
city[["partyAcrAT"]] <- c("SPÖ", "ÖVP", "FPÖ", "Grüne", "KPÖ", "BZÖ", "CP-G", "Pirat", "ESK", "BBB", "WIR")
city[["partyAcrIT"]] <- c("SPOE", "OEVP", "FPOE", "GRUENE", "KPOE", "BZOE", "CPG", "PIRAT", "ESK", "BBB", "WIR")
city[["partyAcrAbs"]] <- c("SPOEabs", "OEVPabs", "FPOEabs", "GRUENEabs", "KPOEabs", "BZOEabs", "CPGabs", "PIRATabs", "ESKabs", "BBBabs", "WIRabs")
city[["partyAcrRel"]] <- c("SPOErel", "OEVPrel", "FPOErel", "GRUENErel", "KPOErel", "BZOErel", "CPGrel", "PIRATrel", "ESKrel", "BBBrel", "WIRrel")


####  OPEN DATA  ####


# open votes of parishes
rawVotesParish <- read.csv2(paste0( environment[["folderDataRawCSV"]], "GRW2012_Sprengelerg.csv" ), fileEncoding = "iso-8859-1",
                            col.names=c("eleShortName", "numParish", "acrParty", "nameParty", "list", "allVotes", 
                                        "unvalidVotes", "validVotes", "votes", "numParishes", "", ""))

# open authorized voters of parishes
rawAuthVotersParish <- read.csv2(paste0(  environment[["folderDataRawCSV"]], "GRW2012_Wahlberechtigte.csv" ), fileEncoding = "iso-8859-1", 
                         col.names=c("eleShortName", "numParish", "authAll", "authMen", "authWomen"))

# save participation data
participationParishAll <- rawVotesParish[, c("numParish", "allVotes", "validVotes", "unvalidVotes")]

# reduce authorized voters data
authVotersParish <- rawAuthVotersParish[, c("numParish", "authAll", "authMen", "authWomen")]

# reduce votes of parishes data
votesParishAll <- rawVotesParish[, c("numParish", "acrParty", "votes")]

# save raw data as RDA file
environment[["filenameRawRDA"]] <- "grazwahl.rda"
save(rawAuthVotersParish, rawVotesParish, file=paste0(environment[["folderDataRawR"]], environment[["filenameRawRDA"]]))

rm(rawAuthVotersParish, rawVotesParish)


####  PREPARE DATA  ####


# get number of parishes
city[["numParishesAll"]] <- votesParishAll[["numParish"]]
city[["numParishesEleDay"]] <- city[["numParishesAll"]][!(city[["numParishesAll"]] == 816 | city[["numParishesAll"]] == 2798 
                                                          | city[["numParishesAll"]] == 2799)]

# correct party short names 
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "")] <- "ESK"
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "BZÖ")] <- "BZOE"
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "SPÖ")] <- "SPOE"
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "CP-G")] <- "CPG"
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "FPÖ")] <- "FPOE"
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "GRÜNE")] <- "GRUENE"
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "KPÖ")] <- "KPOE"
levels(votesParishAll[, "acrParty"])[which(levels(votesParishAll[, "acrParty"]) == "ÖVP")] <- "OEVP"

# extract district out of parish column
authVotersParish <- ExtractDistrict(authVotersParish, "numParish", "numDistrict")
votesParishAll <- ExtractDistrict(votesParishAll, "numParish", "numDistrict")
participationParishAll <- ExtractDistrict(participationParishAll, "numParish", "numDistrict")

# delete duplicate rows of parish participation data
participationParishAll <- participationParishAll[!duplicated(participationParishAll),]


# save cleaned data 
authVotersParishPP1 <- authVotersParish
participationParishAllPP1 <- participationParishAll
votesParishAllPP1 <- votesParishAll

environment[["filenameDataPP1"]] <- "grazwahlPP1.rda"
save(list=c("votesParishAllPP1", "participationParishAllPP1", "authVotersParishPP1"), 
     file=paste0(environment[["folderDataR"]], environment[["filenameDataPP1"]]))
rm(votesParishAllPP1, participationParishAllPP1, authVotersParishPP1)
# load(file=paste0(environment[["folderDataR"]], environment[["filenameDataPP1"]]))

# transform votes data: reduce rows into one row per parish and transform the rows with votes per party into columns
votesParishAll <- TransformVotes(votesParishAll, "votes", "acrParty", city[["numParties"]])


####  PROCESS DATA  ####


# get relative authorized men and women of parishes
temp <- authVotersParish[, c("authMen", "authWomen")] / authVotersParish[["authAll"]] * 100
colnames(temp) <- c("authMenRel", "authWomenRel")
authVotersParish <- cbind(authVotersParish, temp)

# get relative valid and unvalid votes of parishes
temp <- participationParishAll[, c("validVotes", "unvalidVotes")] / participationParishAll[["allVotes"]] * 100
colnames(temp) <- c("validVotesRel", "unvalidVotesRel")
participationParishAll <- cbind(participationParishAll, temp)

# get relative election participation
temp <- data.frame(participationParishAll[["allVotes"]] / authVotersParish[["authAll"]] * 100)
colnames(temp) <- "electionPartRel"
participationParishAll <- cbind(participationParishAll, temp)

# get relative votes of parties in parishes
temp <- (votesParishAll[, 3:13] / participationParishAll[["validVotes"]] * 100)
colnames(temp) <- c("SPOErel", "OEVPrel", "FPOErel", "GRUENErel", "KPOErel", "BZOErel", "CPGrel", "PIRATrel", "ESKrel", "BBBrel", "WIRrel")
votesParishAll <- cbind(votesParishAll, temp)

rm(temp)


####  PREPARE DATA  ####


# create parish data only with election day votes
votesParishEleDay <- votesParishAll[!(votesParishAll[["numParish"]] == 816 | votesParishAll[["numParish"]] == 2798 | 
                                        votesParishAll[["numParish"]] == 2799), ]

participationParishEleDay <- participationParishAll[!(participationParishAll[["numParish"]] == 816 | participationParishAll[["numParish"]] == 2798 | 
                                                        participationParishAll[["numParish"]] == 2799), ]

authVotersParishEleDay <- authVotersParish[!(votesParishAll[["numParish"]] == 816 | votesParishAll[["numParish"]] == 2798 | 
                                               votesParishAll[["numParish"]] == 2799), ]

# create a second table for authorized voters with parish 816 (without 2798 & 2799) for maps 
authVotersParishEleDayMap <- authVotersParish[!(votesParishAll[["numParish"]] == 2798 | votesParishAll[["numParish"]] == 2799), ]

# prepare data for left and right mur districts comparison


####  AGGREGATE DATA  ####

# !!!!      for districts only use data from election day     !!!!
# use authorized voters table and votes for parties table without parish 816, 2799 and 2798, so it keeps compareable

# get authoried voters data for districts
authAll <- tapply(authVotersParishEleDay[["authAll"]], authVotersParishEleDay[["numDistrict"]], sum, simplify = TRUE)
authMenAbs <- tapply(authVotersParishEleDay[["authMen"]], authVotersParishEleDay[["numDistrict"]], sum, simplify = TRUE)
authWomenAbs <- tapply(authVotersParishEleDay[["authWomen"]], authVotersParishEleDay[["numDistrict"]], sum, simplify = TRUE)
authMenRel <- authMenAbs / authAll * 100
authWomenRel <- authWomenAbs / authAll * 100

authVotersDistrict <- data.frame(numDistrict=1:17, authAll=authAll, authMenAbs=authMenAbs, authWomenAbs=authWomenAbs, 
                                 authMenRel=authMenRel, authWomenRel=authWomenRel)

rm(authAll, authMenAbs, authWomenAbs, authMenRel, authWomenRel)

# get election participation data for districts
allVotes <- tapply(participationParishEleDay[["allVotes"]], participationParishEleDay[["numDistrict"]], sum, simplify = TRUE)
validVotesAbs <- tapply(participationParishEleDay[["validVotes"]], participationParishEleDay[["numDistrict"]], sum, simplify = TRUE)
unvalidVotesAbs <- tapply(participationParishEleDay[["unvalidVotes"]], participationParishEleDay[["numDistrict"]], sum, simplify = TRUE)
validVotesRel <- validVotesAbs / allVotes * 100
unvalidVotesRel <- unvalidVotesAbs / allVotes * 100

electionParticipation <- allVotes / authVotersDistrict[["authAll"]] * 100

participationDistrict <- data.frame(numDistrict=1:17, allVotes=allVotes, validVotesAbs=validVotesAbs, 
                                    unvalidVotesAbs=unvalidVotesAbs, validVotesRel=validVotesRel, unvalidVotesRel=unvalidVotesRel, 
                                    electionParticipation=electionParticipation)

rm(allVotes, validVotesAbs, unvalidVotesAbs, validVotesRel, unvalidVotesRel, electionParticipation)

# get absolute votes for every party for districts
temp1 <- tapply(votesParishEleDay[, 3], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp2 <- tapply(votesParishEleDay[, 4], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp3 <- tapply(votesParishEleDay[, 5], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp4 <- tapply(votesParishEleDay[, 6], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp5 <- tapply(votesParishEleDay[, 7], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp6 <- tapply(votesParishEleDay[, 8], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp7 <- tapply(votesParishEleDay[, 9], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp8 <- tapply(votesParishEleDay[, 10], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp9 <- tapply(votesParishEleDay[, 11], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp10 <- tapply(votesParishEleDay[, 12], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)
temp11 <- tapply(votesParishEleDay[, 13], votesParishEleDay[["numDistrict"]], sum, simplify = TRUE)

votesDistrict <- data.frame(numDistrict=1:17, SPOEabs=temp1, OEVPabs=temp2, FPOEabs=temp3, GRUENEabs=temp4, KPOEabs=temp5, BZOEabs=temp6, 
                                  CP=temp7, PIRATabs=temp8, ESKabs=temp9, BBBabs=temp10, WIRabs=temp11)
names(votesDistrict)[which(names(votesDistrict) == "CP")] <- "CPGabs"

temp <- votesDistrict[, 2:12] / participationDistrict[["validVotesAbs"]] * 100
colnames(temp) <- c("SPOErel", "OEVPrel", "FPOErel", "GRUENErel", "KPOErel", "BZOErel", "CPGrel", "PIRATrel", "ESKrel", "BBBrel", "WIRrel")
votesDistrict <- cbind(votesDistrict, temp)

rm(temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp10, temp11, temp)

# get authorized voters data for city
city[["authAll"]] <- sum(authVotersParish[, "authAll"])
city[["authMenAbs"]] <- sum(authVotersParish[, "authMen"])
city[["authWomenAbs"]] <- sum(authVotersParish[, "authWomen"])
city[["authMenRel"]] <- city[["authMenAbs"]] / city[["authAll"]] * 100
city[["authWomenRel"]] <- city[["authWomenAbs"]] / city[["authAll"]] * 100

# get voting data for city
city[["allVotes"]] <- sum(participationParishAll[, "allVotes"])
city[["validVotesAbs"]] <- sum(participationParishAll[, "validVotes"])
city[["unvalidVotesAbs"]] <- sum(participationParishAll[, "unvalidVotes"])
city[["validVotesRel"]] <- city[["validVotesAbs"]] / city[["allVotes"]] * 100
city[["unvalidVotesRel"]] <- city[["unvalidVotesAbs"]] / city[["allVotes"]] * 100

# get election participation for city
city[["electionParticipation"]] <- city[["allVotes"]] / city[["authAll"]] * 100

# get party votes for city
city[["votesPartiesAbs"]] <- apply(votesParishAll[, 3:13], 2, sum)
names(city[["votesPartiesAbs"]]) <- str_replace(names(city[["votesPartiesAbs"]]), "abs", "")
city[["votesPartiesRel"]] <- city[["votesPartiesAbs"]] / city[["validVotesAbs"]] * 100

# delete rows for 2798 and 2799 from authorized voters table
authVotersParish <- authVotersParish[!(authVotersParish[["numParish"]] == 2798 | authVotersParish[["numParish"]] == 2799), ]

environment[["filenameDataPP2"]] <- "grazwahlPP2.rda"
save(list=ls(), file=paste0(environment[["folderDataR"]], environment[["filenameDataPP2"]]))


##  EXPORT DATA TO JSON  ##


jsonFiles <- list()
jsonFiles[["votesParishAll"]] <- toJSON(votesParishAll)
jsonFiles[["votesParishEleDay"]] <- toJSON(votesParishEleDay)
jsonFiles[["votesDistrict"]] <- toJSON(votesDistrict) # DEBUG
jsonFiles[["authVotersParish"]] <- toJSON(authVotersParish)
jsonFiles[["authVotersParishEleDay"]] <- toJSON(authVotersParishEleDay)
jsonFiles[["authVotersDistrict"]] <- toJSON(authVotersDistrict) # DEBUG
jsonFiles[["participationParishAll"]] <- toJSON(participationParishAll)
jsonFiles[["participationDistrict"]] <- toJSON(participationDistrict) # DEBUG
jsonFiles[["participationParishEleDay"]] <- toJSON(participationParishEleDay)

for(i in seq_along(jsonFiles)) {
  SaveJSON(jsonFiles[i])
}




