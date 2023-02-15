library(ggplot2)
library(tidyverse)
load("example_data/earnings.RData")
load("example_data/politics.RData")

x <- reorder(earnings$race, earnings$wages, median)

ggplot(earnings, 
       aes(x=reorder(race, wages, median, decreasing=FALSE),
           y=wages))+
  geom_boxplot(fill="grey", outlier.color="red")+
  scale_y_continuous(label=scales::dollar)+
  labs(x=NULL, y="hourly wages",
       title="Comparative boxplots of wages by race",
       caption="Source: CPS 2018")+
  theme_bw()

ggplot(earnings, 
       aes(x=reorder(race, wages, median),
           y=wages))+
  geom_violin(fill="grey")+
  scale_y_continuous(label=scales::dollar)+
  labs(x=NULL, y="hourly wages",
       title="Comparative boxplots of wages by race",
       caption="Source: CPS 2018")+
  theme_bw()

tapply(politics$income, politics$president, mean)
tapply(politics$income, politics$president, median)

politics |>
  group_by(president) |> 
  summarize(mean_income=mean(income),
            median_income=median(income))
