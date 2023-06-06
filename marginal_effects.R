# Calculate marginal effects
# Soc 413/513 - Spring 2023

# Load libraries and data -------------------------------------------------

library(tidyverse)
library(margins)
library(modmarg)
library(texreg)

load("example_data/titanic.RData")
load("example_data/earnings.RData")


# fix levels issue with survival, passenger class, and sex
titanic <- titanic |>
  mutate(survival=factor(as.character(survival), levels=c("Died","Survived")),
         sex=factor(as.character(sex), levels=c("Male","Female")),
         pclass=factor(as.character(pclass), levels=c("First","Second","Third")))


# Calculate a model -------------------------------------------------------

# predict survival by sex, age, and fare
model1 <- glm(survival~sex+age+fare, data=titanic, family=binomial)

# Calculate MEM of sex --------------------------------------------

# marginal effect at the mean (MEM) on probability of sex

# make a data.frame for a man and woman at the mean on all other variables
titanic_means <- data.frame(sex=c("Male","Female"), age=mean(titanic$age),
                            fare=mean(titanic$fare))
lodds <- predict(model1, newdata=titanic_means)
odds <- exp(lodds)
prob <- odds/(1+odds)
mem_female <- diff(prob)

# try it at different values
titanic_means <- data.frame(sex=c("Male","Female"), age=72, fare=5)
lodds <- predict(model1, newdata=titanic_means)
odds <- exp(lodds)
prob <- odds/(1+odds)


# Calculate AME of sex ----------------------------------------------------

# average marginal effect (AME) on probability of sex

# what would the average probability of survival be if everyone was male, 
# according to the model?
titanic_male <- titanic
titanic_male$sex <- "Male"
lodds_male <- predict(model1, newdata = titanic_male)
odds_male <- exp(lodds_male)
prob_male <- odds_male/(1+odds_male)
prob_male_mean <- mean(prob_male)

# now do the same but make everyone female
titanic_female <- titanic
titanic_female$sex <- "Female"
lodds_female <- predict(model1, newdata = titanic_female)
odds_female <- exp(lodds_female)
prob_female <- odds_female/(1+odds_female)
prob_female_mean <- mean(prob_female)

ame_female <- prob_female_mean-prob_male_mean
ame_female


# Use margins or modmarg library to get AME/MEMs --------------------------

## use margins ##

# AME in margins
margins(model1, variables = "sex")

# MEM in margins
margins(model1, variables = "sex", at=list(fare=mean(titanic$fare), 
                                           age=mean(titanic$age)))

# summary command on margins without variable argument will give you all AMEs
# and standard errors
summary(margins(model1))

## use modmarg::marg ##

# AME in modmarg::marg
marg(model1, "sex", type="effects")

# MEM in modmarg::marg
marg(model1, "sex", type="effects", at=list(fare=mean(titanic$fare), 
                                            age=mean(titanic$age)))

# modmarg can also return levels rather than effects
marg(model1, "sex", type="levels")

# Calculate MEM of age ----------------------------------------------------

# How do we hold sex "at the mean"  - we convert it to a 0/1 variable and
# take its mean, which will be the proportion female

titanic$female <- ifelse(titanic$sex=="Female", 1, 0)
model1a <- glm(survival~female+age+fare, data=titanic, family=binomial)

titanic_means <- data.frame(female=mean(titanic$female), 
                            fare=mean(titanic$fare),
                            age=c(mean(titanic$age), mean(titanic$age)+1))
                            
lodds <- predict(model1a, newdata=titanic_means)
prob <- exp(lodds)/(1+exp(lodds))

age_mem <- diff(prob)

# Calculate AME of age ----------------------------------------------------

# get the probability of survival at current ages
lodds_orig <- predict(model1)
odds_orig <- exp(lodds_orig)
prob_orig <- odds_orig/(1+odds_orig)
prob_orig_mean <- mean(prob_orig)

# age everyone a year and then calculate probability of survival
titanic_age <- titanic
titanic_age$age <- titanic$age+1
lodds_age <- predict(model1, newdata=titanic_age)
odds_age <- exp(lodds_age)
prob_age <- odds_age/(1+odds_age)
prob_age_mean <- mean(prob_age)

ame_age <- prob_age_mean - prob_orig_mean
ame_age

margins(model1, variables="age")


# Complexity in logit models ----------------------------------------------

# lets try some nested models
model1 <- glm(survival~age+sex, data=titanic, family=binomial)
model2 <- glm(survival~age+sex+pclass, data=titanic, family=binomial)
model3 <- glm(survival~age+sex*pclass, data=titanic, family=binomial)
models <- list(model1, model2, model3)

# what should happen to the sex variable once we control for passenger class?
round(prop.table(table(titanic$sex, titanic$pclass), 2), 3)*100

# women were more likely to be in higher passenger classes than men, so we
# expect that this should account for some of their advantage and the gender
# effect should be smaller once we control for pclass.

screenreg(models)

# clearly that did not happen. WTF? Lets look at the AMEs.

screenreg(lapply(models, margins))

# The AMEs operate as expected but the log-odds ratios do not.
# The reason is that the logit model is non-linear, so controls don't always
# have the expected effect.

# Notice that our interaction terms went away in the margins. They are "priced" 
# into the models. To figure out how passenger class affects men and women 
# differently we need to use the at argument.
margins(model3, variable="sex", at=list(pclass=c("First","Second","Third")))

# Notice the AMEs suggest a bigger first-second class difference than the 
# log-odds ratios. Why is this?
marg(model3, var_interest="sex", at=list(pclass=c("First","Second","Third")),
     type="levels")

# first class is hitting a ceiling effect for women - almost all survived. This
# is missed by the AME


# Marginal effects in other cases -----------------------------------------

## polynomial terms ##
model <- lm(wages~age+I(age^2), data=earnings)
summary(margins(model))
coef(model)

# remember that the marginal effect is b1+2*b2*age
b <- coef(model)
marginal_effects <- b[2]+2*b[3]*earnings$age
mean(marginal_effects)

## interactions in OLS models ##
model <- lm(wages~nchild*gender, data=earnings)
summary(margins(model))

summary(margins(model, variable="nchild", at=list(gender=c("Female","Male"))))
summary(margins(model, variable="gender", at=list(nchild=0:5)))




