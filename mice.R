# Missing Value Imputation

library(mice)
load("example_data/addhealth.RData")

apply(is.na(addhealth), 2, sum)

imputed <- mice(addhealth[,c("grade","race","gender",
                  "nominations","alcohol_use",
                  "smoker","pseudo_gpa","honor_society",
                  "bandchoir","nsports","parent_income")],
                3)

summary(complete(imputed, 1)$parent_income)
summary(complete(imputed, 2)$parent_income)
summary(complete(imputed, 3)$parent_income)
