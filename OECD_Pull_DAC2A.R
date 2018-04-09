###################################################

#OECD DAC2A Data

#This script pulls multiple years of DAC2A data from the OECD and
#structures it into a denormalised table for analysis

#V1 13-Mar-2017  K Vang

###################################################

#Load Packages
library(tidyverse)
library(OECD)

#Set working directory
#setwd("H:/OECD_data")


#Get structure of DAC 2A and copy some dimensions tables to help denormalise that main table later
dac2a.struct <- get_data_structure("TABLE2A")

dac2a.struct$VAR_DESC

dac2a.recipient <- dac2a.struct$RECIPIENT
names(dac2a.recipient) <- c("RECIPIENT", "Recipient")

dac2a.aidtype <- dac2a.struct$AIDTYPE
names(dac2a.aidtype) <- c("AIDTYPE", "Aid_type")

dac2a.data_type <- dac2a.struct$DATATYPE
names(dac2a.data_type) <- c("DATATYPE", "Data_type")



##Pull the data and save it locally
#Pull years separately and then combine them
#Filter to only where aid type = gross net of debt relief or imputed multilateral, since that's what we'll use
dac2a.16.full <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2016, end_time = 2016, pre_formatted = TRUE)
dac2a.16 <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2016, end_time = 2016, pre_formatted = TRUE)
dac2a.15 <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2015, end_time = 2015, pre_formatted = TRUE)
dac2a.14 <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2014, end_time = 2014, pre_formatted = TRUE)
dac2a.1213 <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2012, end_time = 2013, pre_formatted = TRUE)
dac2a.1011 <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2010, end_time = 2011, pre_formatted = TRUE)
dac2a.0809 <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2008, end_time = 2009, pre_formatted = TRUE)
dac2a.07 <- get_dataset("TABLE2A", filter = "..1+2.106+250.A+D", start_time = 2007, end_time = 2007, pre_formatted = TRUE)

#Also pull where aid type is gross total ODA for 2015 only, since that is used to impute multilateral aid to certain destinations
#in the preliminary release
dac2a.15.gross <- get_dataset("TABLE2A", filter = "..1+2.240.A+D", start_time = 2015, end_time = 2015, pre_formatted = TRUE)

#Also pull Germany's Total Net ODA numbers for 2015, since that is needed to impute Germany's 2016 LDC figure.
dac2a.15.germany <- get_dataset("TABLE2A", filter = ".5.1+2.206.A+D", start_time = 2015, end_time = 2015, pre_formatted = TRUE)

#write.csv(dac2a.1415, 'dac2a_filtered_1415.csv', row.names = FALSE)

dac2a.1516 <- dac2a.16 %>%
  bind_rows(dac2a.15)

dac2a <- dac2a.16 %>%
  bind_rows(dac2a.15) %>% 
  bind_rows(dac2a.14) %>% 
  #bind_rows(dac2a.15.gross) %>% 
  #bind_rows(dac2a.15.germany) %>% 
  bind_rows(dac2a.1213) %>% 
  bind_rows(dac2a.1011) %>% 
  bind_rows(dac2a.0809) %>% 
  bind_rows(dac2a.07)

#rm(dac2a.2015, dac2a.2014, dac2a.2013, dac2a.2012, dac2a.2011, dac2a.2010)

#Add a column that shows when the data was pulled
dac2a$as_of_date <- Sys.Date()
dac2a.1516$as_of_date <- "2018-01-02"

write.csv(dac2a, "../source_data/dac2a_filtered_2007_2016_20180102.csv", row.names = FALSE)




#If the data has already been pulled, start by reading the locally stored data
dac2a <- read.csv("../source_data/dac2a_filtered_2007_2016_20180102.csv", stringsAsFactors = FALSE)

#Read in the table of donor dimensions (same table as for DAC1)
dac2a.donors <- read.csv("dimensions/dac2a_donors_map.csv", stringsAsFactors = FALSE)

dac2a.recipients <- read.csv("dimensions/dac2a_recipients_map.csv", stringsAsFactors = FALSE)

#convert the dimension table ids into integers to the ids are the same type in all tables
dac2a.aidtype$AIDTYPE <- as.integer(dac2a.aidtype$AIDTYPE)



#Denormalise tables by joining in dimension descriptions, and write the results to .csv
dac2a <- dac2a %>%
  left_join(dac2a.aidtype, by = "AIDTYPE") %>% 
  left_join(dac2a.data_type, by = "DATATYPE") %>% 
  left_join(dac2a.donors, by = c("DONOR" = "DAC_DONOR")) %>% 
  left_join(dac2a.recipients, by = "RECIPIENT")

#rm(dac2a.aidtype, dac2a.data_type, dac2a.donors, dac2a.recipient)

write.csv(dac2a, "../source_data/dac2a_filtered_2007_2016_20180102_denorm.csv", row.names = FALSE)

