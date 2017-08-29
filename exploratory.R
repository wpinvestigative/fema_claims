# http://www.fema.gov/policy-claim-statistics-flood-insurance/policy-claim-statistics-flood-insurance/policy-claim-13

library(tidyverse)


# required functions
source("analyze_policies.R")  # function to preprocess policies data
source("analyze_claims.R")  # function to preprocess claims data

policies <- Fn_Analyze_Policies()
claims <- Fn_Analyze_Claims()

all_data <- merge(policies, claims, by = c("state", "county"), all = TRUE)
# convert state and county names to be consistent with ggplot2
all_data$state <- tolower(all_data$state)
all_data$county <- tolower(all_data$county)
# remove ' county' and ' parish' from county names
all_data$county <- gsub(" county", "", all_data$county)
all_data$county <- gsub(" parish", "", all_data$county)

geo_county <- map_data("county")
names(geo_county) <- c("long", "lat", "group", "order", "state", "county")
geo_state <- map_data("state")

gfx_data <- merge(geo_county, all_data, by = c("state", "county"))
gfx_data <- gfx_data[order(gfx_data$order), ]
# discretise variables of interest
gfx_data$policies_gfx <- cut(gfx_data$policies, breaks = c(1, 30, 100, 300, 
                                                           1000, 10000, 4e+05), labels = c("1 - 30", "30 - 100", "100 - 300", "300 - 1k", 
                                                                                           "1k - 10k", "10k - 400k"))
gfx_data$payments_gfx <- cut(gfx_data$total_pay/10^6, breaks = c(0, 0.05, 0.4, 
                                                                 1.7, 6.3, 50, 7300), labels = c("0 - 50k", "50k - 400k", "400k - 1.7M", 
                                                                                                 "1.7M - 6.3M", "6.3M - 50M", "50M - 7.3B"))

plot_map <- ggplot(data = gfx_data) + geom_polygon(aes(long, lat, group = group, 
                                                       fill = policies_gfx)) + geom_path(data = geo_state, aes(x = long, y = lat, 
                                                                                                               group = group), fill = NA, na.rm = TRUE) + labs(list(title = "NFIP Policies Per County", 
                                                                                                                                                                    x = NULL, y = NULL)) + guides(fill = guide_legend(title = "Policies Per County")) + 
  scale_fill_brewer(palette = "Accent") + coord_fixed()
# save plot
png("nfip_policies.png", width = 10, height = 8, units = "in", res = 72)
print(plot_map)
garbage <- dev.off()

plot_map <- ggplot(data = gfx_data) + geom_polygon(aes(long, lat, group = group, 
                                                       fill = payments_gfx)) + geom_path(data = geo_state, aes(x = long, y = lat, 
                                                                                                               group = group), fill = NA, na.rm = TRUE) + labs(list(title = "NFIP Payments Per County (US$)", 
                                                                                                                                                                    x = NULL, y = NULL)) + guides(fill = guide_legend(title = "Payments Per County (US$)")) + 
  scale_fill_brewer(palette = "Accent") + coord_fixed()
png("nfip_payments.png", width = 10, height = 8, units = "in", res = 72)
print(plot_map)
garbage <- dev.off()


# leaflet

library(leaflet)
library(tigris)
library(raster)
library(maps)

usa_map <- counties(cb=F)
crs(usa_map)


usa_map$area_sqmi <-(area(usa_map) / 1000000)*.62137

usa_map$S
state_list <- select(geo_state, group, region)
state_list <- unique(state_list)

library(censusapi)
vars2015 <- listCensusMetadata(name="acs5", vintage=2015, "v")
View(vars2015)
source(keys.R)

data2014 <- getCensus(name="acs5", 
                      vintage=2014,
                      key=census_key, 
                      vars=c("NAME", "B01001_001E", "B19013_001E",
                             "B17010_017E", "B17010_037E"), 
                      region="county:*")
View(data2014)

tracts <- read_csv("data/states_counties_tracts.csv")
pop_land <- read_csv("data/DEC_10_SF1_GCTPH1.US05PR_with_ann.csv", skip=1)
# Get census data