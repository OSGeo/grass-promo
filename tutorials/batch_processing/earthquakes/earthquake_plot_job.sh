#!/bin/sh
############################################################################
#
# MODULE:       earthquake_plot_job.sh
# AUTHOR:       M. Hamish Bowman, Depts.of Marine Science and Geology,
#                 Otago Univeristy, New Zealand
# PURPOSE:      Wrapper script to launch GRASS batch job
#                 (perhaps called by cron)
#
# COPYRIGHT:    (c) 2010 Hamish Bowman, and the GRASS Development Team
#               This program is free software under the GNU General Public
#               License (>=v2). Read the file COPYING that comes with GRASS
#               for details.
#
#############################################################################
# Inspired by Markus Neteler's PHP demo, which in turn was seeded from the ideas
#    of [...] and Glynn Clements
# Adjust paths etc. to suit.

## sample crontab:
#  # m h         dom mon dow   command
#    4 2,8,14,20 *   *   *     /usr/local/grass/earthquakes/earthquake_plot_job.sh > /usr/local/grass/earthquakes/earthquake_plot_job.log  2> /usr/local/grass/earthquakes/earthquake_plot_job.err
#


GRASS_BASEDIR="/usr/local/grass"


# avoid a needless search
GRASS_HTML_BROWSER=false
export GRASS_HTML_BROWSER

#### Run the job to make and install the latest earthquake plots

# unprojected (Plate Carree) version
date
GRASS_BATCH_JOB="$GRASS_BASEDIR/earthquakes/do_quakes_latlon.sh"
export GRASS_BATCH_JOB
nice grass64 "$GRASS_BASEDIR/grassdata/ll_wgs84/earthquakes"
unset GRASS_BATCH_JOB

# projected version
date
GRASS_BATCH_JOB="$GRASS_BASEDIR/earthquakes/do_quakes_wintri.sh"
export GRASS_BATCH_JOB
nice grass64 "$GRASS_BASEDIR/grassdata/winkel_III/earthquakes"
unset GRASS_BATCH_JOB


exit
