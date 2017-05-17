###################################################

#OECD DAC1 Data

#This script pulls multiple years of DAC1 data from the OECD and
#structures it into a denormalised table for analysis.
#It also outputs a version for use in a Tableau dashboard.

#V1 13-Mar-2017  K Vang

###################################################



#Load Packages
library(tidyverse)
library(OECD)

#Set working directory
setwd("H:/OECD_data/DATA_Report_2017")


#Get structure of DAC 1 and copy some dimensions tables to help denormalise that main table later
dac1.struct <- get_data_structure("TABLE1")

dac1.struct$VAR_DESC

dac1.flows <- dac1.struct$FLOWS
names(dac1.flows) <- c("FLOWS", "Fund_flows")

dac1.data_type <- dac1.struct$DATATYPE
names(dac1.data_type) <- c("DATATYPE", "Data_type")


###Pull the data and save it locally
##Take 2 years at a time via API
#dac1.1415 <- get_dataset("TABLE1", start_time = 2014)
#dac1.1213 <- get_dataset("TABLE1", start_time = 2012, end_time = 2013)
#dac1.1011 <- get_dataset("TABLE1", start_time = 2010, end_time = 2011)
#dac1.0709 <- get_dataset("TABLE1", start_time = 2007, end_time = 2009)

#Then combine the rows to make one dataset
# dac1 <- dac1.1415 %>%
#   bind_rows(dac1.1213) %>%
#   bind_rows(dac1.1011) %>% 
#   bind_rows(dac1.0709)
# 
# rm(dac1.1011, dac1.1213, dac1.1415, dac1.0709)

#Add a column that shows when the data was pulled
#dac1$as_of_date <- Sys.Date()

#Write a copy for local safekeeping
#write.csv(dac1, "../source_data/dac1_2007_2016_20170515.csv", row.names = FALSE)



#If the data has already been pulled, start by reading the locally stored data
dac1 <- read.csv("../source_data/dac1_2007_2016_20170515.csv", stringsAsFactors = FALSE)

#Read in the table of transaction type dimensions
dac1.aidtype_short <- read.csv("dimensions/dac1_transactype_map.csv", stringsAsFactors = FALSE)

#Read in the table of donor dimensions
dac1.donors <- read.csv("dimensions/dac1_donors_map.csv", stringsAsFactors = FALSE)

#convert the dimension table ids into integers to the ids are the same type in all tables
dac1.flows$FLOWS <- as.integer(dac1.flows$FLOWS)


#Denormalise tables by joining in dimension descriptions, and write the results to .csv
dac1 <- dac1 %>%
  left_join(dac1.donors, by = "DAC_DONOR") %>% 
  left_join(dac1.aidtype_short, by = "TRANSACTYPE") %>% 
  left_join(dac1.flows, by = "FLOWS") %>% 
  left_join(dac1.data_type, by = "DATATYPE")

rm(dac1.donors, dac1.flows, dac1.data_type, dac1.aidtype_short)


write.csv(dac1, "../source_data/dac1_2007_2016_20170515_denorm.csv", row.names = FALSE)