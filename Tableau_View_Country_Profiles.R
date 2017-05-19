#############################################################

# Create a Tableau-friendly view of the DAC1 and DAC2A data #
# To use in the country profiles                            #

#############################################################



#Load Packages
library(tidyverse)

#Set working directory
setwd("H:/OECD_data/DATA_Report_2017")

#Read Datasets
dac1 <- read.csv("../source_data/dac1_2007_2016_20170515_denorm.csv", stringsAsFactors = FALSE)
dac2a <- read.csv("../source_data/dac2a_filtered_2007_2015_20170518_denorm.csv", stringsAsFactors = FALSE)

# prelim.2016 <- read.csv("source/prelim_2016_denorm.csv", stringsAsFactors = FALSE)

# #Load Deflators
# deflators <- read_excel('source/Deflators-base-2015.xls', skip = 2)
# 
# #Reshape and clean up deflators
# names(deflators)[1] <- 'Donor'
# 
# deflators <- deflators %>% 
#   gather(Year.real, Deflator.char, -Donor) %>% 
#   mutate(Time_Period = as.integer(Year.real),
#          Deflator = as.numeric(Deflator.char)/100) %>% 
#   select(-Year.real, -Deflator.char)
# 
# #### Manual correction/assumption for Germany's missing LDC number
# germany.2015.actual <- dac2a %>% 
#   filter(Donor == 'Germany',
#          Recipient == 'LDCs, Total',
#          Aid_type %in% c('ODA: Total Net'),
#          Data_type == 'Current Prices',
#          obsTime == 2015) %>% 
#   select(obsValue)
# 
# germany.2016.deflator <- deflators %>%
#   filter(Donor == 'Germany',
#          Time_Period == 2016) %>% 
#   select(Deflator)
# 
# 
# prelim.2016[prelim.2016$NameE == "   a. Bil. ODA to LDCs" & 
#               prelim.2016$Donor == 'Germany','obsValue'] <- germany.2015.actual * germany.2016.deflator






#Produce a Tableau-friendly sub-table of the DAC1 and DAC2 data, with preliminary data


#first, summarise the base data by donor country on what they gave
tableau.base.dac1 <- dac1 %>%
  filter(Fund_flows == 'Net Disbursements',
         !Transaction_Aid_type_short %in% c("",'II_Other_Official_Flows','III_Private_Flows',
                                            'IV_Net_Private_Grants','V_Total_Peacekeeping')) %>% 
  mutate(Time_Period = obsTime) %>% 
  select(Donor, Donor_Group_Type, Donor_DAC_Country, Donor_EU_Country,
         as_of_date, Data_type, Constant_price_date = REFERENCEPERIOD, Time_Period,
         Transaction_Aid_type_short, obsValue) %>% 
  spread(Transaction_Aid_type_short, obsValue, fill=0) %>% 
  mutate(Total_ODA_ONE = IA_Bilateral_ODA + 
           IB_Multilateral_ODA - 
           IA6_Debt_Relief,
         Bilat_ODA_Ex_Debt_Relief = IA_Bilateral_ODA - IA6_Debt_Relief)

#then summarise how much each donor gave to LDCs and SSAs
tableau.dac2a <- dac2a %>%
  filter(Aid_type %in% c('Imputed Multilateral ODA','Memo: ODA Total, excl. Debt')) %>% 
  select(Donor, Time_Period = obsTime, Data_type, Constant_price_date = REFERENCEPERIOD, 
         Aid_type, obsValue, Recipient, Recipient_Fragile_State_ONE2017, Recipient_Africa) %>% 
  group_by(Donor, Data_type, Constant_price_date, Time_Period) %>% 
  summarise(LDC_ODA = sum(obsValue[Recipient == 'LDCs, Total']),
            SSA_ODA = sum(obsValue[Recipient == 'South of Sahara, Total']),
            Fragile_State_ODA = sum(obsValue[Recipient_Fragile_State_ONE2017 == 'Fragile State']),
            Africa_ODA =  sum(obsValue[Recipient == 'Africa, Total']),
            Africa_Fragile_ODA = sum(obsValue[Recipient_Fragile_State_ONE2017 == 'Fragile State' & Recipient_Africa == 'Africa']),
            LDC_ODA_Bilateral = sum(obsValue[Recipient == 'LDCs, Total' & Aid_type == 'Memo: ODA Total, excl. Debt']),
            SSA_ODA_Bilateral = sum(obsValue[Recipient == 'South of Sahara, Total' & Aid_type == 'Memo: ODA Total, excl. Debt']),
            Africa_ODA_Bilateral = sum(obsValue[Recipient == 'Africa, Total' & Aid_type == 'Memo: ODA Total, excl. Debt']),
            LDC_ODA_Imputed_Multilateral = sum(obsValue[Recipient == 'LDCs, Total' & Aid_type == 'Imputed Multilateral ODA']),
            Fragile_State_ODA_Bilateral = sum(obsValue[Recipient_Fragile_State_ONE2017 == 'Fragile State' & Aid_type == 'Memo: ODA Total, excl. Debt']))


#pull in the preliminary data and reshape it to match the previous tables
#NOTE -- explicitely flag any known missing data with NAs here
# tableau.prelim.2016 <- prelim.2016 %>%
#   filter(Fund_flows == 'Net Disbursements',
#          Transaction_Aid_type_short != "") %>%
#   select(Donor, Donor_Group_Type, Donor_DAC_Country, Donor_EU_Country,
#          as_of_date, Data_type, Time_Period = obsTime,
#          Transaction_Aid_type_short, obsValue) %>%
#   spread(Transaction_Aid_type_short, obsValue, fill=0) %>%
#   mutate(SSA_ODA_Bilateral = SSA_ODA_Bilateral_inc_Debt_Relief - SSA_ODA_Bilateral_Debt_Relief,
#          LDC_ODA_Bilateral = LDC_ODA_Bilateral_inc_Debt_Relief - SSA_ODA_Bilateral_Debt_Relief,
#          Africa_ODA_Bilateral = Africa_ODA_Bilateral_inc_Debt_Relief - SSA_ODA_Bilateral_Debt_Relief,
#          #assume that ssa debt relief equals total LDC debt relief, since we don't have the detail
#          ONE_ODA = IA_Bilateral_ODA +
#            IB_Multilateral_ODA -
#            IA6_Debt_Relief) %>%
#   select(-LDC_ODA_Bilateral_inc_Debt_Relief,
#          -SSA_ODA_Bilateral_inc_Debt_Relief,
#          -SSA_ODA_Bilateral_Debt_Relief,
#          -Africa_ODA_Bilateral_inc_Debt_Relief)




# #Impute how much multilateral aid went to LDCs and SSAs
# 
# #multilat.map <- read.csv('dimensions/multilat_mapping.csv', stringsAsFactors = FALSE)
# multilat.map.granular <- read.csv('dimensions/Multilat_map_granular.csv', stringsAsFactors = FALSE)
# 
# 
# #First calculate how much each of these multilaterals gave to LDCs and SSas the previous year
# multilat.dac2a <- dac2a %>%
#   filter(Aid_type == "Memo: ODA Total, Gross disbursements",
#          Donor %in% multilat.map.granular$Multilateral,
#          obsTime == 2015,
#          Data_type == 'Current Prices') %>% 
#   select(Donor, Aid_type, obsValue, Recipient) %>% 
#   left_join(multilat.map.granular, by=c('Donor' = 'Multilateral')) %>% 
#   group_by(Multilat, NameE) %>% 
#   summarise(Total_Disbursed = sum(obsValue[Recipient == 'Developing Countries, Total']),
#             LDC_ODA = sum(obsValue[Recipient == 'LDCs, Total']),
#             SSA_ODA = sum(obsValue[Recipient == 'South of Sahara, Total']),
#             Africa_ODA = sum(obsValue[Recipient == 'Africa, Total'])) %>% 
#   mutate(Est_Individual_Multilat_Percent_to_LDC = LDC_ODA/Total_Disbursed,
#          Est_Individual_Multilat_Percent_to_SSA = SSA_ODA/Total_Disbursed,
#          Est_Individual_Multilat_Percent_to_Africa = Africa_ODA/Total_Disbursed)

# multilat.dac2a <- dac2a %>%
#   filter(Aid_type == 'Memo: ODA Total, excl. Debt',
#          Donor %in% multilat.map$Donor,
#          obsTime == 2014,
#          Data_type == 'Current Prices') %>% 
#   select(Donor, Aid_type, obsValue, Recipient) %>% 
#   group_by(Donor) %>% 
#   summarise(LDC_ODA = sum(obsValue[Recipient == 'LDCs, Total']),
#             SSA_ODA = sum(obsValue[Recipient == 'South of Sahara, Total']))

# #Then calculate how much total in the previous year was given to each class of multilaterals, and join tables together
# multilat.dac <- dac1 %>% 
#   filter(Fund_flows == 'Net Disbursements',
#          Transaction_Aid_Type %in% multilat.map$Transaction_Aid_Type,
#          obsTime == 2014,
#          Donor == 'All Donors, Total',
#          Data_type == 'Current Prices') %>% 
#   left_join(multilat.map, by='Transaction_Aid_Type') %>% 
#   group_by(Donor.y, NameE) %>% 
#   summarise(Total_ODA = sum(obsValue)) %>% 
#   left_join(multilat.dac2a, by= c('Donor.y' = 'Donor')) %>% 
#   mutate(Est_Individual_Multilat_Percent_to_LDC = LDC_ODA/Total_ODA,
#          Est_Individual_Multilat_Percent_to_SSA = SSA_ODA/Total_ODA) %>% 
#   select(-Donor.y, -Total_ODA, -LDC_ODA, -SSA_ODA)

# #Next look at how much newest-year DAC ODA each country sent to these multilats
# multilat.est <- prelim.2016 %>% 
#   filter(NameE %in% multilat.map.granular$NameE) %>% 
#   left_join(multilat.dac2a, by='NameE') %>% 
#   mutate(cleanValue = ifelse(is.na(obsValue), 0, obsValue), 
#          Est_Individual_Multilat_to_LDC = cleanValue * Est_Individual_Multilat_Percent_to_LDC,
#          Est_Individual_Multilat_to_SSA = cleanValue * Est_Individual_Multilat_Percent_to_SSA,
#          Est_Individual_Multilat_to_Africa = cleanValue * Est_Individual_Multilat_Percent_to_Africa) %>% 
#   group_by(Donor, Data_type, Time_Period = obsTime) %>% 
#   summarise(Est_Multilat_to_LDC = sum(Est_Individual_Multilat_to_LDC),
#             Est_Multilat_to_SSA = sum(Est_Individual_Multilat_to_SSA),
#             Est_Multilat_to_Africa = sum(Est_Individual_Multilat_to_Africa))
# 
# 
# #Join these onto the preliminary data and make new total ODA to LDCs/SSA estimates
# tableau.prelim.2016.plus <- tableau.prelim.2016 %>% 
#   left_join(multilat.est, by=c('Donor', 'Data_type', 'Time_Period')) %>% 
#   mutate(LDC_ODA = LDC_ODA_Bilateral + Est_Multilat_to_LDC,
#          SSA_ODA = SSA_ODA_Bilateral + Est_Multilat_to_SSA,
#          Africa_ODA = Africa_ODA_Bilateral + Est_Multilat_to_Africa,
#          LDC_ODA_Imputed_Multilateral = Est_Multilat_to_LDC) %>% 
#   select(-Est_Multilat_to_LDC, -Est_Multilat_to_SSA, -Est_Multilat_to_Africa)

# 
# 
#combine everything together
tableau.combined <- tableau.base.dac1 %>%
  left_join(tableau.dac2a, by=c('Donor','Data_type','Constant_price_date','Time_Period')) %>%
  #bind_rows(tableau.prelim.2016.plus) %>%
  arrange(Donor, Time_Period, Data_type)
# 
# 
# #Split constant and current prices
# tableau.combined.constant <- tableau.combined %>% 
#   filter(Data_type == 'Constant Prices')
# 
# tableau.combined.current <- tableau.combined %>% 
#   filter(Data_type == 'Current Prices',
#          !is.na(Donor))
# 
# 
# 
# 
# 
# 
# #Gather current year prices, join on deflators, do math and then spread again
# tableau.combined.new <- tableau.combined.current %>% 
#   select(-Population, -Data_type) %>% 
#   gather(Measure, Current_Prices, -Donor, -Donor_Group_Type, -Donor_DAC_Country, 
#          -Donor_EU_Country, -as_of_date, -Current_price_date, -Time_Period) %>% 
#   left_join(deflators, by=c('Donor','Time_Period')) %>% 
#   mutate(Constant_Prices = Current_Prices / Deflator) %>% 
#   select(-Deflator) %>% 
#   gather(Data_type, Value, Constant_Prices, Current_Prices) %>% 
#   #UPDATE this date once actual release happens
#   mutate(Constant_price_date = ifelse(Data_type == 'Constant_Prices', 2015, NA)) %>% 
#   spread(Measure, Value) %>% 
#   arrange(Donor, Time_Period, Data_type)
# 
# 
# 
# 
# #Write final output
# write.csv(tableau.combined.new, 'views/DAC_Combined_Tableau_PrelimRelease.csv', row.names = FALSE)
# 
# 
# #And one more where data type is in the column headers
# tableau.combined.datatype <- tableau.combined.new%>%
#   #select(-II_Other_Official_Flows, -III_Private_Flows, -IV_Net_Private_Grants, -V_Total_Peacekeeping,
#   #       -Fragile_State_ODA, -Fragile_State_ODA_Bilateral) %>% 
#   gather(Metric, Value, -Donor, -Donor_Group_Type, -Donor_DAC_Country, -Donor_EU_Country, 
#          -as_of_date, -Current_price_date, -Time_Period, -Data_type) %>% 
#   mutate(new_names = paste(Metric, Data_type, sep='_')) %>% 
#   select(-Data_type, -Metric) %>% 
#   spread(new_names, Value)
# 
# write.csv(tableau.combined.datatype, 'views/DAC_Combined_Tableau_PrelimRelease_alt.csv', row.names = FALSE)


#And one more where data type is in the column headers
tableau.combined.datatype <- tableau.combined %>%
  #select(-II_Other_Official_Flows, -III_Private_Flows, -IV_Net_Private_Grants, -V_Total_Peacekeeping,
  #       -Fragile_State_ODA, -Fragile_State_ODA_Bilateral) %>% 
  gather(Metric, Value, -Donor, -Donor_Group_Type, -Donor_DAC_Country, -Donor_EU_Country, 
         -as_of_date, -Constant_price_date, -Time_Period, -Data_type) %>% 
  mutate(new_names = paste(Metric, Data_type, sep='_')) %>% 
  select(-Data_type, -Metric) %>% 
  spread(new_names, Value)

write.csv(tableau.combined.datatype, 'views/DAC_Combined_Tableau_Draft.csv', row.names = FALSE)
