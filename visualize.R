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

load("/home/cheeseman/Open Science/Projects/Graz Wahlen 2012/data/rstat/grazwahlPP2.rda")
load(paste0(environment[["folderDataRawR"]], environment[["filenameRawRDA"]]))

environment[["folderImages"]] <- paste0(environment[["workDir"]],"images/")

source("functions.R")


##  BOXPLOTS  ##


# parishes distribution of all parties (abs)
Boxplot(votesParishEleDay[,3:13], filename=paste0(environment[["folderImages"]], "boxAllPartiesParAbs"), colors=city[["partycolors"]], 
        names=city[["partyAcrAT"]], title="Verteilung Stimmen Sprengel (abs)", legend=T, output=T, svg=T, pdf=T, png=T)

# parishes distribution of all parties (rel)
Boxplot(votesParishEleDay[,14:24], filename=paste0(environment[["folderImages"]], "boxAllPartiesParRel"), colors=city[["partycolors"]], 
        names=city[["partyAcrAT"]], title="Verteilung Stimmen Sprengel (rel)", legend=T, output=T, svg=T, pdf=T, png=T)

# parishes distribution of big 6 (abs)
Boxplot(votesParishEleDay[,c(3:7, 10)], filename=paste0(environment[["folderImages"]], "boxBig6PartiesParAbs"), 
        colors=city[["partycolors"]][c(1:5, 8)], names=city[["partyAcrAT"]][c(1:5, 8)], title="Boxplots Big6 (abs)", 
        legend=T, output=T, svg=T, pdf=T, png=T)

# parishes distribution of big 6 (rel)
Boxplot(votesParishEleDay[,c(14:18, 21)], filename=paste0(environment[["folderImages"]], "boxBig6PartiesParRel"), 
        colors=city[["partycolors"]][c(1:5, 8)], names=city[["partyAcrAT"]][c(1:5, 8)], title="Boxplots Big6 (rel)", 
        legend=T, output=T, svg=T, pdf=T, png=T)

# parishes distribution every party solely
for(i in seq_along(1:city[["numParties"]])) {
  # absolute 
  Boxplot(votesParishEleDay[, 2+i], 
          filename=paste0(environment[["folderImages"]], "box", city[["partyAcrIT"]][i], "ParAbs"), 
          colors=city[["partycolors"]][i], 
          names=city[["partyAcrAT"]][i], 
          title=paste0("Verteilung Stimmen ", city[["partyAcrAT"]][i], " (abs)"),
          legend=F, output=T, svg=T, pdf=T, png=T)
  
  # relative
  Boxplot(votesParishEleDay[, 13+i], 
          filename=paste0(environment[["folderImages"]], "box", city[["partyAcrIT"]][i], "ParRel"), 
          colors=city[["partycolors"]][i], 
          names=city[["partyAcrAT"]][i], 
          title=paste0("Verteilung Stimmen ", city[["partyAcrAT"]][i], " (rel)"), 
          legend=F, output=T, svg=T, pdf=T, png=T)
}

# distribution of all votes in parishes (abs)
Boxplot(participationParishEleDay[["allVotes"]], 
        filename=paste0(environment[["folderImages"]], "box", "AllVotesParAbs"), 
        colors="cyan", 
        names="TEST", 
        title="Verteilung abgegebene Stimmen in Sprengel (abs)", 
        legend=F, output=T, svg=T, pdf=T, png=T)

# relative election participation in parishes and districts
Boxplot(list(participationParishEleDay[["electionPartRel"]], participationDistrict[["electionParticipation"]]),
        filename=paste0(environment[["folderImages"]], "box", "ElePartRel"), 
        colors="cyan", 
        names=c("Sprengel", "Bezirk"), 
        title="Verteilung Wahlbeteiligung in Sprengel und Bezirk (rel)", 
        legend=F, output=T, svg=T, pdf=T, png=T)

# relative unvalid votes in parishes and districts
Boxplot(list(participationParishEleDay[["unvalidVotesRel"]], participationDistrict[["unvalidVotesRel"]]),
        filename=paste0(environment[["folderImages"]], "box", "UnvalidVotesAbs"), 
        colors="cyan", 
        names=c("Sprengel", "Bezirk"), 
        title="Verteilung ungültige Stimmen in Sprengel und Bezirk (rel)", 
        legend=F, output=T, svg=T, pdf=T, png=T)


##  BARPLOTS  ##


# party results of city (abs)
VotesColumnChart(city[["votesPartiesAbs"]], 
                 filename=paste0(environment[["folderImages"]], "barPartiesCityAbs"), 
                 colors=city[["partycolors"]], 
                 names=city[["partyAcrAT"]], 
                 title="Ergebnis Parteien (abs)", 
                 output=T, png=T, svg=T, pdf=T)

# party results of city (rel)
VotesColumnChart(city[["votesPartiesRel"]], 
                 filename=paste0(environment[["folderImages"]], "barPartiesCityRel"), 
                 colors=city[["partycolors"]], 
                 names=city[["partyAcrAT"]], 
                 title="Ergebnis Parteien (rel)", 
                 output=T, png=T, svg=T, pdf=T)

# all authorized votes districts 
VotesColumnChart(authVotersDistrict[["authAll"]], 
                 filename=paste0(environment[["folderImages"]], "barAuthAllDisAbs"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Wahlberechtigt Bezirke", 
                 output=T, png=T, svg=T, pdf=T)

# all votes districts (abs)
VotesColumnChart(participationDistrict[["allVotes"]], 
                 filename=paste0(environment[["folderImages"]], "barAllVotesDisAbs"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Wahlbeteiligung Bezirke (abs)", 
                 output=T, png=T, svg=T, pdf=T)

# relative election participation of districts
VotesColumnChart(participationDistrict[["electionParticipation"]], 
                 filename=paste0(environment[["folderImages"]], "barElePartDisRel"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Wahlbeteiligung Bezirke (rel)", 
                 output=T, png=T, svg=T, pdf=T)

# relative unvalid votes of districts
VotesColumnChart(participationDistrict[["unvalidVotesRel"]], 
                 filename=paste0(environment[["folderImages"]], "barUnvalidVotesDisRel"), 
                 colors="cyan", 
                 names=city[["nameDistricts"]], 
                 title="Anteil ungültiger Stimmen (Bezirke)", 
                 output=T, png=T, svg=T, pdf=T)


##  HISTOGRAMS & DENSITY  ##


for(i in seq_along(1:city[["numParties"]])) {
  
  # distribution of votes in parishes (abs)
  Histogram(votesParishEleDay[,2+i], 
            filename=paste0(environment[["folderImages"]], "hist", city[["partyAcrIT"]][i] , "ParAbs"), 
            colors=city[["partycolors"]][i], 
            yaxis="Anzahl", 
            xaxis="Stimmen", 
            title=paste0("Stimmenverteilung Wahlsprengel ", city[["partyAcrAT"]][i], " (abs)"), 
            output=T, png=T, svg=T, pdf=T)
  
  # distribution of votes in parishes (rel)
  Histogram(votesParishEleDay[,13+i], 
            filename=paste0(environment[["folderImages"]], "hist", city[["partyAcrIT"]][i] , "ParRel"), 
            colors=city[["partycolors"]][i], 
            yaxis="Anzahl", 
            xaxis="Prozent", 
            title=paste0("Stimmenverteilung Wahlsprengel ", city[["partyAcrAT"]][i], " (rel)"), 
            output=T, png=T, svg=T, pdf=T)
  
  # density function
  DensityPlot(density(votesParishEleDay[,2+i]), 
              filename=paste0(environment[["folderImages"]], "dens", city[["partyAcrIT"]][i], "ParAbs"), 
              color="cyan", 
              title=paste0("Dichtefunktion ", city[["partyAcrIT"]][i], " (abs)"), 
              output=T, png=T, svg=T, pdf=T)
}

# distribution of relative election participation in parishes
Histogram(participationParishEleDay[["electionPartRel"]], 
          filename=paste0(environment[["folderImages"]], "histElePartParRel"), 
          colors="cyan", 
          yaxis="Anzahl", 
          xaxis="Prozent", 
          title=paste0("Verteilung Wahlbeteiligung Sprengel (rel)"), 
          output=T, png=T, svg=T, pdf=T)

# distribution of relative unvalid votes in parishes
Histogram(participationParishEleDay[["unvalidVotesRel"]], 
          filename=paste0(environment[["folderImages"]], "histUnvalidVotesParRel"), 
          colors="cyan", 
          yaxis="Anzahl", 
          xaxis="Prozent", 
          title=paste0("Verteilung ungültige Stimmen Sprengel (rel)"), 
          output=T, png=T, svg=T, pdf=T)


##  CORRELATION  ##


# Pearson
CalculateCorrelation(votesParishEleDay[, 3:13], votesDistrict[, 2:12], 
                     corrMethod="pearson",
                     folder=environment[["folderImages"]],
                     namesIT=city[["partyAcrIT"]],
                     namesAT=city[["partyAcrAT"]],
                     colors=city[["partycolors"]],
                     legend=F, output=T, png=T, svg=T, pdf=T)

# Spearman
CalculateCorrelation(votesParishEleDay[, 3:13], votesDistrict[, 2:12], 
                     corrMethod="spearman",
                     folder=environment[["folderImages"]],
                     namesIT=city[["partyAcrIT"]],
                     namesAT=city[["partyAcrAT"]],
                     colors=city[["partycolors"]],
                     legend=F, output=T, png=T, svg=T, pdf=T)

# Prepare data for left / right Mur Ufer

left <- city[["leftMurNumDistricts"]]
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

# analyses[["maxCorCoeff"]] <- apply(abs(corCoeff), 1, max, na.rm=TRUE)
# pos <- apply(corCoeff, 1, max, na.rm=TRUE)
# neg <- apply(corCoeff, 1, min, na.rm=TRUE)


# parishes distribution every party solely
for(i in seq_along(1:city[["numParties"]])) {
  # absolute 
  BoxplotLR(votesParishEleDay[, 2+i], votesParishEleDay[, "ufer"],
          filename=paste0(environment[["folderImages"]], "box", city[["partyAcrIT"]][i], "ufer"), 
          colors=city[["partycolors"]][i], 
          names=levels(votesParishEleDay[, "ufer"]),
          title=paste0("Unterschied Verteilung nach Murufer ", city[["partyAcrAT"]][i], " (abs)"),
          legend=F, output=T, svg=T, pdf=T, png=T)
}


# party results of city (rel)
VotesColumnChart(city[["votesPartiesRel"]], 
                 filename=paste0(environment[["folderImages"]], "barPartiesCityRel"), 
                 colors=city[["partycolors"]], 
                 names=city[["partyAcrAT"]], 
                 title="Ergebnis Parteien (rel)", 
                 output=T, png=T, svg=T, pdf=T)













##  STATISTIC VALUES  ##


# variances



# means

# 
# imgWidth <- 88
# imgHeight <- 31
# imgRatio <- width / height
# 
# # add creative commons image to plots
# Boxplot(votesParishEleDay[,3:13], filename=paste0(environment[["folderImages"]], "boxAllPartiesParAbs"), colors=city[["partycolors"]], 
#         names=city[["partyAcrAT"]], title="Verteilung Stimmen Sprengel (abs)", legend=T, output=T, svg=T, pdf=T, png=T)
# 
# Boxplot(votesParishEleDay[,c(14:18, 21)], filename=paste0(environment[["folderImages"]], "boxBig6PartiesParRel"), 
#         colors=city[["partycolors"]][c(1:5, 8)], names=city[["partyAcrAT"]][c(1:5, 8)], title="Boxplots Big6 (rel)", 
#         legend=T, output=T, svg=T, pdf=T, png=T)
# 
# ima <- readPNG("./images/cc/cc-by.png")
# 
# #Get the plot information so the image will fill the plot box, and draw it
# lim <- par()
# lim$usr # x1, x2, y1, y2
# plotWidth <- lim$usr[2] - lim$usr[1]
# plotHeight <- lim$usr[4] - lim$usr[3]
# plotRatio <- plotWidth / plotHeight
# defWidth <- 0.15 # means the default width of the image should be 5% of the plot width, you can scale this with the scalefactor
# 
# posRelXRight <- 0.2
# posRelYRight <- 0.7
# scaleFactor <- 1
# posPlotXRight <- lim$usr[1] + posRelXRight * plotWidth
# posPlotYRight <- lim$usr[3] + posRelYRight * plotHeight
# posPlotXLeft <- posPlotXRight - plotWidth * scaleFactor * defWidth * 0.8
# posPlotYLeft <- posPlotYRight - plotHeight * scaleFactor * defWidth / imgRatio
# rasterImage(ima, posPlotXLeft, posPlotYLeft, posPlotXRight, posPlotYRight)
# 
# lim$usr # x1, x2, y1, y2
# plotWidth
# plotHeight
# posPlotXRight
# posPlotXLeft
# posPlotYRight
# posPlotYLeft


