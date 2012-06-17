#!/bin/sh

# 2006 Markus Neteler
#
#      This program is free software under the GNU General Public
#      License (>=v2). Read the file COPYING that comes with GRASS
#      for details.
#######
# Script to launch GRASS, fetch the USGS list of recent
# earthquakes, generate map, leave GRASS.
#
# Inspired by
#   http://grass.itc.it/spearfish/php_grass_earthquakes.php
#
# Requirements:
# - grass6 installation
# - latitude-longitude GRASS location (= GRASS project)
#######################################################

# some settings:
TMPDIR=/tmp

# directory of our software and grassdata:
MAINDIR=/asd0/ssi/neteler_grid/software
# our private /usr/ directory:
MYUSER=$MAINDIR/myusr

# path to GRASS binaries and libraries:
export GISBASE=$MYUSER/grass-6.1.cvs

# generate GRASS settings file:
# the file contains the GRASS variables which define the LOCATION etc.
echo "GISDBASE: $MAINDIR/grassdata
LOCATION_NAME: latlong
MAPSET: PERMANENT
" > $TMPDIR/.grassrc6_earthquakes

# path to GRASS settings file:
export GISRC=$TMPDIR/.grassrc6_earthquakes

# first our GRASS, then the rest
export PATH=$GISBASE/bin:$GISBASE/scripts:$PATH
#first have our private libraries:
export LD_LIBRARY_PATH=$MYUSER/lib:$GISBASE/lib:$LD_LIBRARY_PATH

# settings for graphical output
PNGOUTPUTDIR=$TMPDIR
# current date
DATE=`LC_ALL=C date -R | tr -s ' ' ' ' | cut -d' ' -f2,3,4 | tr -s ' ' '_'`
export GRASS_PNGFILE=$PNGOUTPUTDIR/grass6_recent_earthquakes_${DATE}.png
export GRASS_TRUECOLOR=TRUE
export GRASS_WIDTH=900
export GRASS_PNG_COMPRESSION=1

# use process ID (PID) as lock file number:
export GIS_LOCK=$$


##### the algorithms goes here

error_routine () {
 echo "ERROR: $1"
 exit 1
}

# fetch last earthquake bulletin:
lynx -dump http://neic.usgs.gov/neis/gis/bulletin.asc > $TMPDIR/bulletin.tmp || error_routine "lynx"
cat $TMPDIR/bulletin.tmp | sed 's+ ++g' | grep -v ',,' | grep -v '^$' > $TMPDIR/bulletin.asc

# set region to default settings (here: world)
g.region -d || error_routine "g.region"

#open PNG output
d.mon start=PNG || error_routine "d.mon start=PNG"

# import earthquake bulletin:
cat $TMPDIR/bulletin.asc | v.in.ascii out=recent_earthquakes skip=1 \
     fs=',' y=3 x=4 \
     col='e_date date, e_time varchar(10), lat double precision, long double precision, magnitude double precision, depth double precision' --o || error_routine "v.in.ascii"

# add new columns for magnitude classification:
v.db.addcol recent_earthquakes col='class integer' || error_routine "v.db.addcol"
v.db.update recent_earthquakes col=class value=1 where='magnitude < 3'  || error_routine "v.db.addcol"
v.db.update recent_earthquakes col=class value=2 where='magnitude >=3 AND magnitude < 4'  || error_routine "v.db.addcol"
v.db.update recent_earthquakes col=class value=3 where='magnitude >=4 AND magnitude < 5'  || error_routine "v.db.addcol"
v.db.update recent_earthquakes col=class value=4 where='magnitude >=5 AND magnitude < 6'  || error_routine "v.db.addcol"
v.db.update recent_earthquakes col=class value=5 where='magnitude >=6 AND magnitude < 7'  || error_routine "v.db.addcol"
v.db.update recent_earthquakes col=class value=6 where='magnitude >=8'  || error_routine "v.db.addcol"

# display nice world satellite background image (already saved in LOCAITON):
d.rast BMNG_May.rgb || error_routine "d.rast"

# show classified earthquakes:
d.vect.thematic recent_earthquakes column=class type=point \
  themetype=graduated_points maxsize=20 nint=6  || error_routine "d.vect.thematic"

# close PNG output
d.mon stop=PNG  || error_routine "d.mon stop"

# remove imported map, no longer needed:
g.remove vect=recent_earthquakes  || error_routine "g.remove"
rm -f $TMPDIR/bulletin.asc $TMPDIR/bulletin.tmp

# remove internal tmp stuff:
$GISBASE/etc/clean_temp  || error_routine "clean_temp"
rm -rf $TMPDIR/grass6-$USER-$GIS_LOCK

# done.
echo "Generated $GRASS_PNGFILE"

