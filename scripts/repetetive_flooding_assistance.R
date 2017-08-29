library(tidyverse)
library(readxl)

# FLOOD MITIGATION ASSISTANCE GRANTS BY STATE TIMELINE

rep <- read_excel("data/FEMA-HMA-RFC_Project_List7.14.17.xlsx", sheet=3, skip=2)
colnames(rep) <- make.names(colnames(rep))
rep <- select(rep, -Federal.Share.Obligated)

# STATUS TYPES
## Closed - FEMA will close out the grant award when it determines that all applicable administrative actions and all required work of the EMPG Program award have been completed by the recipient. 
## Approved -
## Awarded - 
## Completed - 
## Obligated - 


rep_total <- read_excel("data/FEMA-HMA-RFC_Project_List7.14.17.xlsx", sheet=3, range=cell_cols(17:18),
                           col_types=c("numeric", "text" ), skip=2)

colnames(rep_total) <- make.names(colnames(rep_total))
rep_total <- select(rep_total, -Cost.Share.Percentage)

rep <- cbind(rep, rep_total)

rep_ys_sum <- rep %>% 
  group_by(State, Program.FY) %>% 
  summarize(Total=sum(as.numeric(Federal.Share.Obligated)))

ggplot(rep_ys_sum, aes(Program.FY, Total)) +
  geom_bar(stat="identity") +
  facet_wrap(~State, ncol=5)

rep_ys_count <- rep %>% 
  group_by(State, Program.FY) %>% 
  summarize(Total=n())

ggplot(rep_ys_count, aes(Program.FY, Total)) +
  geom_bar(stat="identity") +
  facet_wrap(~State, ncol=5)

texas_rep <- filter(rep, State=="Texas")
harris_houston <- filter(texas_rep, grepl("Harris", Project.Title) | grepl("HARRIS", Project.Counties) | grepl("Harris", Subgrantee))
