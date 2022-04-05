# Looking at USDA-ERS-PopulationEstimates.csv
#
# This table involves the user of 'contimuum codes' which classify the
# rural/urban nature of each county. for these, see
# https://www.ers.usda.gov/topics/rural-economy-population/rural-classifications/

library(tidyverse)
library(ggplot2)
file="./US/USDA-ERS-PopulationEstimates.csv"
usda_ers_estimates<-read_csv(file)


# # A tibble: 6 × 6
# FIPStxt State `Area name`   `Rural-urban continuum code 2013` Attribute           Value
# <dbl> <chr> <chr>                                     <dbl> <chr>               <dbl>
#   1       0 US    United States                                NA Population 1990 248790925
# 2       0 US    United States                                NA Population 2000 281424600
# 3       0 US    United States                                NA Population 2010 308745538
# 4       0 US    United States                                NA Population 2020 331449281
# 5    1000 AL    Alabama                                      NA Population 1990   4040389
# 6    1000 AL    Alabama                                      NA Population 2000   4447207

# How do they come up with this stupid fucking formats?


usda_ers_estimates <- usda_ers_estimates %>% select(-FIPStxt)
# Save in their own variable the rows that have the total population for the
# U.S.
usTotPopulation<-usda_ers_estimates[1:4,]
# And drop them from the tibble
usda_ers_estimates <- usda_ers_estimates[-c(1:4),]
head(usda_ers_estimates)

# Change column names to something more useable
colnames(usda_ers_estimates)<-c('state','area','rucc','year','population')

# Delete 'county' and 'municipo' (from Puerto Rico) from the 'area' column
usda_ers_estimates$area<-str_replace(usda_ers_estimates$area,' County','')
usda_ers_estimates$area<-str_replace(usda_ers_estimates$area,' Municipio','')
head(usda_ers_estimates)

#  Rewrite the 'year' (old called the 'Attribute') to drop the string
# 'Population' (convert to numeric?)

usda_ers_estimates$year<-str_replace(usda_ers_estimates$year,'Population ','')
head(usda_ers_estimates)

# gather the state totals
stateTotals=usda_ers_estimates[is.na(usda_ers_estimates$rucc),]
head(stateTotals)

# Drop them from the main table
# using this template mc %>% replace(. == "NA", NA) %>% na.omit
usda_ers_estimates <- usda_ers_estimates %>% replace(. == "NA", NA) %>% na.omit

# Let's have a look at Alabama for 1990 
al=usda_ers_estimates %>% filter(state=='AL' & year=='1990')

