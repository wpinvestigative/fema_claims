library(tidyverse)
library(rgdal)
#library(maptools)

# What's the folder where your maps are?

map_dir <- "maps"

# Get list of files
unique_list <- list.files(map_dir)

# Isolate the unique dates of the files
id_dates <- unique(substr(unique_list, 12, 21))

# Set up a basefile name
sub_name <- "nws_precip_"

# Loop to read in the shapefiles

for (i in 1:length(id_dates)) {
  solo_map <- readOGR(map_dir, layer=paste0(sub_name, id_dates[i]))
  solo_df <- data.frame(solo_map[c("Id", "Globvalue")])
  solo_df$type <- "new"
  if (i==1) {
    all_df <- solo_df
    all_df$type <- "old"
  } else {
    all_df <- rbind(all_df, solo_df)
    all_df <- spread(all_df, type, Globvalue)
    all_df[is.na(all_df)] <- 0
    all_df$Globvalue <- all_df$old + all_df$new
    all_df$type <- "old"
    all_df <- select(all_df, Id, Globvalue, coords.x1, coords.x2, optional, type)
  }
    
}

write.csv(all_df, "ids_globvalues.csv")