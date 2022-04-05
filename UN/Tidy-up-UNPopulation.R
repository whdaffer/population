# Process the UN population dataset of population for world regions and individual countries. It's badly arranges and needs *lots* of rearrangement. Probably not really that useful, but good as an exercise.
#
# http://data.un.org/_Docs/SYB/CSV/SYB64_1_202110_Population,%20Surface%20Area%20and%20Density.csv
library(tidyverse)
library(tidyr)
library(ggplot2)
files=list.files(pattern='csv$')
print(files)
population=read_csv(files[1])
head(population)

# Of all the files I"ve ever seen, this must be among the worst! The column headings are...
# colnames(population)
# [1] "T02"                                  "Population, density and surface area" "...3"                                
# [4] "...4"                                 "...5"                                 "...6"                                
# [7] "...7"
# Row 1 gives some proper column names, except for column 2
# population[[2]]
# for (i in 1:length(colnames(population))){print(population[[1,i]])}
# [1] "Region/Country/Area"
# [1] NA  <- either the aread name (e.g. Africa, Sub-Saharan Africa, and so on) or the string 'Total, all countries or areas'
# [1] "Year"
# [1] "Series" <- a string representing what the data represents. Could be one of
#       a) Population mid-year estimates (millions)
#       b) Population mid-year estimates for males (millions)
#       c) Population mid-year estimates for females (millions)
#       d) Sex ratio (males per 100 females)
#       e) Population aged 0 to 14 years old (percentage)
#       f) Population aged 60+ years old (percentage)
#       g) Population density (in numbers/km2)
#       h) Surface Area (km2) (not for the regions marked as 'All Areas or countries')
# [1] "Value" <- the value for that particular series
# [1] "Footnotes" <- not useful. Drop
# [1] "Source" <- not useful: Drop
# > 



# So, to clean it up, we'll do the following 
#
# 1) Drop "Region/Country/Area, Footnotes and 'Source'
#
# 2) name the columns based on the values in row 1, replacing the NA at [1,1]
# with 'AreaName'
#
# 3) Strip out the individual series into their own observations for each
# country/region
#

# According to R for Data Science, Chap 9, page 154, this is an example of
# 'spreading', where you have an observation spread over multiple rows. So, for
# 'Africa', for 2010, you need 10 rows, rather than 1 row and 10 columns. First
# we'll just rearrange the tibble so that the `Series` is spread out over the
# columns, then we'll rename them as follows..

pop<-population # save the original

# Drop T02, ...5 and ...6
pop2 <- pop %>% select( -c("T02","...6","...7"))
colnames(pop2)
head(pop2)

# Rename columns
colnames(pop2) <- c("AreaName","Year","Series","Value")
colnames(pop2)

# delete redundant 1st row
pop3 <- pop2[-c(1),]

# `Spread` (page 155) the series names out into their own column, using the ole
# Series names.
pop4 <- spread(pop3,key=Series,value=Value)

# Rename the colums into something a bit more useful.
cnames=colnames(pop4)
cnames
# Which gives us....

# [1] "AreaName"                                             "Year"                                                
# [3] "Population aged 0 to 14 years old (percentage)"       "Population aged 60+ years old (percentage)"          
# [5] "Population density"                                   "Population mid-year estimates (millions)"            
# [7] "Population mid-year estimates for females (millions)" "Population mid-year estimates for males (millions)"  
# [9] "Sex ratio (males per 100 females)"                    "Surface area (thousand km2)"       

newcnames=c('AreaName','Year','Pop-0-14','Pop>65','Density','Population','Female','Male','SexRatio','SurfaceArea')

colnames(pop4) <- newcnames

pop<-pop4
rm(pop2,pop3,pop4)

# All the columns are character data. Convert Year to integer and the rest to doubles
# See https://dplyr.tidyverse.org/reference/across.html

# See: https://readr.tidyverse.org/reference/type_convert.html
pop<-type_convert(pop)
# This magically converts all the numeric data to doubles. But I'd like to have `Year` as an integer
pop<- pop %>% mutate(across(Year, as.integer))

# Select some columns and year=2010
popAfgh<-select(pop,AreaName,Year,Male) %>% filter(AreaName=='Afghanistan')
# plot
ggplot(popAfgh,aes(x=Year,y=Male)) + geom_point()
us<-select(pop,areaName,Year,Male) %>% filter(AreaName=='United States of America')

write_csv(pop,'UN_SYB64_1_202110_Population-SurfaceAreaAndDensity-tidy.csv')


                                        
