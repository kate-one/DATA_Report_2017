#############################################################

# Create a Tableau-friendly view of the DAC1 and DAC2A data #
# To use in the country profiles                            #
# Using only DAC final data from API as an input            #

#############################################################



#Load Packages
library(tidyverse)
library(readxl)

#Set working directory
setwd("H:/OECD_data/DATA_Report_2017")

#Read Datasets
dac1 <- read.csv("../source_data/dac1_2007_2016_20180102_denorm.csv", stringsAsFactors = FALSE)
dac2a <- read.csv("../source_data/dac2a_filtered_2007_2016_20180102_denorm.csv", stringsAsFactors = FALSE)


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



#combine everything together
tableau.combined <- tableau.base.dac1 %>%
  left_join(tableau.dac2a, by=c('Donor','Data_type','Constant_price_date','Time_Period')) %>%
  arrange(Donor, Time_Period, Data_type)

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
# 
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


write.csv(tableau.combined.imputed, 'views/DAC_Combined_Tableau_Draft_Jan2.csv', row.names = FALSE)


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

write.csv(tableau.combined.imputed.long, 'views/DAC_Combined_Interactive_jan2draft.csv', row.names = FALSE)
