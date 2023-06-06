library(tidyverse)

load("example_data/movies.RData")

model_orig <- lm(BoxOffice~Rating, data=movies)
fake_data <- tibble(Rating=c("G","PG","PG-13","R"))
predict(model_orig, newdata = fake_data)
tapply(movies$BoxOffice, movies$Rating, mean)

model_log <- lm(log(BoxOffice)~Rating, data=movies)
exp(predict(model_log, newdata = fake_data))
tapply(movies$BoxOffice, movies$Rating, mean)

tapply(log(movies$BoxOffice), movies$Rating, mean)
predict(model_log, newdata = fake_data)

model_poisson <- glm(BoxOffice~Rating, family=quasipoisson, data=movies)
exp(predict(model_poisson, newdata = fake_data))
tapply(movies$BoxOffice, movies$Rating, mean)
