# This file is comprehensive, dividing populations by racial statistics into
# those that categorize themselves as being in 1, 2, 3, 4, or 5 races for each
# state. The rows are the individual sub-categories within each broad category
# (i.e. within those that say they're one race, 'white','black','hispanic' and
# so on, within those that say they're two, 'white and black or African
# America', and so on). Might be interesting later on, but not so useful now.

# parsing the 2020 data from https://data.census.gov/cedsci/table?q=population%202020
library(tidyverse)
library(ggplot2)
file="./US/DECENNIALPL2020.P1-2021-12-09T152828-fromExcel.csv"
usPop2020=read_csv(file)
# when I read this file, I get the following message
# > file=".//DECENNIALPL2020.P1-2021-12-09T152828-fromExcel.csv"
# > usPop2020=read_csv(file)
# Rows: 71 Columns: 53                                                                                            # 
# ── Column specification ───────────────────────────────────────────────────────────────────────────────────
# Delimiter: ","
# chr (1): Label (Grouping)

# don't know exactly what that means, but to fix it, the following
# https://readr.tidyverse.org/reference/spec.html suggests using the
# tidyr::cols_condense() I'm not going to do that right now, since I only need
# the totals and I can get those another way.

usPop2020tot=usPop2020[1,]
states=colnames(usPop2020tot)
states=states[2:length(states)]
save(usPop2020tot, states,file = "usPop2020Tot.RData")