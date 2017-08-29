library(tidyverse)
library(rgdal)

# shapefile 
# https://msc.fema.gov/portal/downloadProduct?filepath=/FRP/FRD_12040104_05_Shapefiles_20170406.zip&productTypeID=FLOOD_RISK_PRODUCT&productSubTypeID=FLOOD_RISK_DB&productID=FRD_12040104_05_Shapefiles
# https://msc.fema.gov/portal/downloadProduct?filepath=/FRP/FRD_12040104_Shapefiles_20170503.zip&productTypeID=FLOOD_RISK_PRODUCT&productSubTypeID=FLOOD_RISK_DB&productID=FRD_12040104_Shapefiles
# coastal
# https://msc.fema.gov/portal/downloadProduct?filepath=/FRP/FRD_48071C_Coastal_Shapefiles_20130830.zip&productTypeID=FLOOD_RISK_PRODUCT&productSubTypeID=FLOOD_RISK_DB&productID=FRD_48071C_Coastal_Shapefiles
# https://msc.fema.gov/portal/downloadProduct?filepath=/FRP/FRD_Harris_Coastal_Shapefiles_20141205.zip&productTypeID=FLOOD_RISK_PRODUCT&productSubTypeID=FLOOD_RISK_DB&productID=FRD_Harris_Coastal_Shapefiles
# 09
# https://msc.fema.gov/portal/downloadProduct?filepath=/FRP/FRD_Harris_FY09_shapefiles_20140228.zip&productTypeID=FLOOD_RISK_PRODUCT&productSubTypeID=FLOOD_RISK_DB&productID=FRD_Harris_FY09_shapefiles
# 11
# https://msc.fema.gov/portal/downloadProduct?filepath=/FRP/FRD_Harris_FY09_shapefiles_20140228.zip&productTypeID=FLOOD_RISK_PRODUCT&productSubTypeID=FLOOD_RISK_DB&productID=FRD_Harris_FY09_shapefiles

harris <- readOGR("maps", "S_PFD_Ar")
plot(harris)