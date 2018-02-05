# DATA_Report_2017

This repo holds scripts used by the ONE Campaign to pull and reshape data on Official Development Assistance (ODA) as published by the OECD.

## Files in Main Directory
- `OECD_Pull_DAC1.R`: this script pulls aid data at the donor level from the OECD's DAC 1 database via the OECD API. It normalises the data and writes a .csv.
- `OECD_Pull_DAC2A.R`: this script pulls aid data at the donor-recipient level from the OECD's DAC 2A database via the OECD API. It normalises the data and writes a .csv.
- `Tableau_View_Country_Profiles_Final_Inputs.R`: Use this script to output a Tableau-friendly data view that consolidates data from the cleaned DAC 1 and DAC 2A .csv files. This is suitable for use after the final data has been updated in the underlying OECD databaes; do not use it for the preliminary release, where key data points come from a separate file.
- `Tableau_View_ODA_by_income_group.R`: This script uses the cleaned DAC 1 and DAC 2A .csv files and outputs a Tableau-friendly .csv which breakdowns donor aid by the income level of the recipient country. This file was used in the 3rd Tableau embed in our [Jan '18 blog](https://www.one.org/international/blog/global-aid-at-all-time-high/) on ODA.

## Files in `data_report_viz`
These scripts create the JSON data file behind the interactive DATA country profiles web app (see the bottom of [this](https://www.one.org/international/data-report-2017/) page), using the outputs of the above scripts as inputs.
- `annotations.json`: this file contains the free text annotations and text fields throughout the web app in three languages (English, German and French).
- `country_profile_data.py`: this script reshapes the Tableau-friendly country profile .csv into a long JSON file with several additional calculations. Input: `DAC_Combined_Interactive.csv`. Output: `country_profiles.json`
- `nest.py`: this script inputs `country_profiles.json` and `annotations.json` and outputs a JSON file that can be ingested by the DATA report web app.

## Files in `dimensions`
This directory contains manually-edited additional dimensions to enrich the raw data from the OECD DAC 1 and DAC 2A databases. They are left-joined on to the raw tables as part of `OECD_Pull_DAC1.R` and `OECD_Pull_DAC2A.R`

## Files in `views`
The outputs of the Tableau_View_ scripts are stored here, including a historical archive.