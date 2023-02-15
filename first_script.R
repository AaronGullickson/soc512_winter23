###################
# Aaron Gullickson
# Soc 312
###################

library(ggplot2)

# Section 1 ------------------------------------------------

# This is a comment

# lets load the crime data!
load("example_data/crimes.RData")
load("example_data/movies.RData")

summary(crimes$PctMale)
summary(crimes)
summary(movies$Rating)

table(movies$Genre,
      movies$Rating)

# Section 2 ------------------------------------------------


# Section 3 ---------------------------------------------------------------

ggplot(politics, aes(x=party, y=..prop.., group=1))+
  geom_bar()+
  scale_y_continuous(label=scales::percent)+
  labs(x="party affiliation", y=NULL,
       title="Distribution of party affiliation",
       caption="Source: ANES 2016")+
  theme_bw()

ggplot(politics, aes(x=party, y=..prop.., group=1))+
  geom_bar()+
  scale_y_continuous(label=scales::percent)+
  labs(x="party affiliation", y=NULL,
       title="Distribution of party affiliation",
       caption="Source: ANES 2016")+
  theme_fivethirtyeight()

