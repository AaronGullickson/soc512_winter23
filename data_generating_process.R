# Data Generating Process

library(tidyverse)

# lets create some stats for the good ship lollipop
good_ship <- tibble(gender=sample(c("Male","Female"), 10000, replace=TRUE),
                    class=sample(c("High Class","Low Class"), 10000, 
                                 replace=TRUE, prob = c(0.10, 0.90)),
                    age=floor(rgamma(10000, 15)))


# lets model log-odds of survival
good_ship <- good_ship |>
  mutate(logodds=-0.693-0.223*(gender=="Male")+0.542*(class=="High Class")-0.03*(age-10),
         odds=exp(logodds),
         prob=odds/(1+odds))

good_ship$survived <- rbinom(10000, 1, good_ship$prob)

# Play Inspector

model <- glm(survived~I(gender=="Male")+I(class=="High Class")+I(age-10),
             data=good_ship, family=binomial(link="logit"))


