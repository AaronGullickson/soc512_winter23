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


# Code gender -------------------------------------------------------------


# Education example -------------------------------------------------------


# Tidy dataset ------------------------------------------------------------


# Aggregate data ----------------------------------------------------------

