######################################################
#     											 
#   Title: grazwahl2012_elections.R
#   Description: Analyse und Visualisierung der 
#                Nationalratswahlen in Österreich
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


# read in files
graz_nrw2006_bez <- read.csv2("raw/Graz/2006_nrw_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_nrw2006_spr <- read.csv2("raw/Graz/2006_nrw_sprengelerg.csv", fileEncoding = "iso-8859-1")
graz_nrw2008_bez <- read.csv2("raw/Graz/2008_nrw_sprengelbezerg.csv", fileEncoding = "iso-8859-1")
graz_nrw2008_spr <- read.csv2("raw/Graz/2008_nrw_sprengelerg.csv", fileEncoding = "iso-8859-1")

# init variables

# VISUALISIERUNG GEMEINDERATSWAHLEN
data <- graz_grw2003_bez
partycolors <- list(c("FPÖ", "GRÜNE", "GVP", "KPÖ", "LIF", "RWA", "SPÖ", "ÖVP"), c("blue", "green", "yellow", "red", "cyan", "brown", "red", "black"))
parties <- levels(data$ptname)
table(data$ptname)
levels(data$ptname)
total <- tapply(data$stimmen, data$ptname, sum)
total <- sort(total, decreasing = TRUE)
relative <- 100 * total / sum(data$stimmen)


# bar chart
barplot(total, main = "Gemeinderatswahl Graz 2003", xlab="Days", ylab="Total", col = partycolors[[2]])
legend("topright", parties, cex=0.6, bty="n", fill = partycolors[[2]]);
barplot(relative, main = "Gemeinderatswahl Graz 2003", xlab="Days", ylab="Total", col = partycolors[[2]])
legend("topright", parties, cex=0.6, bty="n", fill = partycolors[[2]]);

# pie chart
labels <- round(cars/sum(cars) * 100, 1)
car_labels <- paste(car_labels, "%", sep="")
pie(total, main = "Gemeinderatswahl Graz 2003", lables = labels, col = colorset)
legend(1.5, 0.5, parties, cex=0.8, fill=colors)
pie(relative, main = "Gemeinderatswahl Graz 2003", lables = labels, col = colorset)
legend(1.5, 0.5, parties, cex=0.8, fill=colors)

# line charts
g_range <- range(0, data1, data2)
png(filename="figure.png", height=295, width=300, bg="white")
pdf(file="figure.pdf", height=3.5, width=5)
plot(data, type = "o", col = "blue", ylim=g_range)
axis(1, at=1:5, lab=c("Mon","Tue","Wed","Thu","Fri"))
title(main = "Trend")
lines(trucks, type="o", pch=22, lty=2, col="red")
legend(1, g_range[2], c("cars","trucks"), cex=0.8, col=c("blue","red"), pch=21:22, lty=1:2);
dev.off()


# VISUALISIERUNG NATIONALRATSWAHLEN



# VISUALISIERUNG LANDTAGSWAHLEN




