import pandas as pd
import sys
import numpy as np

# Get input and output file names from command line arguments
group_by_column = sys.argv[1]
input_file = sys.argv[2]
output_file = sys.argv[3]

# get year from input file name "./data/${year}.residence.txt"
year = int(input_file.split('/')[-1].split('.')[0])

# quit with error, if year extraction fails
if not year:
    print('Error: could not extract year from input file name')
    sys.exit(1)

# Load the CSV file
df = pd.read_csv(input_file, header=None, sep=';', dtype=str)

# Define column indexes based on year
if year >= 2001:
    suburb_idx = 9
    postcode_idx = 10
    price_idx = 15
else:
    suburb_idx = 8
    postcode_idx = 9
    price_idx = 11

group_by_values = df.iloc[:, suburb_idx if group_by_column == 'suburb' else postcode_idx].astype(str)
prices = pd.to_numeric(df.iloc[:, price_idx], errors='coerce')

# Combine into a new DataFrame
data = pd.DataFrame({group_by_column: group_by_values, 'price': prices})

# Drop rows where price is empty in the new DataFrame
data = data[data['price'].notnull()]

# Group by suburb or postcode
grouped = data.groupby(group_by_column)

# Drop groups that have no 'price' values
grouped = grouped.filter(lambda x: x['price'].count() > 0)

# Calculate percentiles for each group
percentiles = grouped.groupby(group_by_column)['price'].apply(
    lambda x: np.percentile(x, [0, 25, 50, 75, 100])).reset_index()

# Count number of instances for each suburb or postcode
counts = grouped.groupby(group_by_column).size().reset_index(name='count')

# Convert the series of arrays to a DataFrame
percentiles_df = pd.DataFrame(percentiles['price'].to_list(), columns=[
                              '0p', '25p', '50p', '75p', '100p'])

# Add the suburb or postcode column to the percentiles DataFrame
percentiles_df[group_by_column] = percentiles[group_by_column]
percentiles_df = pd.merge(percentiles_df, counts, on=group_by_column)

# Reorder the columns
percentiles_df = percentiles_df[[
    group_by_column, '0p', '25p', '50p', '75p', '100p', 'count']]

# Save to new CSV
percentiles_df.to_csv(output_file, index=False)