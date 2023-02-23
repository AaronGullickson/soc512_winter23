# Aaron Gullickson
# Soc 512, Winter 2023
# Reshaping and Merging Data


# Load libraries ----------------------------------------------------------

library(tidyverse)


# Load and reshape data ------------------------------------------------------

load("output/ipums.RData")

worldbank <- read_csv("input/worldbank.csv", na=c(".."), 
                      n_max=651) |>
  rename(country_name_wb=`Country Name`, country_code=`Country Code`,
         series_code=`Series Code`, y2019=`2019 [YR2019]`) |>
  select(country_name_wb, country_code, series_code, y2019) |>
  pivot_wider(id_cols=c(country_name_wb, country_code),
              names_from=series_code, values_from=y2019) |>
  rename(life_exp=SP.DYN.LE00.IN, gdp_cap=NY.GDP.PCAP.KD,
         co2_cap=EN.ATM.CO2E.PC)

vdem <- read_csv("input/vdem/V-Dem-CY-Core-v12.csv.gz") |>
  filter(year==2019) |>
  select(country_name, country_text_id, v2x_libdem) |>
  rename(country_name_vdem=country_name, country_code=country_text_id)


# Aggregate and reshape ---------------------------------------------------

ipums_agg <- ipums |>
  group_by(statefip, gender) |>
  summarize(mean_agemarr=mean(agemarr, na.rm=TRUE),
            pct_c=100*mean(education=="C")) |>
  pivot_wider(id_cols=statefip, names_from=gender, 
              values_from=c(mean_agemarr, pct_c)) |>
  mutate(pct_c_prop_diff=pct_c_Female-pct_c_Male) |>
  select(statefip, pct_c_prop_diff, pct_c_Female, pct_c_Male)

# Lets merge --------------------------------------------------------------

temp <- full_join(worldbank, vdem)

combined <- left_join(worldbank, vdem) |>
  rename(country_name=country_name_wb, ldem_score=v2x_libdem) |>
  select(country_name, country_code, life_exp, gdp_cap, co2_cap, 
         ldem_score)

ggplot(combined, aes(x=ldem_score, y=co2_cap))+
  geom_point()+
  geom_smooth()+
  theme_bw()

