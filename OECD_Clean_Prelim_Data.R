###################################################

#OECD 2015 Preliminary Data

#This script reads the OECD Excel doc of preliminary DAC data and
#Shapes it into a format that can be incorporated into the other DAC data

#V1 5-Apr-2017  K Vang

###################################################

#Load Packages
library(tidyverse)
library(readxl)
library(OECD)

#Hard-code the year of the preliminary data
year <- 2017
as_of <- "2018-04-09"


#Read the preliminary file from the OECD, skipping the first 3 rows
prelim <- read_excel('../source_data/ADV2017.xls', skip=3, trim_ws = FALSE)

#Remove the first column with sort order numbers
prelim$SortOrder <- NULL

#Remove any rows with all NA
prelim <- prelim[rowSums(is.na(prelim)) != ncol(prelim),]

#Make the results long, with donor countries in rows and not across columns
prelim <- gather(prelim, Donor, obsValue, -NameE)


#Read in the table of mappings for the field names
prelim.fields <- read.csv('dimensions/prelim_transactype_map.csv', stringsAsFactors = FALSE)

#Read in the table of donor dimensions (same table as for DAC1)
prelim.donors <- read.csv("dimensions/dac1_donors_map.csv", stringsAsFactors = FALSE)

#join on all the detailed fields as well as the year of the data
prelim <- prelim %>% 
  left_join(prelim.fields, by='NameE') %>% 
  left_join(prelim.donors, by='Donor') %>% 
  mutate(obsTime = year, as_of_date = as_of)



#Write a copy of the data for use elsewhere
write.csv(prelim, "../source_data/prelim_2017_denorm.csv", row.names = FALSE)
