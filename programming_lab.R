# Programming Lab


# Load libraries ----------------------------------------------------------

library(tidyverse)

# Load data ---------------------------------------------------------------

tracts <- read_csv("input/tracts_state.csv")

# Work with a test case ---------------------------------------------------

colorado <- tracts |>
  filter(statename=="Colorado")

# entropy at the tract level
colorado <- colorado |>
  mutate(total=white+latino+black+asian+indigenous+other,
         prop_white=white/total, prop_black=black/total,
         prop_latino=latino/total, prop_asian=asian/total,
         prop_indigenous=indigenous/total, prop_other=other/total)

props <- colorado |>
  select(starts_with("prop_")) |>
  as.matrix()

colorado <- colorado |>
  mutate(entropy=apply(props*log(1/props, 6), 1, sum, na.rm=TRUE))

#entropy at the state level
colorado |>
  group_by(statename) |>
  select(white, black, latino, asian, indigenous, other) |>
  summarize_all(sum) |>
  mutate(total_state=white+latino+black+asian+indigenous+other,
         prop_white=white/total_state, prop_black=black/total_state,
         prop_latino=latino/total_state, prop_asian=asian/total_state,
         prop_indigenous=indigenous/total_state, 
         prop_other=other/total_state,
         entropy_state=prop_white*log(1/prop_white, 6)+
           prop_black*log(1/prop_black, 6)+
           prop_latino*log(1/prop_latino, 6)+
           prop_asian*log(1/prop_asian, 6)+
           prop_indigenous*log(1/prop_indigenous, 6)+
           prop_other*log(1/prop_other, 6)) |>
  select(statename, total_state, entropy_state) |>
  right_join(colorado) |>
  select(statename, entropy, total, entropy_state, total_state) |>
  group_by(statename) |>
  summarize(theil_h=1-sum((total/total_state)*(entropy/entropy_state)))


# Create a function -------------------------------------------------------

calculate_theil_h <- function(state_tracts) {
  # entropy at the tract level
  state_tracts <- state_tracts |>
    mutate(total=white+latino+black+asian+indigenous+other,
           prop_white=white/total, prop_black=black/total,
           prop_latino=latino/total, prop_asian=asian/total,
           prop_indigenous=indigenous/total, prop_other=other/total)
  
  props <- state_tracts |>
    select(starts_with("prop_")) |>
    as.matrix()
  
  state_tracts <- state_tracts |>
    mutate(entropy=apply(props*log(1/props, 6), 1, sum, na.rm=TRUE))
  
  #entropy at the state level
  temp <- state_tracts |>
    group_by(statename) |>
    select(white, black, latino, asian, indigenous, other) |>
    summarize_all(sum) |>
    mutate(total_state=white+latino+black+asian+indigenous+other,
           prop_white=white/total_state, prop_black=black/total_state,
           prop_latino=latino/total_state, prop_asian=asian/total_state,
           prop_indigenous=indigenous/total_state, 
           prop_other=other/total_state,
           entropy_state=prop_white*log(1/prop_white, 6)+
             prop_black*log(1/prop_black, 6)+
             prop_latino*log(1/prop_latino, 6)+
             prop_asian*log(1/prop_asian, 6)+
             prop_indigenous*log(1/prop_indigenous, 6)+
             prop_other*log(1/prop_other, 6)) |>
    select(statename, total_state, entropy_state) |>
    right_join(state_tracts) |>
    select(statename, entropy, total, entropy_state, total_state) |>
    group_by(statename) |>
    summarize(theil_h=1-sum((total/total_state)*(entropy/entropy_state)))
  
    return(temp$theil_h)
}

calculate_theil_h(subset(tracts, statename=="Colorado"))
calculate_theil_h(subset(tracts, statename=="Oregon"))

# Iterate over states with a for loop ---------------------------------------------

states <- unique(tracts$statename)

for(i in 1:200) {
  print(i)
}

theil_h <- NULL
for(state in states) {
  theil_h <- c(theil_h, 
               calculate_theil_h(subset(tracts, statename==state)))
}

theil_h_df <- tibble(statename=states, theil_h)

# Iterate by lapply/sapply ------------------------------------------------

lapply(split(tracts, tracts$statename), calculate_theil_h)

temp <- sapply(split(tracts, tracts$statename), calculate_theil_h)

theil_h_df <- enframe(temp, name="statename", value="theil_h")
