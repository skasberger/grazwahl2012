######################################################
#       										 
#   Title: grazwahl2012_twitter.R
#   Description: Analyse und Visualisierung der 
#                Grazer Gemeinderatswahlen 2012 auf Twitter
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


library(twitteR)

# searchTwitter(’charlie sheen’, since=’2011-03-01’, until=’2011-03-02’)
grazwahl <- searchTwitter("#grazwahl", n=2000)
graz <- searchTwitter("#graz", n=2000)
graz12 <- searchTwitter("#graz12", n=2000)
graz2012 <- searchTwitter("#graz2012", n=2000)
grw12 <- searchTwitter("#grw12", n=2000)
grazwaehlt <- searchTwitter("#grazwaehlt", n=2000)
