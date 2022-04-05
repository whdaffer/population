# Working with shapefiles
# https://datacarpentry.org/r-raster-vector-geospatial/06-vector-open-shapefile-in-r/
#
# Needed to install udunits2 and gdal.
#
# But having problems with proj_api.h install.packages('sf'). The current
# version of proj available with MacPorts (proj8) doesn't have that file and I
# can't get Rstudio to see proj7 (which does). So, the upshot is that I'm having
# *severe* problems installing sf on Big Sur! Trying to do this on the desktop
# corrupted the whole Rstudio installation and I had to scrub it completely.
#
# DON'T DO IT.

library(tidyverse)