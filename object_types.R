# Aaron Gullickson
# Soc 512

library(tidyverse)

# Atomic Types ------------------------------------------------------------

# numeric
a <- 3
class(a)
mode(a)

# character string
b <- "bob"

# logical
c <- FALSE

#re-cast
d <- "3"
as.numeric(d)

as.character(a)

as.numeric(c)

# Vectors and Matrices ----------------------------------------------------

age <- c(15, 25, 47, 89, 13)
name <- c("bob","maria","jim","sarah","tim")
x <- c(15, 6, "hot dogs")
ate_breakfast <- c(TRUE, FALSE, FALSE, TRUE, FALSE)

# pulling out a specific value in a vector
age[3]
age[c(1,4,5)]
age[2:4]

x <- matrix(c(3,1,2,5,6,9), c(3,2))
# index second row, first column
x[2,1]
x[c(1,2),1]
x[,1]

y <- cbind(a=c(3,1,2), b=c(5,6,9))
#index by name
y[2,"b"]

cbind(name, age, ate_breakfast)

# Missing Values ----------------------------------------------------------
age[4] <- NA
mean(age, na.rm=TRUE)
is.na(age)
na.omit(age)
mean(na.omit(age))

sum(is.na(age))

# Boolean (True/False) Statements -----------------------------------------

# is age greater or equal to 18
age >= 18

# > greater than
# < less than
# >= greater than or equal
# <= less than or equal
# == exactly equal
# != not equal to
age == 25
name == "maria"
name != "maria"
# which values are **not** missing
!is.na(age)
!ate_breakfast

# compound boolean statements
# and
age > 18 & name=="maria"
# or
age > 18 | name=="maria"

# remove the intersection!
(age > 18 | name=="maria") & !(age > 18 & name=="maria")
# these are different!
#(x | y) & z
#x | (y & z)

# Factors -----------------------------------------------------------------

gender <- c("Male","Female","Male","Female","Male")
gender_fctr <- factor(gender,
                      levels = c("Male","Female"),
                      labels = c("man","woman"))

gender_num <- c(2,1,2,1,2)
gender_fctr <- factor(gender_num,
                      levels=c(1,2),
                      labels=c("Female","Male"))

# Lists -------------------------------------------------------------------

my_list <- list(a, age, ate_breakfast, b, gender, gender_fctr, name, x)
my_list[[3]]

# could we use this for a dataset
my_data <- list(name=name, age=age, bkfst=ate_breakfast, gender=gender)
my_data$age

# Data Frames and Tibbles -------------------------------------------------

my_df <- data.frame(name=name, age=age, bkfst=ate_breakfast, gender=gender)

# access a variable
my_df$age

# recognizes commands
summary(my_df)

# it also can be indexed like a matrix
my_df[1,3]
my_df[,3]
my_df[1,"bkfst"]
my_df[,"bkfst"]

#subsetting

#subset rows
my_df[!is.na(my_df$age) & my_df$age>18,]
subset(my_df, age>18)

#subset columns and rows
my_df[!is.na(my_df$age) & my_df$age>18,c("age","bkfst","gender")]
subset(my_df, age>18, select = c("age","bkfst","gender"))


# Tibbles! ----------------------------------------------------------------

my_tibble <- tibble(my_df)

