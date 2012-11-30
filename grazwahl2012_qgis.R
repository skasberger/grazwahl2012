######################################################
#         									 
#   Title: grazwahl2012_qgis.R
#   Description: Prepare data for Analyses and Visualization in Quantum GIS
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



# FIRST: laod the data from "grazwahl2012_elections.RData"

##### GEMEINDERATSWAHLEN #####
# Graz 2012

# INIT DATA 
bezirke <- (c("Innere Stadt", "St Leonhard", "Geidorf", "Lend", "Gries", 
              "Jakomini", "Liebenau", "St.Peter", "Waltendorf", "Ries", "Mariatrost", 
              "Andritz", "Gösting", "Eggenberg", "Wetzelsdorf", "Straßgang", "Puntigam", "Virtuell"))

count_parties <- 11
count_bezirke <- 17
id_bezirke <- c(1:count_bezirke, "27")


parties_2012 <- as.character(graz_grw2012_bez$ptname[1:count_parties])
parties_2012[9] <- "EKW"
qgis_graz_grw2012_bez <- as.data.frame(id_bezirke)

men <- tapply(graz_grw2012_wb$wahlbe_mann, graz_grw2012_wb$bezirk, sum)
women <- tapply(graz_grw2012_wb$wahlbe_frau, graz_grw2012_wb$bezirk, sum)

temp_parties <- data.frame(1:count_parties)
for(i in seq_along(1:count_bezirke)) {
  start <- (i - 1) * count_parties + 1
  end <- i * count_parties
  temp_parties <- cbind(temp_parties, graz_grw2012_bez$stimmen[start:end])
}
temp_parties <- temp_parties[, 2:length(temp_parties)]
temp_parties <- t(temp_parties)
temp_parties <- rbind(temp_parties, "NA")
qgis_graz_grw2012_bez <- cbind(qgis_graz_grw2012_bez, men, women, temp_parties)
colnames(qgis_graz_grw2012_bez) <- c("id_bezirke", mann", "frau", parties_2012[1:count_parties])

write.csv(qgis_graz_grw2012_bez, "QGIS/qgis_graz_grw2012_bez_comma.csv", fileEncoding = "UTF-8")
write.csv2(qgis_graz_grw2012_bez, "QGIS/qgis_graz_grw2012_bez_semicolon.csv", fileEncoding = "UTF-8")
rm(temp_parties, men, women, end, start, i)








