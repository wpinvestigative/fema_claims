library(tidyverse)
library(readxl)
library(DT)
subapps <- read_csv("data/flood_mitigation_subapps.csv")
subapps2 <- subapps
colnames(subapps2) <- make.names(colnames(subapps2))

subapps2 %>% 
  group_by(Applicant, Year, Status) %>% 
  summarize(total=n()) %>% 
  mutate(all=sum(total), percent=round(total/all*100,2)) %>% 
  filter(Status=="Identified for Further Review") %>% 
  ungroup() %>% 
  mutate(Year=as.factor(Year)) %>% 
  ggplot(aes(Year, percent)) + geom_bar(stat="identity") + 
  facet_wrap(~Applicant, ncol=5) + 
  labs(x=NULL, y="Percent approved", title="Flood Mitigation Assistance Subapplication Status")

# Only South Carolina has less of a success rate at getting funding than Texas

subapps2 %>% 
  group_by(Applicant, Status) %>% 
  summarize(total=n()) %>% 
  mutate(all=sum(total), percent=round(total/all*100,2)) %>% 
  filter(Status=="Identified for Further Review") %>% 
  select(State=Applicant, `Total applications`=all, `Identified for further review`=total, `Percent identified for review`=percent) %>% 
  arrange(`Percent identified for review`) %>% 
  datatable(extensions="Buttons", options=list(
    dom="Bfrtip",
    buttons=c("csv", "excel", "pdf")))

# Texas is Fifth in total subapplications for Flood Mitigation Assistance from FEMA in 2015 and 2016 but is 10th in percent actually identified for review. 
# Context 2016: https://www.fema.gov/flood-mitigation-assistance-fy-2016-subapplication-status
# Context 2015: https://www.fema.gov/flood-mitigation-assistance-fy-2015-subapplication-status

datatable(subapps, extensions="Buttons", options=list(
  dom="Bfrtip",
  buttons=c("csv", "excel", "pdf")))

