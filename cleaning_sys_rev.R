######################################
# Code author: Erin Stearns
# Code objective: Clean and prepare systematic review data for join to GAHI data
# Date: 3.13.17
#####################################

rm(list = ls())

# set up environment -------------------------------------------

pacman::p_load(fields, tidyverse, data.table, magrittr, stringr, reshape2, ggplot2, readbulk, dplyr, Amelia, plyr)
setwd('C:/Users/stearns7/OneDrive - UW Office 365/ntds/LF/code/cleaning')
cleaning_dir <- ('C:/Users/stearns7/OneDrive - UW Office 365/ntds/LF/data/cleaning')

# load data ----------------------------------------------------------------------------------

sr <- fread(file = 'C:/Users/stearns7/OneDrive - UW Office 365/ntds/LF/data/raw_data/sys_rev_13_03_2017.csv', stringsAsFactors = F)

# identifying important columns

sr_cols <- names(sr)

# parsing out country from ihme loc code

sr$iso3 <- substr(sr$ihme_loc_id, 1, 3) #take first 3 characters of each value in ihme_loc_id
unique(nchar(sr$iso3))

sr[(nchar(sr$iso3) == 0), iso3:='PYF'] #French Polynesia did not have an ihme_loc_id

weird_null <- sr[iso3 == "#N/",] # non-gbd geograhies, will recode after iso join

#reading in iso key
iso_key <- fread(file = 'C:/Users/stearns7/OneDrive - UW Office 365/ntds/LF/data/spatial_data/iso_key.csv', stringsAsFactors = F)
iso <- as.data.table(iso_key[,c('country', 'iso3')])

#join to main to get a 'country' col
sr_wcountry <- as.data.table(left_join(sr, iso, by = "iso3"))

#now need to deal with non-GBD rows
sr_wcountry[is.na(sr_wcountry$country), country:="location_name_2"] #for non-gbd countries, name is here

write.csv(sr_wcountry, file = 'C:/Users/stearns7/OneDrive - UW Office 365/ntds/LF/data/processed_data/syst_rev/sr_wcountry_3.14.csv')
