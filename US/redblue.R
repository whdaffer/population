

pvifile="./PVIdata.csv"
pvifile="PVIdata.csv"
pvi=read_csv(pvifile,show_col_types=F)

# define red, blue and purple states using the data from
# https://worldpopulationreview.com/state-rankings/red-states. This uses the
# Cook Partisan Index (https://en.wikipedia.org/wiki/Cook_Partisan_Voting_Index)
# stored in a variable in the following .csv file named PVI. As explained on
# that page..


# is a measurement of how strongly a United States congressional district or
# states leans toward the Democratic or Republican Party compared to the
# national average. For example, if the national average is 48% Republican, and
# the Republican candidate of a state win 57% of the two-party share, then that
# state voted nine percentage points more Republican than the country. The PVI
# for that state is R+9.

red <- pvi %>% filter(pvi > 2)
blue=pvi %>% filter(pvi < -1)
purple <- pvi %>% filter (pvi >= -1 && pvi <= 2)

## 538's 'partisan lean' measure

dir='/Users/whd/Dropbox/R/538-data/data-master/partisan-lean'
districtFile=paste(dir,'fivethirtyeight_partisan_lean_DISTRICTS.csv',sep='/')
stateFile=paste(dir,'fivethirtyeight_partisan_lean_STATES.csv',sep='/')

d_pl_538 <- read_csv(districtFile)
s_pl_538 <- read_csv(stateFile)
