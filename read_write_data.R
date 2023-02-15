# Read/Write Data


# Load libraries ----------------------------------------------------------

library(haven)
library(readxl)
library(readr)
library(tidyverse)

# Read binary files -------------------------------------------------------

# lets load https://www.pewresearch.org/religion/dataset/the-worlds-muslims/
pew <- read_sav("input/pew_worlds_muslims/2012-Pew-Religion-Worlds-Muslims_dataset.sav")

# Read FWF file -----------------------------------------------------------
ipums <- read_fwf("input/ipums/usa_00116.dat.gz",
                  na=c(" ","."),
                  col_positions = fwf_positions(start=c(1,94,97),
                                                end  =c(4,96,97),
                                                col_names=c("year","age","race")),
                  #col_types = cols(age = "i"))
                  col_types = cols(.default="i"))

#read_csv("output/ipums.csv", na=c(" ","."))

# Saving data -------------------------------------------------------------

write_csv(ipums, file="output/ipums.csv")
#write_sav()
#write_dta()

save(ipums, file="output/ipums.RData")
load("output/ipums.RData")


# Reading social explorer data --------------------------------------------

tracts <- read_csv("input/R13298932_SL140.csv", skip=1,
                   col_types = cols(Geo_STATE = "i", Geo_COUNTY = "i"))

# SE_A00001_001 - total pop
# SE_A02002_002 - total pop, male
# SE_A02002_015 - total pop, female

# base R approach
# subset command to get rid of variables
tracts <- subset(tracts, select=c("Geo_STATE","Geo_COUNTY","SE_A00001_001",
                                  "SE_A02002_002","SE_A02002_015"))

# colnames to rename variables
colnames(tracts) <- c("state","county","pop_total","pop_male","pop_female")
#colnames(tracts)[3] <- "total_pop"

# tidyverse
tracts <- tracts |>
  select(Geo_STATE, Geo_COUNTY, SE_A00001_001, SE_A02002_002, SE_A02002_015) |>
  rename(county=Geo_COUNTY, pop_total=SE_A00001_001, state=Geo_STATE,
         pop_male=SE_A02002_002, pop_female=SE_A02002_015)

