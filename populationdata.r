## Data from https://data.census.gov/cedsci/table?q=United%20States&g=0100000US%240400000&d=PEP%20Population%20Estimates&tid=PEPPOP2019.PEPANNRES
## definitions of geographica terms: https://www.census.gov/programs-surveys/popest/guidance-geographies/terms-and-definitions.html
## Release note for population estimates:
## https://www2.census.gov/programs-surveys/popest/technical-documentation/methodology/2010-2020/v2020-est-relnotes.pdf
## Methodology:
## https://www2.census.gov/programs-surveys/popest/technical-documentation/methodology/2010-2020/methods-statement#-v2020-final.pdf

## In particular, the last mentioned says ...
##
##
## Base Population
##
## The enumerated resident population from the 2010 Census is the
## starting point for all post-2010 population estimates. We modify
## this enumerated population in three ways to produce the April 1,
## 2010 population estimates base.


## Read/Manipulate the population data. If you run into problems using 'filter',
## it's probably because you haven't loaded tidyverse
##
library(tidyverse)
library(tidyr) # to convert 1 column tibble to a list

dir="./PEPPOP2019"
popfiles=list.files(path='./US/PEPPOP2019/',pattern="\\.csv$",full.name=TRUE)
usPopulation=read_csv(popfiles[1])
head(usPopulation)
# Because this CSV file uses the column name `NAME`, which seems to cause
# problems (e.g. al=select(usPopulation,NAME=='Alabama')) yeilds a "object
# 'NAME' not found" error), I'm going to see if I can create a new column with a
# different name and select on that.

usPop <- mutate(usPopulation,state=NAME)
usPop$state=as.factor(usPop$state)

# also, because the first row is a set of column headings, and those will get in
# the way, I'll remove that row here

usPop=usPop[2:nrow(usPop),]
# Now we have to deal with the stupidity of the `DATE_CODE` column, which looks like this

# # A tibble: 637 × 1
# DATE_CODE                         
# <chr>                             
#   1 Estimate Date                     
# 2 4/1/2010 Census population        
# 3 4/1/2010 population estimates base
# 4 7/1/2010 population estimate      
# 5 7/1/2011 population estimate      
# 6 7/1/2012 population estimate      
# 7 7/1/2013 population estimate      
# 8 7/1/2014 population estimate      
# 9 7/1/2015 population estimate      
# 10 7/1/2016 population estimate      
# # … with 627 more rows

# Still a tibble. 
# It's best if it's a list
dc=as.list(usPop$DATE_CODE)


# regexpr is a pain in the ass to use!

# Here's an example! This will explicitly match the date part of the string, not
# the bit after the date, leaving that in the last sub-expression (e.g.
# `the-rest`, in emacs-lisp speak)

re="(\\d{1,2})/(\\d{1,2})/(\\d{4}) (.*)"
dates=list()
descrip=list()

for (f in 1:length(dc)){
  print(dc[f])
  foo<-regexpr(re,dc[f],perl=TRUE)
  
  # foo is like 'match_data' in emacs. And you have to pull stuff out using
  # attributes.
  
  start=attr(foo,'capture.start')
  end=start+attr(foo,'capture.length')-1
  month <- sprintf("%02d",as.numeric(substr(dc[f],start[1],end[1])))
  day <- sprintf("%02d",as.numeric(substr(dc[f],start[2],end[2])))
  year <- sprintf("%02d",as.numeric(substr(dc[f],start[3],end[3])))
  # Having removed the first row, we can now use R's date format
  theRest <- substr(dc[f],start[4],end[4])
  dstr=sprintf("%s-%s-%s",year,month,day)
  if (f == 1){
    dates=c(as.Date(dstr))
    descrip=c(theRest)
  } else {
    dates=c(dates,as.Date(dstr))
    descrip=c(descrip,theRest)
  }
}
usPop <- mutate(usPop,dates=dates,descrip=as.factor(descrip))
head(usPop)

# Select the rows that have a description of 'population estimates base'
base=filter(usPop,descrip=='population estimates base')
#save(usPop,file='usPop-2010-2019.RData')nro



