#############################################################

#  Convert the DAC2A data to a list of nodes and edges      #
#            To play with on Graph Commons                  #
#                  (an experiment...)                       #

#############################################################



#Load Packages
library(tidyverse)
library(readxl)

#Set working directory
setwd("H:/OECD_data/DATA_Report_2017")

#Read Datasets
dac2a <- read.csv("../source_data/dac2a_filtered_2007_2015_20170519_denorm.csv", stringsAsFactors = FALSE)

#Get edges
dac2a %>% 
  filter(obsTime == 2015,
         Data_type == 'Current Prices',
         Aid_type %in% c('Imputed Multilateral ODA','Memo: ODA Total, excl. Debt'),
         Recipient_Group_Type != 'Group',
         Donor_Group_Type != 'Group') %>% 
  select(Source = Donor, Target = Recipient, Recipient_Group_Type, Donor_Group_Type, obsValue) %>% 
  group_by(Source, Target, Recipient_Group_Type, Donor_Group_Type) %>% 
  summarise(Weight = sum(obsValue)) %>% 
  write.csv('views/dac2a_edges.csv', row.names = FALSE)

#Get nodes
#First get donors
donors <- dac2a %>% 
  filter(obsTime == 2015,
         Data_type == 'Current Prices',
         Aid_type %in% c('Imputed Multilateral ODA','Memo: ODA Total, excl. Debt'),
         Donor_Group_Type != 'Group') %>% 
  select(Entity = Donor, Type = Donor_Group_Type, obsValue) %>% 
  group_by(Entity, Type) %>% 
  summarise(Total = sum(obsValue))

#Then recipients and join on donors before writing
dac2a %>% 
  filter(obsTime == 2015,
         Data_type == 'Current Prices',
         Aid_type %in% c('Imputed Multilateral ODA','Memo: ODA Total, excl. Debt'),
         Recipient_Group_Type != 'Group') %>% 
  select(Id = Recipient, Type = Recipient_Group_Type, obsValue) %>% 
  group_by(Id, Type) %>% 
  summarise(Total = sum(obsValue)) %>% 
  bind_rows(donors) %>% 
  write.csv('views/dac2a_nodes.csv', row.names = FALSE)