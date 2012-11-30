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


# FIRST: load the data from "grazwahl2012_elections.RData". Just uncomment the next line. 
# load("grazwahl2012_elections.RData")
# You also can generate the data newly via executing the grazwahl2012_prepdata file

##### GEMEINDERATSWAHLEN GRAZ 2012 #####

# INIT VARIABLES
disctricts <- (c("Innere Stadt", "St Leonhard", "Geidorf", "Lend", "Gries", 
              "Jakomini", "Liebenau", "St.Peter", "Waltendorf", "Ries", "Mariatrost", 
              "Andritz", "Gösting", "Eggenberg", "Wetzelsdorf", "Straßgang", "Puntigam", "Virtuell"))

count_parties_2012 <- 11

# PREPARE DATA FOR QGIS

# generate list of parties
graz_grw2012_parties_2012 <- as.character(graz_grw2012_bez$ptname[1:count_parties_2012])
graz_grw2012_parties_2012[9] <- "EKW"
#qgis_graz_grw2012_bez_total <- 

# generate matrix of elections participation (with gender specific data)
wb_bez_total <- tapply(graz_grw2012_wb$wahlbe_gesamt, graz_grw2012_wb$bezirk, sum)
wb_bez_gender_total <- cbind(tapply(graz_grw2012_wb$wahlbe_mann, graz_grw2012_wb$bezirk, sum),
                             tapply(graz_grw2012_wb$wahlbe_frau, graz_grw2012_wb$bezirk, sum))
colnames(wb_bez_gender_total) <- c("men_valid", "women_valid")


# transform votes organized by party and disctrict to the structure necessary for QGIS
temp_parties <- data.frame(1:count_parties_2012)
for(i in seq_along(1:count_disctricts)) {
  start <- (i - 1) * count_parties_2012 + 1
  end <- i * count_parties_2012
  temp_parties <- cbind(temp_parties, graz_grw2012_bez$stimmen[start:end])
}
temp_parties <- temp_parties[, 2:length(temp_parties)]
temp_parties <- t(temp_parties)
temp_parties <- rbind(temp_parties, "NA")
colnames(temp_parties) <- graz_grw2012_parties_2012[1:count_parties_2012]


# PARTICIPATION (total & relative)

# participation overall -> total
qgis_graz_grw2012_bez_part_total <- cbind(as.data.frame(id_districts), wb_bez_total, wb_bez_gender_total)

write.csv(qgis_graz_grw2012_bez_participation_total, 
          "QGIS/qgis_graz_grw2012_bez_participation_total_comma.csv", fileEncoding = "UTF-8")
write.csv2(qgis_graz_grw2012_bez_participation_total, 
           "QGIS/qgis_graz_grw2012_bez_participation_total_semicolon.csv", fileEncoding = "UTF-8")

# participation overall -> relative
# qgis_graz_grw2012_bez_participation_relativ <- 
# colnames(qgis_graz_grw2012_bez_participation_total) <- c("id_district", "man", "woman", graz_grw2012_parties_2012[1:count_parties])
#write.csv(qgis_graz_grw2012_bez_participation_relativ, 
          #"QGIS/qgis_graz_grw2012_bez_participation_relativ_comma.csv", fileEncoding = "UTF-8")
#write.csv2(qgis_graz_grw2012_bez_participation_relativ, 
#           "QGIS/qgis_graz_grw2012_bez_participation_relativ_semicolon.csv", fileEncoding = "UTF-8")

# PARTIES (total & relative)

# votings for parties by district -> total
qgis_graz_grw2012_bez_parties_total <- cbind(as.data.frame(id_districts), temp_parties)
write.csv(qgis_graz_grw2012_bez_parties_total, 
          "QGIS/qgis_graz_grw2012_bez_parties_total_comma.csv", fileEncoding = "UTF-8")
write.csv2(qgis_graz_grw2012_bez_parties_total, 
           "QGIS/qgis_graz_grw2012_bez_parties_total_semicolon.csv", fileEncoding = "UTF-8")

# votings for parties by district -> relative
# qgis_graz_grw2012_bez_parties_relativ <- 
#write.csv(qgis_graz_grw2012_bez_parties_relativ, 
#          "QGIS/qgis_graz_grw2012_bez_parties_relativ_comma.csv", fileEncoding = "UTF-8")
#write.csv2(qgis_graz_grw2012_bez_parties_relativ, 
#           "QGIS/qgis_graz_grw2012_bez_parties_relativ_semicolon.csv", fileEncoding = "UTF-8")

# remove unneccessary data
rm(temp_parties, start, end, i)








