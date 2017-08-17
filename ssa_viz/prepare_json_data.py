import pandas as pd
import json

INFILE_CHART_1 = 'data/1.csv'
OUTFILE_CHART_1 = 'data/1.json'

INFILE_CHART_2 = 'data/2.csv'
OUTFILE_CHART_2 = 'data/2.json'

INFILE_CHART_3 = 'data/3.csv'
OUTFILE_CHART_3 = 'data/3.json'


def create_json(infile=INFILE_CHART_1, outfile=OUTFILE_CHART_1):
    """
    Given a csv created by the original xls file, generate a json with a data
    structure compatible for the d3 charts.
    """

    df = pd.read_csv(infile)

    # Transpose
    df = df.T

    # Remove extra header
    df.columns = df.iloc[0]
    df = df[1:]

    # Create year col
    df['Year'] = df.index

    # Group by year
    grouped_by_year = list(df.groupby('Year'))

    # Loop over the years and create one dict per year
    chart_array = []
    for y in grouped_by_year:
        year_dict = y[1].to_dict('records')[0]
        chart_array.append(year_dict)

    # Create json
    with open(outfile, 'w') as outfile_json:
        json.dump(chart_array, outfile_json)

    print(outfile + ' was created')


create_json(infile=INFILE_CHART_1, outfile=OUTFILE_CHART_1)
create_json(infile=INFILE_CHART_2, outfile=OUTFILE_CHART_2)
create_json(infile=INFILE_CHART_3, outfile=OUTFILE_CHART_3)
