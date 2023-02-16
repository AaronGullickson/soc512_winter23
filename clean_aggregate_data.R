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


# Tidy dataset ------------------------------------------------------------


# Aggregate data ----------------------------------------------------------

