library(tidvyerse)
library(readxl)
library(lubridate)
library(DT)
hazards <- read_excel("data/FEMAHazardMitigation3.15.2017.xlsx", sheet=3, skip=2)
hazards <- select(hazards, -`Project Amount`)

hazards_total <- read_excel("data/FEMAHazardMitigation3.15.2017.xlsx", sheet=3, range=cell_cols(14:15),
                           col_types=c("text", "numeric" ), skip=2)

hazards_total <- select(hazards_total, -`Cost Share Percentage`)

hazards <- cbind(hazards, hazards_total)
hazards$date <- ymd_hms(hazards$`Declaration Date`)
hazards$year <- year(hazards$date)

# Let's look at hazards total / percents

hazards %>% 
  group_by(State)  %>% 
  summarize(Total=n()) %>% 
  arrange(desc(Total)) %>% 
  datatable()

# Texas asks for the fourth-most aid

hazards %>% 
  group_by(State)  %>% 
  summarize(Total=sum(as.numeric(`Project Amount`), na.rm=T)) %>% 
  arrange(desc(Total)) %>% 
  datatable()

# They ask for the third-most amount of money

# How much money do states receive?
hazards %>% 
  group_by(State)  %>% 
  filter(Status=="Approved") %>% 
  summarize(Total=sum(as.numeric(`Project Amount`), na.rm=T)) %>% 
  arrange(desc(Total)) %>% 
  datatable()

# They still receive the third-most amount

# How often do they get approved?

hazards %>% 
  group_by(State, Status) %>% 
  summarize(Count=n()) %>% 
  mutate(Total=sum(Count, na.rm=T), Percent=round(Count/Total*100,2)) %>% 
  filter(Status=="Approved") %>% 
  select(State, Approved=Count, Total, `Percent Approved`=Percent) %>% 
  arrange(`Percent Approved`) %>% 
  datatable()