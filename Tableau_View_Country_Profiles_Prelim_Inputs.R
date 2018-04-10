#############################################################

# Create a Tableau-friendly view of the DAC1 and DAC2A data #
# To use in the country profiles                            #
# Using DAC Preliminary data as an input                    #

#############################################################



#Load Packages
library(tidyverse)
library(readxl)

#Set working directory
#setwd("H:/OECD_data/DATA_Report_2017")

#Read Datasets
dac1 <- read.csv("../source_data/dac1_2007_2016_20180102_denorm.csv", stringsAsFactors = FALSE)
dac2a <- read.csv("../source_data/dac2a_filtered_2007_2016_20180102_denorm.csv", stringsAsFactors = FALSE)

prelim.2017 <- read.csv("../source_data/prelim_2017_denorm.csv", stringsAsFactors = FALSE)

#Load Deflators
deflators <- read_excel('../source_data/Deflators-base-2016.xls', skip = 2)

#Reshape and clean up deflators
names(deflators)[1] <- 'Donor'

deflators <- deflators %>%
  gather(Year.real, Deflator.char, -Donor) %>%
  mutate(Time_Period = as.integer(Year.real),
         Deflator = as.numeric(Deflator.char)/100) %>%
  select(-Year.real, -Deflator.char)

#### Insert manual correction/assumption for Germany's missing LDC number
germany.2016.actual <- dac2a %>%
  filter(Donor == 'Germany',
         Recipient == 'LDCs, Total',
         Aid_type %in% c('ODA: Total Net'),
         Data_type == 'Current Prices',
         obsTime == 2016) %>%
  select(obsValue)

germany.2017.deflator <- deflators %>%
  filter(Donor == 'Germany',
         Time_Period == 2017) %>%
  select(Deflator)


prelim.2017[prelim.2017$NameE == "   a. Bil. ODA to LDCs" &
              prelim.2017$Donor == 'Germany','obsValue'] <- germany.2016.actual * germany.2017.deflator






#Produce a Tableau-friendly sub-table of the DAC1 and DAC2 data, with preliminary data


#first, summarise the base data by donor country on what they gave
tableau.base.dac1 <- dac1 %>%
  filter(Fund_flows == 'Net Disbursements',
         !is.na(Transaction_Aid_type_short),
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


# pull in the preliminary data and reshape it to match the previous tables
# NOTE -- explicitely flag any known missing data with NAs here
tableau.prelim.2017 <- prelim.2017 %>%
  filter(Fund_flows == 'Net Disbursements',
         Transaction_Aid_type_short != "") %>%
  select(Donor, Donor_Group_Type, Donor_DAC_Country, Donor_EU_Country,
         as_of_date, Data_type, Time_Period = obsTime,
         Transaction_Aid_type_short, obsValue) %>%
  spread(Transaction_Aid_type_short, obsValue, fill=0) %>%
  mutate(SSA_ODA_Bilateral = SSA_ODA_Bilateral_inc_Debt_Relief - SSA_ODA_Bilateral_Debt_Relief,
         LDC_ODA_Bilateral = LDC_ODA_Bilateral_inc_Debt_Relief - SSA_ODA_Bilateral_Debt_Relief,
         Africa_ODA_Bilateral = Africa_ODA_Bilateral_inc_Debt_Relief - SSA_ODA_Bilateral_Debt_Relief,
         #assume that ssa debt relief equals total LDC debt relief, since we don't have the detail
         Total_ODA_ONE = IA_Bilateral_ODA +
           IB_Multilateral_ODA -
           IA6_Debt_Relief,
         Bilat_ODA_Ex_Debt_Relief = IA_Bilateral_ODA - IA6_Debt_Relief) %>%
  select(-LDC_ODA_Bilateral_inc_Debt_Relief,
         -SSA_ODA_Bilateral_inc_Debt_Relief,
         -SSA_ODA_Bilateral_Debt_Relief,
         -Africa_ODA_Bilateral_inc_Debt_Relief)


###Impute how much multilateral aid went to LDCs and SSAs

multilat.map <- read.csv('dimensions/multilat_mapping.csv', stringsAsFactors = FALSE)

multilat.2016 <- read.csv('../source_data/TABLE2A_09042018_multilat_imputation.csv', stringsAsFactors = FALSE)


#First calculate how much each of these multilaterals gave to LDCs and SSas the previous year
multilat.dac2a <- dac2a %>%
  filter(Aid_type == "Memo: ODA Total, Gross disbursements",
         Donor %in% multilat.map$Multilateral,
         obsTime == 2016,
         Data_type == 'Current Prices') %>%
  select(Donor, Aid_type, obsValue, Recipient) %>%
  left_join(multilat.map, by=c('Donor' = 'Multilateral')) %>%
  group_by(Multilat, NameE) %>%
  summarise(Total_Disbursed = sum(obsValue[Recipient == 'Developing Countries, Total']),
            LDC_ODA = sum(obsValue[Recipient == 'LDCs, Total']),
            SSA_ODA = sum(obsValue[Recipient == 'South of Sahara, Total']),
            Africa_ODA = sum(obsValue[Recipient == 'Africa, Total'])) %>%
  mutate(Est_Individual_Multilat_Percent_to_LDC = LDC_ODA/Total_Disbursed,
         Est_Individual_Multilat_Percent_to_SSA = SSA_ODA/Total_Disbursed,
         Est_Individual_Multilat_Percent_to_Africa = Africa_ODA/Total_Disbursed)

#Redo this calculation using an OECD extract rather than the full DAC2A dataset
multilat.dac2a <- multilat.2016 %>%
  mutate(Aid_type = Aid.type, obsTime = Year, 
         Data_type = Amount.type, obsValue = Value) %>% 
  filter(Aid_type == "Memo: ODA Total, Gross disbursements",
         Donor %in% multilat.map$Multilateral,
         obsTime == 2016,
         Data_type == 'Current Prices') %>%
  select(Donor, Aid_type, obsValue, Recipient) %>%
  left_join(multilat.map, by=c('Donor' = 'Multilateral')) %>%
  group_by(Multilat, NameE) %>%
  summarise(Total_Disbursed = sum(obsValue[Recipient == 'Developing Countries, Total']),
            LDC_ODA = sum(obsValue[Recipient == 'LDCs, Total']),
            SSA_ODA = sum(obsValue[Recipient == 'South of Sahara, Total']),
            Africa_ODA = sum(obsValue[Recipient == 'Africa, Total'])) %>%
  mutate(Est_Individual_Multilat_Percent_to_LDC = LDC_ODA/Total_Disbursed,
         Est_Individual_Multilat_Percent_to_SSA = SSA_ODA/Total_Disbursed,
         Est_Individual_Multilat_Percent_to_Africa = Africa_ODA/Total_Disbursed)

#Next look at how much newest-year DAC ODA each country sent to these multilats, and multiple by the previous year's
#ratio of what each multilat group sent to certain recipient country groups
multilat.est <- prelim.2017 %>%
  filter(NameE %in% multilat.map$NameE) %>%
  left_join(multilat.dac2a, by='NameE') %>%
  mutate(cleanValue = ifelse(is.na(obsValue), 0, obsValue),
         Est_Individual_Multilat_to_LDC = cleanValue * Est_Individual_Multilat_Percent_to_LDC,
         Est_Individual_Multilat_to_SSA = cleanValue * Est_Individual_Multilat_Percent_to_SSA,
         Est_Individual_Multilat_to_Africa = cleanValue * Est_Individual_Multilat_Percent_to_Africa) %>%
  group_by(Donor, Data_type, Time_Period = obsTime) %>%
  summarise(Est_Multilat_to_LDC = sum(Est_Individual_Multilat_to_LDC),
            Est_Multilat_to_SSA = sum(Est_Individual_Multilat_to_SSA),
            Est_Multilat_to_Africa = sum(Est_Individual_Multilat_to_Africa))



#Join these onto the preliminary data and make new total ODA to LDCs/SSA estimates
tableau.prelim.2017.plus <- tableau.prelim.2017 %>%
  left_join(multilat.est, by=c('Donor', 'Data_type', 'Time_Period')) %>%
  mutate(LDC_ODA = LDC_ODA_Bilateral + Est_Multilat_to_LDC,
         SSA_ODA = SSA_ODA_Bilateral + Est_Multilat_to_SSA,
         Africa_ODA = Africa_ODA_Bilateral + Est_Multilat_to_Africa,
         LDC_ODA_Imputed_Multilateral = Est_Multilat_to_LDC)  %>% 
  select(-Est_Multilat_to_LDC, -Est_Multilat_to_SSA, -Est_Multilat_to_Africa)



#Bind the new preliminary DAC2A estimates onto the historical DAC2A view
#tableau.dac2a.plus <- tableau.dac2a %>%
#  bind_rows(tableau.prelim.2017.plus) %>%
#  arrange(Donor, Time_Period, Data_type)
 

#combine everything together
tableau.combined <- tableau.base.dac1 %>%
  left_join(tableau.dac2a, by=c('Donor','Data_type','Constant_price_date','Time_Period')) %>% 
  bind_rows(tableau.prelim.2017.plus) %>%
  arrange(Donor, Time_Period, Data_type)

############# final release ################

#Create a table of conversion factors across data types, using Total ODA from DAC1 as a source of truth
price.conversion.table <- tableau.combined %>%
  select(-Constant_price_date) %>% 
  gather(Metric, Value, -Donor, -Donor_Group_Type, -Donor_DAC_Country, 
         -Donor_EU_Country, -as_of_date, -Data_type, -Time_Period) %>% 
  mutate(names = gsub(" ", "_", Data_type)) %>% 
  select(-Data_type) %>% 
  spread(names, Value) %>% 
  mutate(National_Ccy_Ratio = National_currency / Current_Prices,
         Constant_Price_Ratio = Constant_Prices / Current_Prices) %>% 
  filter(Metric == 'Total_ODA_ONE') %>% 
  select(Donor, Time_Period, National_Ccy_Ratio, Constant_Price_Ratio)

#Apply these conversion factors to donor-level metrics where we lack constant or national ccy prices
#and reshape the data for use in Tableau
tableau.combined.imputed <- tableau.combined %>%
  select(-Constant_price_date) %>% 
  gather(Metric, Value, -Donor, -Donor_Group_Type, -Donor_DAC_Country, 
         -Donor_EU_Country, -as_of_date, -Data_type, -Time_Period) %>% 
  mutate(names = gsub(" ", "_", Data_type)) %>% 
  select(-Data_type) %>% 
  filter(Metric != 'Population') %>% 
  spread(names, Value) %>% 
  left_join(price.conversion.table, by=c('Donor','Time_Period')) %>% 
  mutate(National_Currency_Imputed = ifelse(is.na(National_currency) & Donor_Group_Type == 'Donor', 
                                            Current_Prices * National_Ccy_Ratio, National_currency),
         Constant_Prices_Imputed = ifelse(is.na(Constant_Prices) & Donor_Group_Type == 'Donor', 
                                          Current_Prices * Constant_Price_Ratio, Constant_Prices)) %>% 
  select(-National_currency, -Constant_Prices, -Constant_Price_Ratio, -National_Ccy_Ratio) %>% 
  mutate(National_currency = National_Currency_Imputed,
         Constant_Prices = Constant_Prices_Imputed) %>% 
  select(-National_Currency_Imputed, -Constant_Prices_Imputed) %>% 
  gather(Data_type, Value, Current_Prices:Constant_Prices) %>% 
  mutate(new_names = paste(Metric, gsub('_',' ',Data_type), sep='_')) %>% 
  select(-Data_type, -Metric)  %>% 
  spread(new_names, Value)


write.csv(tableau.combined.imputed, 'views/DAC_Combined_Tableau_Prelim2017.csv', row.names = FALSE)


# Create a long form of the data to use in the DATA report online interactive viz
# Where data type is a dimension
tableau.combined.imputed.long <- tableau.combined %>%
  select(-Constant_price_date, -Population) %>% 
  gather(Metric, Value, -Donor, -Donor_Group_Type, -Donor_DAC_Country, 
         -Donor_EU_Country, -as_of_date, -Data_type, -Time_Period) %>% 
  spread(Data_type, Value) %>% 
  left_join(price.conversion.table, by=c('Donor','Time_Period')) %>% 
  mutate(National_Currency_Imputed = ifelse(is.na(`National currency`) & Donor_Group_Type == 'Donor', 
                                            `Current Prices` * National_Ccy_Ratio, `National currency`),
         Constant_Prices_Imputed = ifelse(is.na(`Constant Prices`) & Donor_Group_Type == 'Donor', 
                                          `Current Prices` * Constant_Price_Ratio, `Constant Prices`)) %>% 
  select(-`National currency`, -`Constant Prices`, -Constant_Price_Ratio, -National_Ccy_Ratio) %>% 
  mutate(`National currency` = National_Currency_Imputed,
         `Constant Prices` = Constant_Prices_Imputed) %>% 
  select(-National_Currency_Imputed, -Constant_Prices_Imputed) %>% 
  gather(Data_type, Value, `Current Prices`:`Constant Prices`)

write.csv(tableau.combined.imputed.long, 'views/DAC_Combined_Interactive_Prelim2017.csv', row.names = FALSE)


#############################

#Split constant and current prices
tableau.combined.constant <- tableau.combined %>% 
  filter(Data_type == 'Constant Prices')

tableau.combined.current <- tableau.combined %>% 
  filter(Data_type == 'Current Prices',
         !is.na(Donor))






#Gather current year prices, join on deflators, do math and then spread again
tableau.combined.new <- tableau.combined.current %>% 
  select(-Population, -Data_type) %>% 
  gather(Measure, Current_Prices, -Donor, -Donor_Group_Type, -Donor_DAC_Country, 
         -Donor_EU_Country, -as_of_date, -Constant_price_date, -Time_Period) %>% 
  left_join(deflators, by=c('Donor','Time_Period')) %>% 
  mutate(Constant_Prices = Current_Prices / Deflator) %>% 
  select(-Deflator) %>% 
  gather(Data_type, Value, Constant_Prices, Current_Prices) %>% 
  #UPDATE this date once actual release happens
  mutate(Constant_price_date = ifelse(Data_type == 'Constant_Prices', 2016, NA)) %>% 
  spread(Measure, Value) %>% 
  arrange(Donor, Time_Period, Data_type)


#And one more where data type is in the column headers
tableau.combined.datatype <- tableau.combined.new%>%
  #select(-II_Other_Official_Flows, -III_Private_Flows, -IV_Net_Private_Grants, -V_Total_Peacekeeping,
  #       -Fragile_State_ODA, -Fragile_State_ODA_Bilateral) %>% 
  gather(Metric, Value, -Donor, -Donor_Group_Type, -Donor_DAC_Country, -Donor_EU_Country, 
         -as_of_date, -Constant_price_date, -Time_Period, -Data_type) %>% 
  mutate(new_names = paste(Metric, Data_type, sep='_')) %>% 
  select(-Data_type, -Metric) %>% 
  spread(new_names, Value)

write.csv(tableau.combined.datatype, 'views/DAC_Combined_Tableau_Prelim_18Apr18.csv', row.names = FALSE)
