#############################################################

# Create a Tableau-friendly view of aid by income group     #
# of recipient country                                      #
# Using DAC final data from API as an input                 #

#############################################################



#Load Packages
library(tidyverse)
library(readxl)

#Set working directory
setwd("H:/OECD_data/DATA_Report_2017")

#Read Datasets
dac1 <- read.csv("../source_data/dac1_2007_2016_20180102_denorm.csv", stringsAsFactors = FALSE)
dac2a <- read.csv("../source_data/dac2a_filtered_2007_2016_20180102_denorm.csv", stringsAsFactors = FALSE)
income_groups_source <- read.csv("dimensions/OECD_income_groups.csv", stringsAsFactors = FALSE)

# Summarise the income group date to make a tidy mapping table
income_groups <- income_groups_source %>% 
  group_by(RecipientCode, RecipientNameE, incomegrname, Regionnname) %>% 
  summarise(delete = 1)



#then summarise how much each donor gave to each income group
tableau.dac2a.income.group <- dac2a %>%
  filter(Aid_type %in% c('Imputed Multilateral ODA','Memo: ODA Total, excl. Debt')) %>% 
  left_join(income_groups, by=c('RECIPIENT'='RecipientCode')) %>% 
  select(Donor, Time_Period = obsTime, Data_type, Constant_price_date = REFERENCEPERIOD, 
         Aid_type, obsValue, Recipient, Recipient_Fragile_State_ONE2017, Recipient_Africa, 
         Donor_Group_Type, Donor_DAC_Country, Donor_DAC_2016_Country, Donor_EU_Country,
         Income_Group = incomegrname, Region_name = Regionnname) %>% 
  group_by(Donor, Data_type, Constant_price_date, Time_Period, Recipient, Income_Group, Region_name,
           Donor_Group_Type, Donor_DAC_Country, Donor_DAC_2016_Country, Donor_EU_Country) %>% 
  summarise(ONE_ODA = sum(obsValue[Aid_type %in% c('Memo: ODA Total, excl. Debt','Imputed Multilateral ODA')]),
            ODA_Bilateral_Ex_Debt_Relief = sum(obsValue[Aid_type == 'Memo: ODA Total, excl. Debt']),
            ODA_Imputed_Multilateral = sum(obsValue[Aid_type == 'Imputed Multilateral ODA'])) %>% 
  mutate(Source = 'DAC2A') %>% 
  write_csv('views/DAC_2A_Income_Groups.csv')

## NOTE .while the bilateral portion matches the bilateral aid as reported in the DAC1 database,
# the imputed multilateral portion does not.
# Roughly 10% of multilat funding does not get imputed and is therefore missing from DAC2A
# Note that in-donor refugee costs are included as part of the 'unallocated' income group, 
# in the 'developing countries, unspecified' recipient.
# See http://www.oecd.org/dac/financing-sustainable-development/development-finance-standards/oecdmethodologyforcalculatingimputedmultilateraloda.htm

# In order to build a full breakdown of aid to each income group as a share of total ODA, 
# as well as to break out the in-donor refugee costs, we need to figure out a 
# way of splicing in DAC1 data to add a 'other multiteral' category that bridges the totals in the two datasets.

# This view attempts to do that...

# First get the data points we need from DAC1 into a table and rbind onto the DAC2A dataset
tableau.dac1.income.group <- dac1 %>%
  filter(Fund_flows == 'Net Disbursements',
         !is.na(Transaction_Aid_type_short),
         !Transaction_Aid_type_short %in% c("",'II_Other_Official_Flows','III_Private_Flows',
                                            'IV_Net_Private_Grants','V_Total_Peacekeeping')) %>% 
  mutate(Time_Period = obsTime) %>% 
  select(Donor, Donor_Group_Type, Donor_DAC_Country, Donor_EU_Country,
         as_of_date, Data_type, Constant_price_date = REFERENCEPERIOD, Time_Period,
         Transaction_Aid_type_short, obsValue) %>% 
  spread(Transaction_Aid_type_short, obsValue, fill=0) %>% 
  mutate(ONE_ODA = IA_Bilateral_ODA + 
           IB_Multilateral_ODA - 
           IA6_Debt_Relief,
         ODA_Bilateral_Ex_Debt_Relief = IA_Bilateral_ODA - IA6_Debt_Relief,
         ODA_Imputed_Multilateral = IB_Multilateral_ODA,
         Source = 'DAC1')


  

# Frm this, create a little table with in-donor refugee costs as an income group
tableau.dac1.income.group.idr <- tableau.dac1.income.group %>% 
  select(Donor, Donor_Group_Type, Donor_DAC_Country, Donor_EU_Country,
         as_of_date, Data_type, Constant_price_date, Time_Period,
         Source,
         ONE_ODA = IA82_In_Donor_Refugee_Cost) %>% 
  mutate(Income_Group = 'IDR',
         Recipient = 'In-Donor Refugee Costs')

# Also create a little table with total DAC1 ODA as an income group
tableau.dac1.income.group.total <- tableau.dac1.income.group %>% 
  select(Donor, Donor_Group_Type, Donor_DAC_Country, Donor_EU_Country,
         as_of_date, Data_type, Constant_price_date, Time_Period,
         Source,
         ONE_ODA) %>% 
  mutate(Income_Group = 'DAC1_Total',
         Recipient = 'Total DAC1 ODA',
         Region_name = 'DAC1_Total')
  

# Replace blank values for income group with text
tableau.dac2a.income.group[is.na(tableau.dac2a.income.group$Income_Group),'Income_Group'] <- 'Blank'
tableau.dac2a.income.group[tableau.dac2a.income.group$Income_Group == '','Income_Group'] <- 'Blank'

# Combine data sets, spread, do calcs to create new groups, then gather back with a new & clean income group dimension
tableau.combined.income.group <- tableau.dac2a.income.group  %>% 
  bind_rows(tableau.dac1.income.group.idr) %>% 
  bind_rows(tableau.dac1.income.group.total) %>% 
  filter(Donor_Group_Type == 'Donor') %>% 
  select(Donor, Donor_Group_Type, Donor_DAC_Country, Donor_EU_Country, Donor_DAC_2016_Country,
         as_of_date, Data_type, Constant_price_date, Time_Period,
         Source, Income_Group, Region_name, Recipient,
         ONE_ODA)



# Spread, do calcs to create new groups, then gather back with a new & clean income group dimension
test <- tableau.combined.income.group %>% 
  spread(Income_Group, ONE_ODA, fill=0) %>% 
  mutate(Unallocated_Ex_IDR = UnallocatedIncome - IDR,
         DAC1_Top_up = DAC1_Total - LDCs - LMICs - OtherLICs - UMICs - UnallocatedIncome) %>% 
  gather(Income_Group, ONE_ODA, Blank:DAC1_Top_up) %>% 
  filter(ONE_ODA != 0) %>% 
  write_csv('views/DAC_Combined_Income_Groups.csv')