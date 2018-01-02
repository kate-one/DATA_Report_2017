import pandas as pd
import numpy as np
import json

#TODO: add a section of the JSON for annotations & translations
#TODO: add data 'as of' to JSON

# Paths
PATH = '../views/DAC_Combined_Interactive_jan2draft.csv'

# List of donor countries for profiles
PROFILES = ['Australia', 'Canada', 'EU Institutions', 'EU Countries', 'France','Germany',
            'Italy','Japan','Netherlands','Sweden','United States','United Kingdom']

METRICS = ['Africa_ODA', 'Africa_ODA_Bilateral',
       'Bilat_ODA_Ex_Debt_Relief', 'GNI',
       'IA82_In_Donor_Refugee_Cost',
       'IB_Multilateral_ODA', 'LDC_ODA', 'LDC_ODA_Bilateral',
       'LDC_ODA_Imputed_Multilateral', 'SSA_ODA', 'SSA_ODA_Bilateral',
       'Total_ODA_ONE']


NEW_METRIC_NAMES = {'Africa_ODA':'Africa_ODA',
                    'Africa_ODA_Bilateral':'Africa_ODA_Bilateral',
                    'Bilat_ODA_Ex_Debt_Relief':'All_ODA_Bilateral',
                    'GNI':'GNI',
                    'IA82_In_Donor_Refugee_Cost':'In_Donor_Refugee_Costs',
                    'IB_Multilateral_ODA':'All_ODA_Multilateral',
                    'LDC_ODA':'LDC_ODA',
                    'LDC_ODA_Bilateral':'ODC_ODA_Bilateral',
                    'LDC_ODA_Imputed_Multilateral':'LDC_ODA_Imputed_Multilateral',
                    'SSA_ODA':'SSA_ODA',
                    'SSA_ODA_Bilateral':'SSA_ODA_Bilateral',
                    'Total_ODA_ONE':'All_ODA'}


def build_json(path = PATH, profiles = PROFILES, metrics = METRICS, new_names = NEW_METRIC_NAMES):

    # Read .csv
    df = pd.read_csv(path)

    # Filter to only use the metrics we need
    df_filt = df[df['Metric'].isin(metrics)]

    # Filter for EU countries, group them all together, and create EU subtotal
    EU = df_filt[(df_filt['Donor_EU_Country'] == 'EU') & (df_filt['Donor'] != 'EU Institutions') & (df_filt['Data_type'] != 'National currency')]
    EU = EU.groupby(['Donor_EU_Country','Time_Period','Metric','Data_type'], as_index=False).agg({'Value': 'sum'})
    EU['Donor'] = 'EU Countries'

    # Bind the EU country subtotals to the main list
    df_filt = df_filt.append(EU).reset_index()

    # Filter to only those donors in the profiles list and only metrics in the metrics list
    df_filt = df_filt[df_filt['Donor'].isin(profiles)]
    df_filt = df_filt[df_filt['Metric'].isin(metrics)]

    # Drop certain columns and null values
    df_filt = df_filt.drop(['Donor_DAC_Country', 'as_of_date', 'Donor_EU_Country', 'Donor_Group_Type'], axis=1)

    ## Calculate YoY percentage change for certain metrics
    # Create a subset with only the metrics that are relevant
    df_yoy = df_filt[df_filt['Metric'].isin(['Total_ODA_ONE', 'LDC_ODA', 'Africa_ODA', 'IA82_In_Donor_Refugee_Cost'])]
    df_yoy = df_yoy.pivot_table(index=['Data_type', 'Donor', 'Time_Period'], columns='Metric', values='Value').reset_index()
    df_yoy['Africa_ODA_YoY_Percent'] = df_yoy.sort_values('Time_Period').groupby(
        ['Data_type','Donor']).Africa_ODA.pct_change()
    df_yoy['LDC_ODA_YoY_Percent'] = df_yoy.sort_values('Time_Period').groupby(
        ['Data_type', 'Donor']).LDC_ODA.pct_change()
    df_yoy['All_ODA_YoY_Percent'] = df_yoy.sort_values('Time_Period').groupby(
        ['Data_type', 'Donor']).Total_ODA_ONE.pct_change()
    df_yoy['In_Donor_Refugee_YoY_Percent'] = df_yoy.sort_values('Time_Period').groupby(
        ['Data_type', 'Donor']).IA82_In_Donor_Refugee_Cost.pct_change()


    # Reshape data to be long
    df_yoy_long = df_yoy.melt(id_vars=['Data_type','Donor','Time_Period'], value_vars=[
        'Africa_ODA','LDC_ODA','Total_ODA_ONE','IA82_In_Donor_Refugee_Cost','Africa_ODA_YoY_Percent',
        'LDC_ODA_YoY_Percent','All_ODA_YoY_Percent',
        'In_Donor_Refugee_YoY_Percent'], var_name='Metric', value_name='Value')

    ## Add Ratio Calculations
    # Make data set 'wide' to calculate ratios
    df_wide = df_filt.pivot_table(index=['Data_type','Donor','Time_Period'],
                                  columns='Metric', values='Value')

    # Calculate ratios
    df_wide['All_ODA_Over_GNI'] = (df_wide['Total_ODA_ONE']/df_wide['GNI']).where(df_wide['GNI'] != 0)
    df_wide['LDC_ODA_Over_GNI'] = (df_wide['LDC_ODA'] / df_wide['GNI']).where(df_wide['GNI'] != 0)
    df_wide['LDC_ODA_Over_All_ODA'] = df_wide['LDC_ODA'] / df_wide['Total_ODA_ONE']
    df_wide['Africa_ODA_Over_All_ODA'] = df_wide['Africa_ODA'] / df_wide['Total_ODA_ONE']
    df_wide['All_ODA_Excl_Refugee_Costs'] = df_wide['Total_ODA_ONE'] - df_wide['IA82_In_Donor_Refugee_Cost']
    df_wide['All_ODA_Excl_Refugee_Costs_Over_GNI'] = (df_wide['All_ODA_Excl_Refugee_Costs']/df_wide['GNI']).where(df_wide['GNI'] != 0)
    df_wide['In_Donor_Refugee_Over_GNI'] = (df_wide['IA82_In_Donor_Refugee_Cost'] / df_wide['GNI']).where(
        df_wide['GNI'] != 0)
    df_wide['In_Donor_Refugee_Over_All_ODA'] = df_wide['IA82_In_Donor_Refugee_Cost'] / df_wide['Total_ODA_ONE']

    # Reshape data to be long
    df_long = df_wide.stack(level = 'Metric').reset_index()

    # Rename Value column
    df_long.rename(columns={0: 'Value'}, inplace=True)

    # Append percentage change
    df_long = df_long.append(df_yoy_long)

    # Drop nulls
    df_long = df_long.dropna()

    # Replace infinities
    df_long = df_long.replace([np.inf, -np.inf], "Infinity")

    # Drop rows with GNI for EU Institutions since this doesn't exist
    df_long = df_long[~(df_long['Donor'] == 'EU Institutions') | ~(df_long['Metric'] == 'GNI')]

    # Replace metric values with pretty names
    df_long['Metric'].replace(new_names, inplace=True)

    # Group by donor and then create a dictionary with all records within each donor
    record_dict = df_long.groupby(['Donor'])
    record_dict = record_dict.apply(lambda x: x.to_dict(orient='record'))
    record_dict = record_dict.to_dict()

    dict = {}
    dict['data'] = record_dict

    return dict


def run():
    print('Reading and reshaping data')
    final_json = build_json()

    print('Writing JSON file')
    with open('country_profiles.json', 'w') as outfile:
        json.dump(final_json, outfile, indent=4, separators=(',', ': '), ensure_ascii=True, sort_keys=True)


if __name__ == "__main__":
    run()