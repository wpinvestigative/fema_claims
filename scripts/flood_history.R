library(tidyverse)
floods <- read.csv("data/flood_history.csv")
colnames(floods) <- c("event", "month-year", "losses", "amount.pd", "avg.pd.loss", "year", "month")

ggplot(floods, aes(year, losses)) +
  geom_bar(stat="identity")


ggplot(floods, aes(year, avg.pd.loss)) +
  geom_bar(stat="identity")


