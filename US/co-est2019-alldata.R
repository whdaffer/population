# Downloaded (use Chrome) from 
# https://www.census.gov/data/datasets/time-series/demo/popest/2010s-counties-total.html#par_textimage_70769902
# I'd love to know where the 2020 file is.
library(tidyverse)
library(ggplot2)
file="./US/co-est2019-alldata.csv"
usPopByCounty2019<-read_csv(file,show_col_types = FALSE)
head(usPopByCounty2019)
colnames(usPopByCounty2019)
usPopByCounty2019<-usPopByCounty2019 %>% select(STNAME,CTYNAME,POPESTIMATE2019)
colnames(usPopByCounty2019)<-c('state','county','pop2019')
