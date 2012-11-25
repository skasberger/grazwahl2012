library(twitteR)

# read in files Graz
graz_grw2003_bezerg    <- read.csv("raw/Graz/2003_grw_sprengelbezerg.csv", header = TRUE, sep = ";", encoding = "latin3") # encoding + columns
graz_grw2003_sprengerg <- read.csv("raw/Graz/2003_grw_sprengelerg.csv") # encoding + columns
graz_ltw2005_bezerg    <- read.csv("raw/Graz/2005_ltw_sprengelbezerg.csv") # encoding + columns
graz_ltw2005_sprengerg <- read.csv("raw/Graz/2005_ltw_sprengelerg.csv") # encoding + columns
graz_nrw2006_bezerg    <- read.csv("raw/Graz/2006_nrw_sprengelbezerg.csv") # encoding + columns
graz_nrw2006_sprengerg <- read.csv("raw/Graz/2006_nrw_sprengelerg.csv") # encoding + columns
graz_grw2008_bezerg    <- read.csv2("raw/Graz/2008_grw_sprengelbezerg.csv") # encoding
graz_grw2008_sprengerg <- read.csv2("raw/Graz/2008_grw_sprengelerg.csv") # encoding
graz_nrw2008_bezerg    <- read.csv2("raw/Graz/2008_nrw_sprengelbezerg.csv") # encoding
graz_nrw2008_sprengerg <- read.csv2("raw/Graz/2008_nrw_sprengelerg.csv") # encoding
graz_ltw2010_bezerg    <- read.csv2("raw/Graz/ltw_2010_sprengelbezerg.csv") # encoding
graz_ltw2010_sprengerg <- read.csv2("raw/Graz/ltw_2010_sprengelerg.csv") # encoding
graz_ltw2010_wahlbez    <- read.csv2("raw/Graz/ltw_2010_sprengel_wahlbe.csv")

# read in files Steiermark
stmk_    <- read.csv("raw/Steiermark/.csv", header = TRUE, sep = ";", encoding = "latin3")

# read in files Oesterreich
aut_    <- read.csv("raw/Oesterreich/.csv", header = TRUE, sep = ";", encoding = "latin3")

# Twitter
# searchTwitter(’charlie sheen’, since=’2011-03-01’, until=’2011-03-02’)
grazwahl <- searchTwitter("#grazwahl", n=2000)
graz <- searchTwitter("#graz", n=2000)
graz12 <- searchTwitter("#graz12", n=2000)
graz2012 <- searchTwitter("#graz2012", n=2000)
grw12 <- searchTwitter("#grw12", n=2000)
grazwaehlt <- searchTwitter("#grazwaehlt", n=2000)


# Test
test <- read.csv("raw/Graz/2003_grw_sprengelbezerg.csv", header = TRUE, sep = ",")

