library(tidvyerse)
library(readxl)
library(lubridate)
library(DT)
disasters <- read_excel("data/DataVizDisasterSummariesFV12.19.2016.xlsx", sheet=3, skip=2)
colnames(disasters) <- make.names(colnames(disasters))

disasters %>% 
  filter(County!="Statewide") %>% 
  group_by(State, County, Incident.Type) %>% 
  summarize(Total=n()) %>% 
  mutate(rank=rank(Total)) %>% 
  arrange(desc(Total)) %>% 
  datatable()

disasters %>% 
  filter(County=="Harris County" & State=="Texas") %>% 
  group_by(Year) %>% 
  summarize(Total=n()) %>% 
  datatable()