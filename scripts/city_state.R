library(tidyverse)

all_claims <- read.delim("data/formatted_claims_all.txt", as.is = TRUE)
city_claims <- filter(all_claims, !grepl(" COUNTY*", community, perl=T))
city_claims$type <- ifelse(grepl("TOWN OF", city_claims$community), "Town", "City")
city_claims$community <- gsub(", TOWN OF", "", city_claims$community)
city_claims$community <- gsub(", CITY OF", "", city_claims$community)
write.csv(city_claims, "city_claims.csv")
all_policies <- read.delim("data/formatted_policies_all.txt", as.is = TRUE)
city_policies <- filter(all_policies, !grepl(" COUNTY*", community, perl=T))
city_policies$type <- ifelse(grepl("TOWN OF", city_policies$community), "Town", "City")
city_policies$community <- gsub(", TOWN OF", "", city_policies$community)
city_policies$community <- gsub(", CITY OF", "", city_policies$community)
write.csv(city_policies, "city_policies.csv")
