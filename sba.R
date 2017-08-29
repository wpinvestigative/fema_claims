library(tidvyerse)
library(readxl)
library(lubridate)
library(DT)
sba <- read_excel("data/DataVizIASBAFV12.19.2016.xlsx", sheet=3, skip=2)
colnames(sba) <- make.names(colnames(sba))

sba %>% 
  filter(County!="Statewide") %>% 
  group_by(State, County, Incident.Type) %>% 
  summarize(Total=n()) %>% 
  mutate(rank=rank(Total)) %>% 
  arrange(desc(Total)) %>% 
  datatable()

sba %>% 
  filter(County=="Harris County" & State=="Texas") %>% 
  group_by(Fiscal.Year) %>% 
  summarize(Total=n()) %>% 
  datatable()

sba %>% 
  filter(County!="Statewide") %>% 
  group_by(State, County, Incident.Type) %>% 
  summarize(Total=sum(Monies)) %>% 
  arrange(desc(Total)) %>% 
  group_by(Incident.Type) %>% 
  mutate(rank=rank(desc(Total))) %>% 
  datatable()

sba %>% 
  filter(County!="Statewide" & Incident.Type=="Flood") %>% 
  group_by(State, County, )

totals <- sba %>% 
  filter(County!="Statewide") %>% 
  group_by(State, County) %>% 
  summarize(Total=sum(Monies)) %>% 
  arrange(desc(Total)) %>% 
  mutate(rank=rank(Total)) %>% 
  datatable()

sba %>% 
  filter(County=="Harris County" & State=="Texas") %>% 
  group_by(Fiscal.Year) %>% 
  summarize(Total=sum(Monies)) 
  #datatable()