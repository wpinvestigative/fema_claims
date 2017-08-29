library(tidyverse)
library(readxl)

# FLOOD MITIGATION ASSISTANCE GRANTS BY STATE TIMELINE

grants <- read_excel("data/FEMA_HMA_FMA_grants7.14.17.xlsx", sheet=3, skip=2)
colnames(grants) <- make.names(colnames(grants))
grants <- select(grants, -Federal.Share.Obligated)

# STATUS TYPES
## Closed - FEMA will close out the grant award when it determines that all applicable administrative actions and all required work of the EMPG Program award have been completed by the recipient. 
## Approved -
## Awarded - 
## Completed - 
## Obligated - 


grants_total <- read_excel("data/FEMA_HMA_FMA_grants7.14.17.xlsx", sheet=3, range=cell_cols(17:18),
                           col_types=c("numeric", "text" ), skip=2)

colnames(grants_total) <- make.names(colnames(grants_total))
grants_total <- select(grants_total, -Cost.Share.Percentage)

grants <- cbind(grants, grants_total)

grants_ys_sum <- grants %>% 
  group_by(State, Program.FY) %>% 
  summarize(Total=sum(as.numeric(Federal.Share.Obligated)))

ggplot(grants_ys_sum, aes(Program.FY, Total)) +
  geom_bar(stat="identity") +
  facet_wrap(~State, ncol=5)

grants_ys_count <- grants %>% 
  group_by(State, Program.FY) %>% 
  summarize(Total=n())

ggplot(grants_ys_count, aes(Program.FY, Total)) +
  geom_bar(stat="identity") +
  facet_wrap(~State, ncol=5)

texas_grants <- filter(grants, State=="Texas")
harris_houston <- filter(texas_grants, grepl("Harris", Project.Title) | grepl("HARRIS", Project.Counties) | grepl("Harris", Subgrantee))
