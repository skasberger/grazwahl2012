#!/bin/sh
# DATUM HEUTE ALS DATEINAME EINFÜGEN

TODAY=$(date +"%Y-%m-%d_%H-%M-%S")

wget https://search.twitter.com/search.json?q=%23grazwahl -O %23grazwahl_$TODAY.txt #grazwahl
wget https://search.twitter.com/search.json?q=%23grazwaehlt -O %23grazwaehlt_$TODAY.txt #grazwaehlt
wget https://search.twitter.com/search.json?q=%23grw12 -O %23grw12_$TODAY.txt #grw12
wget https://search.twitter.com/search.json?q=%23graz2012 -O %23graz2012_$TODAY.txt #graz2012
wget https://search.twitter.com/search.json?q=%23graz12 -O %23graz12_$TODAY.txt #graz12
wget https://search.twitter.com/search.json?q=%23graz -O %23graz_$TODAY.txt #graz


# UMSTELLEN AUF STREAM API !!!!

















