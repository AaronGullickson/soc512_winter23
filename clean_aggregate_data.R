# Lets Clean Some Data!

# Load Libraries ----------------------------------------------------------

library(tidyverse)

# Read the data -----------------------------------------------------------

ipums <- read_fwf("input/ipums/usa_00084.dat.gz",
                  col_positions = 
                    fwf_positions(start = c(1,32,55,74,84,85,88,94),
                                  end =   c(4,41,56,83,84,87,91,96),
                                  col_names=c("year","hhwt","statefip","perwt",
                                              "sex","age","yrmarr","educd")),
                  progress=TRUE,
                  col_types = cols(.default = "i"))

# Code year married --------------------------------------------------------

# bracket and boolean approach
ipums$yrmarr[ipums$yrmarr==0] <- NA
#ipums[ipums$yrmarr==0, "yrmarr"] <- NA

# ifelse approach
ipums$yrmarr <- ifelse(ipums$yrmarr==0, NA, ipums$yrmarr)

# CHECK YOURSELF BEFORE YOU WRECK YOURSELF
summary(ipums$yrmarr)

# Code gender -------------------------------------------------------------

# simple way
ipums$gender <- factor(ipums$sex, levels=c(2,1), 
                       labels=c("Female","Male"))

# CHECK YOURSELF BEFORE YOU WRECK YOURSELF
table(ipums$sex, ipums$gender, exclude=NULL)

# Education example -------------------------------------------------------

# nested ifelse approach, watch your parenthesis
ipums$education <- factor(ifelse(ipums$educd<2 | ipums$educd==999, NA, 
                                 ifelse(ipums$educd<62, "LHS", 
                                        ifelse(ipums$educd<70, "HS",
                                               ifelse(ipums$educd<101, "SC", "C")))),
                          levels=c("LHS","HS","SC","C"))

# case_when
ipums$education <- factor(case_when(
  ipums$educd<2 | ipums$educd==999 ~ NA_character_, 
  ipums$educd<62 ~ "LHS",
  ipums$educd<70 ~ "HS",
  ipums$educd<101 ~ "SC",
  ipums$educd<999 ~ "C"),
  levels=c("LHS","HS","SC","C"))

summary(ipums$education)

table(ipums$educd, ipums$education, exclude=NULL)

# Tidy dataset ------------------------------------------------------------

ipums <- ipums |>
  mutate(
    yrmarr=ifelse(yrmarr==0, NA, yrmarr),
    gender=factor(sex, levels=c(2,1), labels=c("Female","Male")),
    education=factor(
      case_when(educd<2 | educd==999 ~ NA_character_, 
                educd<62 ~ "LHS",
                educd<70 ~ "HS",
                educd<101 ~ "SC",
                educd<999 ~ "C"),
      levels=c("LHS","HS","SC","C")),
    agemarr=year-yrmarr,
  ) |>
  filter(age>=18)

# DO YOUR CHECKS

ipums <- ipums |>
   select(statefip, agemarr, gender, education)


# Aggregate data ----------------------------------------------------------


