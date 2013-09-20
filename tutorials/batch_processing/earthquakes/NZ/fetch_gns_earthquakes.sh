#!/bin/sh

# Script to fetch NZ earthquakes from GNS's geonet SOAP interface
#  H. Bowman 20 Jan 2011, released to the public domain
#            updated to use new WFS method 20 Nov 2012
#
#  http://info.geonet.org.nz/display/appdata/Earthquake+Web+Feature+Service
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


URL="http://wfs-beta.geonet.org.nz/geoserver/geonet/ows?"
REQUEST="service=WFS&version=1.1.0&request=GetFeature&typeName=geonet:quake&outputFormat=text/xml; subtype=gml/3.2"

START_DATE=`date --utc --date="last week" +%F`
#START_DATE=`date --utc --date="2 weeks ago" +%F`
#START_DATE=`date --utc --date="last month" +%F`
#START_DATE=`date --utc --date="6 months ago" +%F`
#START_DATE=`date --utc --date="last year" +%F`


wget -nv -O "$XMLNAME" "${URL}${REQUEST}&cql_filter=origintime>='$START_DATE'"

if [ $? -ne 0 ] ; then
   echo "Failed to download data from GNS." >&2
   rm "$XMLNAME"
   exit 1
fi


BASE="wfs:FeatureCollection/wfs:member/geonet:quake"
FIELDS="
geonet:origintime
geonet:longitude
geonet:latitude
geonet:magnitude
geonet:depth
"

echo "#date_utc|time_utc|longitude|latitude|magnitude|depth_km" \
   > "$OUTFILE"

xml2 < "$XMLNAME" | \
   2csv -d'|' $BASE $FIELDS | \
   sed -e 's/T/|/' | grep -v '||' >> "$OUTFILE"

#todo: avoid the tmp file, just pipe from wget -O - | xml2 | 2csv | sed
rm "$XMLNAME"

