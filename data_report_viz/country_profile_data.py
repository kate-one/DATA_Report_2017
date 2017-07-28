import pandas as pd
import os.path
import json

# Paths
BASE = os.path.abspath(os.path.dirname(__file__))
PATH = '../views/DAC_Combined_Interactive.csv'

# List of donor countries for profiles
PROFILES = ['United States','United Kingdom','Canada','Australia']


def build_json(path = PATH, profiles = PROFILES):

    # Read .csv
    df = pd.read_csv(path)

    # Flter to only those donors in the profiles list
    df_filtered = df[df['Donor'].isin(profiles)]

    # Drop certain columns and null values
    df_filtered = df_filtered.drop(['Donor_DAC_Country', 'as_of_date', 'Donor_EU_Country', 'Donor_Group_Type'], axis=1)
    df_filtered = df_filtered.dropna()


    # Group by donor and then create a dictionary with all records within each donor
    record_dict = df_filtered.groupby(['Donor'])
    record_dict = record_dict.apply(lambda x: x.to_dict(orient='record'))
    record_dict = record_dict.to_dict()

    return record_dict


def run():
    print('Reading and reshaping data')
    final_json = build_json()

    print('Writing JSON file')
    with open('country_profiles.json', 'w') as outfile:
        json.dump(final_json, outfile, indent=4, separators=(',', ': '), ensure_ascii=True, sort_keys=True)


if __name__ == "__main__":
    run()