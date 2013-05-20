######################################################
#     											 
#   Description: Analyse and Visualize the 
#                Grazer Gemeinderatswahlen 2012
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


##  INIT  ##


rm(list=ls())

load(paste0(getwd(), "/data/rstat/grazwahlPP2.rda"))
load(paste0(getwd(), "/data/rstat/environment.rda"))
load(paste0(environment[["folderDataR"]], "/", environment[["filenameRawRDA"]]))
source(environment[["functions.R"]])

environment[["folderImages"]] <- paste0(environment[["homeDir"]],"/images/")
environment[["folderImagesCorr"]] <- paste0(environment[["homeDir"]],"/images/correlation/")
environment[["folderImagesVotes"]] <- paste0(environment[["homeDir"]],"/images/votes/")
environment[["folderImagesBox"]] <- paste0(environment[["homeDir"]],"/images/boxplot/")
environment[["folderImagesHist"]] <- paste0(environment[["homeDir"]],"/images/histogram/")
environment[["folderImagesDens"]] <- paste0(environment[["homeDir"]],"/images/density/")


##  BOXPLOTS  ##


# parishes distribution of all parties (abs)
Boxplot(votesParishEleDay[,3:13], filename=paste0(environment[["folderImagesBox"]], "boxAllPartiesParAbs"), colors=city[["partycolors"]], 
        names=city[["partyAcrAT"]], title="Stimmen Grazer Gemeinderatswahl 2012 nach Sprengel", yaxis="Stimmen", legend=T, svg=T, pdf=F, png=T)

# parishes distribution of all parties (rel)
Boxplot(votesParishEleDay[,14:24], filename=paste0(environment[["folderImagesBox"]], "boxAllPartiesParRel"), colors=city[["partycolors"]], 
        names=city[["partyAcrAT"]], title="Stimmen Grazer Gemeinderatswahl 2012 nach Sprengel", yaxis="Stimmen [%]", legend=T, svg=T, pdf=F, png=T)

# parishes distribution of big 6 (abs)
Boxplot(votesParishEleDay[,c(3:7, 10)], filename=paste0(environment[["folderImagesBox"]], "boxBig6PartiesParAbs"), 
        colors=city[["partycolors"]][c(1:5, 8)], names=city[["partyAcrAT"]][c(1:5, 8)], yaxis="Stimmen", title="Big6 Grazer Gemeinderatswahl 2012 nach Sprengel", 
        legend=T, svg=T, pdf=F, png=T)

# parishes distribution of big 6 (rel)
Boxplot(votesParishEleDay[,c(14:18, 21)], filename=paste0(environment[["folderImagesBox"]], "boxBig6PartiesParRel"), 
        colors=city[["partycolors"]][c(1:5, 8)], names=city[["partyAcrAT"]][c(1:5, 8)], title="Big6 Grazer Gemeinderatswahl 2012 nach Sprengel", 
        yaxis="Stimmen [%]", legend=T, svg=T, pdf=F, png=T)

# parishes distribution every party itself
for(i in seq_along(1:city[["numParties"]])) {
  
  # absolute   
  Boxplot(votesParishEleDay[, 2+i], 
          filename=paste0(environment[["folderImagesBox"]], "box", city[["partyAcrIT"]][i], "ParAbs"), 
          colors=city[["partycolors"]][i], 
          names=city[["partyAcrAT"]][i], 
          title=paste0("Stimmenverteilung ", city[["partyAcrAT"]][i], " nach Sprengel"),
          yaxis="Stimmen",
          legend=F, svg=T, pdf=F, png=T)
  
  # relative
  Boxplot(votesParishEleDay[, 13+i], 
          filename=paste0(environment[["folderImagesBox"]], "box", city[["partyAcrIT"]][i], "ParRel"), 
          colors=city[["partycolors"]][i], 
          names=city[["partyAcrAT"]][i], 
          title=paste0("Stimmenverteilung ", city[["partyAcrAT"]][i], " nach Sprengel"), 
          yaxis="Stimmen [%]",
          legend=F, svg=T, pdf=F, png=T)
}

# distribution of all votes in parishes (abs)
Boxplot(participationParishEleDay[["allVotes"]], 
        filename=paste0(environment[["folderImagesBox"]], "box", "AllVotesParAbs"), 
        colors="cyan", 
        names="TEST", 
          title="Verteilung abgegebene Stimmen nach Sprengel", 
        yaxis="Stimmen",
        legend=F, svg=T, pdf=F, png=T)

# relative election participation in parishes and districts
Boxplot(list(participationParishEleDay[["electionPartRel"]], participationDistrict[["electionParticipation"]]),
        filename=paste0(environment[["folderImagesBox"]], "box", "ElePartRel"), 
        colors="cyan", 
        names=c("Sprengel", "Bezirk"), 
        title="Vergleich der Verteilung der Wahlbeteiligung in Sprengel und Bezirk", 
        yaxis="Stimmen [%]",
        legend=F, svg=T, pdf=F, png=T)

# relative unvalid votes in parishes and districts
Boxplot(list(participationParishEleDay[["unvalidVotesRel"]], participationDistrict[["unvalidVotesRel"]]),
        filename=paste0(environment[["folderImagesBox"]], "box", "UnvalidVotesRel"), 
        colors="cyan", 
        names=c("Sprengel", "Bezirk"), 
        title="Vergleich der Verteilung ungültiger Stimmen in Sprengel und Bezirk", 
        yaxis="Stimmen [%]",
        legend=F, svg=T, pdf=F, png=T)


##  BARPLOTS  ##


# party results of city (abs)
VotesColumnChart(city[["votesPartiesAbs"]], 
                 filename=paste0(environment[["folderImagesVotes"]], "barPartiesCityAbs"), 
                 colors=city[["partycolors"]], 
                 names=city[["partyAcrAT"]], 
                 title="Ergebnis Grazer Gemeinderatswahl 2012", 
                 yaxis="Stimmen",
                 shift=1000,
                 output=T, png=T, svg=T, pdf=F)


# party results of city (rel)
VotesColumnChart(city[["votesPartiesRel"]], 
                 filename=paste0(environment[["folderImagesVotes"]], "barPartiesCityRel"), 
                 colors=city[["partycolors"]], 
                 names=city[["partyAcrAT"]], 
                 title="Ergebnis Grazer Gemeinderatswahl 2012", 
                 yaxis="Stimmenanteil [%]",
                 shift=1,
                 output=T, png=T, svg=T, pdf=F)

# all authorized votes of districts (abs)
VotesColumnChart(authVotersDistrict[["authAll"]], 
                 filename=paste0(environment[["folderImagesVotes"]], "barAuthAllDisAbs"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Wahlberechtigte nach Bezirke", 
                 yaxis="Stimmen",
                 shift=700,
                 output=T, png=T, svg=T, pdf=F)

# all votes in districts (abs)
VotesColumnChart(participationDistrict[["allVotes"]], 
                 filename=paste0(environment[["folderImagesVotes"]], "barAllVotesDisAbs"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Wahlbeteiligung nach Bezirke", 
                 yaxis="Stimmen",
                 shift=300,
                 output=T, png=T, svg=T, pdf=F)

# relative election participation of districts 
VotesColumnChart(participationDistrict[["electionParticipation"]], 
                 filename=paste0(environment[["folderImagesVotes"]], "barElePartDisRel"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Wahlberechtigte nach Bezirke", 
                 yaxis="Stimmen [%]",
                 shift=1.5,
                 output=T, png=T, svg=T, pdf=F)

# relative unvalid votes of districts
VotesColumnChart(participationDistrict[["unvalidVotesRel"]], 
                 filename=paste0(environment[["folderImagesVotes"]], "barUnvalidVotesDisRel"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Ungültige Stimmen nach Bezirke", 
                 yaxis="Stimmen [%]",
                 shift=0.07,
                 output=T, png=T, svg=T, pdf=F)


##  HISTOGRAMS & DENSITY  ##


for(i in seq_along(1:city[["numParties"]])) {
  
  # distribution of votes in parishes (abs)
  Histogram(votesParishEleDay[,2+i], 
            filename=paste0(environment[["folderImagesHist"]], "hist", city[["partyAcrIT"]][i] , "ParAbs"), 
            colors=city[["partycolors"]][i], 
            yaxis="Anzahl", 
            xaxis="Stimmen", 
            title=paste0("Stimmenverteilung ", city[["partyAcrAT"]][i], " nach Sprengel"), 
            output=T, png=T, svg=T, pdf=F)
  
  # distribution of votes in parishes (rel)
  Histogram(votesParishEleDay[,13+i], 
            filename=paste0(environment[["folderImagesHist"]], "hist", city[["partyAcrIT"]][i] , "ParRel"), 
            colors=city[["partycolors"]][i], 
            yaxis="Anzahl", 
            xaxis="Stimmen [%]", 
            title=paste0("Stimmenverteilung ", city[["partyAcrAT"]][i], " nach Sprengel"), 
            output=T, png=T, svg=T, pdf=F)
  
  # density function parishes
  DensityPlot(density(votesParishEleDay[,2+i]), 
              filename=paste0(environment[["folderImagesDens"]], "dens", city[["partyAcrIT"]][i], "ParAbs"), 
              color="cyan", 
              title=paste0("Dichtefunktion ", city[["partyAcrIT"]][i], " nach Sprengel"), 
              yaxis="Stimmen [%]",
              output=T, png=T, svg=T, pdf=F)
}

# distribution of relative election participation in parishes
Histogram(participationParishEleDay[["electionPartRel"]], 
          filename=paste0(environment[["folderImagesHist"]], "histElePartParRel"), 
          colors="cyan", 
          yaxis="Anzahl", 
          xaxis="Abgegebene Stimmen [%]", 
          title=paste0("Verteilung Wahlbeteiligung nach Sprengel"), 
          output=T, png=T, svg=T, pdf=F)

# distribution of relative unvalid votes in parishes
Histogram(participationParishEleDay[["unvalidVotesRel"]], 
          filename=paste0(environment[["folderImagesHist"]], "histUnvalidVotesParRel"), 
          colors="cyan", 
          yaxis="Anzahl", 
          xaxis="Ungueltige Stimmen [%]", 
          title=paste0("Verteilung ungültige Stimmen nach Sprengel"), 
          output=T, png=T, svg=T, pdf=F)


##  CORRELATION  ##


# Pearson
CalculateCorrelation(votesParishEleDay[, 3:13], votesDistrict[, 2:12],
                     corrMethod="pearson",
                     folder=environment[["folderImagesCorr"]],
                     namesIT=city[["partyAcrIT"]],
                     namesAT=city[["partyAcrAT"]],
                     colors=city[["partycolors"]],
                     legend=F, output=T, png=T, svg=T, pdf=F)

# Spearman
CalculateCorrelation(votesParishEleDay[, 3:13], votesDistrict[, 2:12],
                     corrMethod="spearman",
                     folder=environment[["folderImagesCorr"]],
                     namesIT=city[["partyAcrIT"]],
                     namesAT=city[["partyAcrAT"]],
                     colors=city[["partycolors"]],
                     legend=F, output=T, png=T, svg=T, pdf=F)


# Prepare data for left / right Mur Ufer
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 1), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 2), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 3), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 6), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 7), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 8), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 9), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 10), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 11), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 12), "ufer"] <- "left"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 4), "ufer"] <- "right"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 5), "ufer"] <- "right"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 13), "ufer"] <- "right"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 14), "ufer"] <- "right"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 15), "ufer"] <- "right"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 16), "ufer"] <- "right"
votesParishEleDay[which(votesParishEleDay[, "numDistrict"]  == 17), "ufer"] <- "right"
votesParishEleDay$ufer <- as.factor(votesParishEleDay$ufer)

participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 1), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 2), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 3), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 6), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 7), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 8), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 9), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 10), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 11), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 12), "ufer"] <- "left"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 4), "ufer"] <- "right"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 5), "ufer"] <- "right"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 13), "ufer"] <- "right"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 14), "ufer"] <- "right"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 15), "ufer"] <- "right"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 16), "ufer"] <- "right"
participationParishEleDay[which(participationParishEleDay[, "numDistrict"]  == 17), "ufer"] <- "right"
participationParishEleDay$ufer <- as.factor(participationParishEleDay$ufer)

# parishes votes distribution every party solely between the left and right murufer (relative)
for(i in seq_along(1:city[["numParties"]])) {
  BoxplotLR(votesParishEleDay[, 2+i], 
            votesParishEleDay[, "ufer"],
            filename=paste0(environment[["folderImagesBox"]], "box", city[["partyAcrIT"]][i], "UferAbs"), 
            colors=city[["partycolors"]][i], 
            names=levels(votesParishEleDay[, "ufer"]),
            title=paste0("Verteilung nach Murufer von ", city[["partyAcrAT"]][i], " (Sprengel)"),
            legend=F, svg=T, pdf=F, png=T)
}

# parishes votes distribution every party solely between the left and right murufer (relative)
for(i in seq_along(1:city[["numParties"]])) {
    BoxplotLR(votesParishEleDay[, 13+i], 
              votesParishEleDay[, "ufer"],
              filename=paste0(environment[["folderImagesBox"]], "box", city[["partyAcrIT"]][i], "UferRel"), 
              colors=city[["partycolors"]][i], 
              names=levels(votesParishEleDay[, "ufer"]),
              title=paste0("Verteilung nach Murufer von ", city[["partyAcrAT"]][i], " (Sprengel)"),
              legend=F, svg=T, pdf=F, png=T)
}

# election participation comparision between left and right murufer (rel)
BoxplotLR(participationParishEleDay[, "allVotes"], 
          participationParishEleDay[, "ufer"],
          filename=paste0(environment[["folderImagesBox"]], "boxElePartUferRel"), 
          colors="cyan", 
          names=levels(votesParishEleDay[, "ufer"]),
          title="Verteilung Wahlbeteiligung der Murufer nach Sprengel",
          legend=F, svg=T, pdf=F, png=T)

# election participation comparision between left and right murufer (abs)
BoxplotLR(participationParishEleDay[, "electionPartRel"], 
          participationParishEleDay[, "ufer"],
          filename=paste0(environment[["folderImagesBox"]], "boxElePartUferAbs"), 
          colors="cyan", 
          names=levels(votesParishEleDay[, "ufer"]),
          title=paste0("Verteilung Wahlbeteiligung der Murufer nach Sprengel"),
          legend=F, svg=T, pdf=F, png=T)

# unvalid votes comparision between left and right murufer (abs)
BoxplotLR(participationParishEleDay[, "unvalidVotesRel"], 
          participationParishEleDay[, "ufer"],
          filename=paste0(environment[["folderImagesBox"]], "boxUnvalidVotesParUferRel"), 
          colors="cyan", 
          names=levels(votesParishEleDay[, "ufer"]),
          title=paste0("Verteilung ungültige Stimmen der Murufer nach Sprengel"),
          legend=F, svg=T, pdf=F, png=T)


# SAVE DATA


environment[["filenameDataViz"]] <- "grazwahlViz.rda"
rm(environment)
save(list=ls(), file=paste0(getwd(), "/data/rstat/grazwahlViz.rda"))
rm(list=ls())

