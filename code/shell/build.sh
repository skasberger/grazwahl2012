#!/bin/bash

# delete folders and files
rm -R data/json
rm -R data/rstat
rm -R data/shape
rm -R images/correlation
rm -R images/density
rm -R images/votes
rm -R images/boxplot
rm -R images/histogram

# run prepData.R
mkdir data/json
mkdir data/rstat

R --no-save < code/rstat/prepData.R 

cp doc/licenses/CC-BY-LICENSE.txt data/rstat/LICENSE.txt
cp doc/licenses/CC-BY-LICENSE.txt data/json/LICENSE.txt

# run visualize.R
mkdir images/correlation
mkdir images/density
mkdir images/votes
mkdir images/boxplot
mkdir images/histogram

R --no-save < code/rstat/visualize.R 

cp doc/licenses/CC-BY-LICENSE.txt images/boxplot/LICENSE.txt
cp doc/licenses/CC-BY-LICENSE.txt images/correlation/LICENSE.txt
cp doc/licenses/CC-BY-LICENSE.txt images/density/LICENSE.txt
cp doc/licenses/CC-BY-LICENSE.txt images/histogram/LICENSE.txt
cp doc/licenses/CC-BY-LICENSE.txt images/votes/LICENSE.txt

# run create_tarball.sh
sh code/shell/create_tarball.sh

# run spatial.R
mkdir data/shape

cp data/raw/shape/bezirksgrenzen/*.* data/shape/

R --no-save < code/rstat/spatial.R 


