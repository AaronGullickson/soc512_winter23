load("example_data/earnings.RData")
load("example_data/movies.RData")
library(texreg)
library(ggplot2)

model1 <- lm(wages~nchild*gender, data=earnings)

model_men <- lm(wages~nchild, 
                data=subset(earnings, gender=="Male"))

model_women <- lm(wages~nchild, 
                  data=subset(earnings, gender=="Female"))

screenreg(list(model1, model_men, model_women))


model2 <- lm(wages~nchild*gender+I(age-mean(age)), data=earnings)

model_men <- lm(wages~nchild+I(age-mean(age)), 
                data=subset(earnings, gender=="Male"))

model_women <- lm(wages~nchild+I(age-mean(age)), 
                  data=subset(earnings, gender=="Female"))

screenreg(list(model2, model_men, model_women))

model3 <- lm(wages~(nchild+I(age-mean(age)))*gender, data=earnings)

screenreg(list(model3, model_men, model_women))

# more than two categories
ggplot(movies, aes(x=Runtime, y=BoxOffice, color=Rating))+
  geom_point(alpha=0.2)+
  geom_smooth(method="lm", se=FALSE)+
  theme_bw()+
  labs(x="runtime in minutes", y="box office returns in millions USD")

model <- lm(BoxOffice~I(Runtime-mean(Runtime))*Rating, data=movies)


# two quantitative case

model <- lm(BoxOffice~Runtime*TomatoMeter, data=movies)


