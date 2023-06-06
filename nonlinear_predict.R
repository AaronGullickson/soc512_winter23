# polynomials, splines, and predict
# Soc 413/513
# April 27, 2023

library(tidyverse)
load("example_data/earnings.RData")

# create the spline!
earnings <- earnings |>
  mutate(age_spline=ifelse(age<35, 0, age-35))

model_log <- lm(wages~log(age), data=earnings)
model_poly <- lm(wages~age+I(age^2), data=earnings)
model_spline <- lm(wages~age+age_spline, data=earnings)

pred_df <- tibble(age=18:65) |>
  mutate(age_spline=ifelse(age<35, 0, age-35))

pred_df$wages_log <- predict(model_log, newdata=pred_df)
pred_df$wages_poly <- predict(model_poly, newdata=pred_df)
pred_df$wages_spline <- predict(model_spline, newdata=pred_df)

ggplot(earnings, aes(x=age, y=wages))+
  geom_jitter(alpha=0.01)+
  geom_line(data=pred_df, aes(y=wages_log), color="blue", 
            linewidth=1.5)+
  geom_line(data=pred_df, aes(y=wages_poly), color="red", 
            linewidth=1.5)+
  geom_line(data=pred_df, aes(y=wages_spline), color="purple", 
            linewidth=1.5)+
  theme_bw()
