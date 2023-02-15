# Pretty Pictures
# Soc 412/512, Winter 2023
# Aaron Gullickson


# Load data and libraries -------------------------------------------------

library(ggplot2)
library(scales)
library(wesanderson)
library(LaCroixColoR)

load("example_data/nyc.RData")


# Make a Picture ----------------------------------------------------------

ggplot(nyc, aes(x=poverty/100, y=amtcapita))+
  geom_point(aes(color=borough, size=popn), alpha=0.7)+
  geom_smooth(method="lm", se=FALSE, color="grey20")+
  scale_y_log10(labels=dollar,
                breaks=c(1,10,100,1000,10000))+
  scale_x_continuous(labels=percent)+
  #scale_color_brewer(palette="Dark2")+
  #scale_color_viridis_d()+
  scale_color_manual(values=lacroix_palette("PassionFruit", type = "discrete"))+
  #scale_color_manual(values=wes_palette("FantasticFox1"))+
  labs(x="poverty rate", y="amount of funding per capita",
       title="Social service funding to NYC health area by poverty rate",
       caption="NYC data, 2009-2010", color="Borough", 
       size="Population size")+
  theme_bw()+
  theme(legend.position = "right")

# ggplot(nyc, aes(x=poverty/100, y=amtcapita))+
#   geom_point(alpha=0.7, aes(color=borough, size=popn))+
#   scale_x_continuous(label=percent)+
#   geom_smooth(method="lm", color="black", se=FALSE)+
#   scale_y_log10(labels=dollar)+
#   scale_color_brewer(palette="Dark2")+
#   theme_bw()+
#   theme(legend.position="right")+
#   labs(x="poverty rate",
#        y="amount per capita",
#        title="Non-profit funding to NYC health area by poverty rate",
#        caption="Data from NYC, 2009-2010",
#        color="Borough",
#        size="Population")

# fun libraries for theming and color

# game of thrones colors
# https://github.com/aljrico/gameofthrones

# PNW colors
# https://github.com/jakelawlor/PNWColors

# ggsci colors
# https://cran.r-project.org/web/packages/ggsci/vignettes/ggsci.html

# LaCroix colors
# https://github.com/johannesbjork/LaCroixColoR

# Wes Anderson colors
# https://github.com/karthik/wesanderson

# hbhr themes
# https://github.com/hrbrmstr/hrbrthemes

# ggthemes
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/