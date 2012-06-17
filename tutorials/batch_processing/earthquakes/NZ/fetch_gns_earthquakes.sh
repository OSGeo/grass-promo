#!/bin/sh

# Script to fetch NZ earthquakes from GNS's geonet SOAP interface
#  H. Bowman 20 Jan 2011, released to the public domain
#
#  http://www.geonet.org.nz/resources/earthquake/quake-web-services.html
#  "GeoNet is a collaboration between the Earthquake Commission and GNS Science."
#  "The Website: The GeoNet website provides public access to hazards information,
#   including earthquake reports and Volcanic Alert Bulletins. It also allows the
#   retrieval of fundamental data sets, such as GPS Rinex files, earthquake
#   hypocentres and instrument waveform data. These data are made freely available
#   to the research community."

# requires wget and xml2 to be installed


if [ -n "$1" ] ; then
   OUTFILE="$1"
else
   OUTFILE=latest_gns_quakes.csv
fi
XMLNAME="$OUTFILE.tmp_$$"

URL="http://magma.geonet.org.nz/services/quake/quakeml/1.0.1/query?"
#startDate and endDate (mandatory): format is yyyy-mm-ddThh:MM:ss and times are in UTC (GMT)
#latLower, latUpper, longLower and longUpper (optional, but if present, all must be specified): values should be in decimal degrees


END_DATE=`date --utc +%FT%T`
START_DATE=`date --utc --date="last week" +%FT%T`
#START_DATE=`date --utc --date="2 weeks ago" +%FT%T`
#START_DATE=`date --utc --date="last month" +%FT%T`
#START_DATE=`date --utc --date="6 months ago" +%FT%T`
#START_DATE=`date --utc --date="last year" +%FT%T`

DATE_STR="startDate=$START_DATE&endDate=$END_DATE"
 

wget -nv -O "$XMLNAME" "${URL}startDate=$START_DATE&endDate=$END_DATE"


BASE="quakeml/eventParameters/event"
FIELDS="
origin/time/value
origin/longitude/value
origin/latitude/value
magnitude/mag/value
origin/depth/value
"

echo "#date_utc|time_utc|longitude|latitude|magnitude|depth_km" \
   > "$OUTFILE"

xml2 < "$XMLNAME" | \
   2csv -d'|' $BASE $FIELDS | \
   sed -e 's/T/|/' | grep -v '||' >> "$OUTFILE"

#todo: avoid the tmp file, just pipe from wget -O - | xml2 | 2csv | sed
\rm "$XMLNAME"

