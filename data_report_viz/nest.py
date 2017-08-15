import pandas as pd
import json
from pprint import pprint
import random

with open('country_profiles.json') as data_file:
    dataset = json.load(data_file)

data = dataset['data']

# Get country names
countries = data.keys()

nested_data = {}
nested_data['data_one'] = {}

for c in countries:
    print(c)
    print('--------------------')
    obj = {}

    # Create dataframe from country dict
    df = pd.DataFrame(data[c])

    # Group by data type (current / constant / currency values)
    grouped_by_dataType = list(df.groupby('Data_type'))


    datatype_dict = {}
    for x in grouped_by_dataType:

        datatype_obj = {}
        arr = []

        # Group by year
        grouped_by_year = list(x[1].groupby('Time_Period'))

        for y in grouped_by_year:
            # Create and populate dict for every country/datatype/year
            adict = dict(zip(y[1]['Metric'].values, y[1]['Value'].values))
            adict["Time_Period"] = int(y[0])

            # pprint(adict)

            # Select variables
            keys = [
                'All_ODA_Over_GNI',
                'LDC_ODA_Over_All_ODA',
                'Africa_ODA_Over_All_ODA',
                'In_Donor_Refugee_Over_All_ODA',
                'All_ODA',
                'LDC_ODA',
                'Africa_ODA',
                'In_Donor_Refugee_Costs',
                'All_ODA_YoY_Percent',
                'LDC_ODA_YoY_Percent',
                'Africa_ODA_YoY_Percent',
                'In_Donor_Refugee_YoY_Percent',
                'Time_Period'
            ]

            # Check if variable is in keys, otherwise generate random value
            for k in keys:
                if k not in adict.keys():
                    adict[k] = random.random()
                    print(k + ' is not in ' + c)
                    print('***************************************************')

            # Filter out the variables and create new dict
            adict = dict(zip(keys, [adict[k] for k in keys]))
            pprint(adict)

            # Create percenatges of LDC, Africa and in-donor against ODA/GNI
            adict['LDC_ODA_Over_All_ODA_Over_GNI'] = adict['LDC_ODA_Over_All_ODA'] * adict['All_ODA_Over_GNI']
            adict['Africa_ODA_Over_All_ODA_Over_GNI'] = adict['Africa_ODA_Over_All_ODA'] * adict['All_ODA_Over_GNI']
            adict['In_Donor_Refugee_Over_GNI'] = adict['In_Donor_Refugee_Over_All_ODA'] * adict['All_ODA_Over_GNI']


            # Append dict to array
            arr.append(adict)

        # Insert array in data type dict
        datatype_obj[x[0]] = arr

        datatype_dict[x[0]] = datatype_obj[x[0]]

    obj[c] = datatype_dict
    nested_data['data_one'][c] = obj[c]


# Create dummy annotations
nested_data["annotations"] = {}
languages = ['english', 'german', 'french']

for l in languages:
    nested_data["annotations"][l] = {}
    nested_data["annotations"][l]['selector_page'] = {
        "title": "Country profiles",
        "intro_line": "This is an intro line",
        "instructions": "Click on a country to find out more",
        "legend_target_met": "ODA / GNI target met",
        "legend_target_not_met": "ODA / GNI target not met"
    }
    nested_data["annotations"][l]['country_profile_page'] = {
        "country_name": "Country Name",
        "context_chart_title": "Aid over time",
        "context_chart_selector": "Show proportion of aid going to:",
        "context_chart_button_1": "LDC",
        "context_chart_button_2": "AFRICA",
        "context_chart_button_3": "IN-DONOR",
        "target_chart_title": "Targets",
        "target_chart_met": "Target met",
        "target_chart_not_met": "Target not met",
        "key_stats_table_title": "Key statistics",
        "key_stats_table_local_currency": "GBP",
        "key_stats_table_row_1_title": "Global",
        "key_stats_table_row_2_title": "ODA to LDCs",
        "key_stats_table_row_3_title": "ODA to Africa",
        "recommendations_title": "Recommendations",
        "recommendations_1": "This is a sample recommendation 1",
        "recommendations_2": "This is a sample recommendation 2"
    }

    # Country specific variables
    nested_data["annotations"][l]['country_profile_page']['currencies'] = {
        "Australia": "AUD",
        "Canada": "CAD",
        "EU member states": "EUR",
        "EU member institutions": "EUR",
        "France": "EUR",
        "Germany": "EUR",
        "Italy": "EUR",
        "Japan": "JPY",
        "Netherlands": "EUR",
        "Sweden": "SEK",
        "United Kingdom": "GBP",
        "United States": "USD",
    }

    nested_data["annotations"][l]['country_profile_page']['country_names'] = {
        "Australia": "Australia",
        "Canada": "Canada",
        "EU member states": "EU member states",
        "EU member institutions": "EU member institutions",
        "France": "France",
        "Germany": "Germany",
        "Italy": "Italy",
        "Japan": "Japan",
        "Netherlands": "Netherlands",
        "Sweden": "Sweden",
        "United Kingdom": "United Kingdom",
        "United States": "United States",
    }

pprint(nested_data["annotations"] )
#
with open('country_profiles_nested_v2.json', 'w') as outfile:
    json.dump(nested_data, outfile, indent=4, separators=(',', ': '))
