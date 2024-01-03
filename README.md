# NSW property sales prices by suburb and postcode

## Introduction

This repository contains scripts and results for a analysis of residential property sales in New South Wales (NSW), Australia, on a yearly basis. The data is organised by suburb and postcode, and the results are stored as CSV files in the `/csv` directory.

The output includes the 0th, 25th, 50th (median), 75th, and 100th percentile purchase prices for each suburb and postcode. An example of the output format is as follows:

`csv/property.residential.nsw.postcode.2023.csv`

```csv
postcode,0p,25p,50p,75p,100p,count
2000,500.0,840000.0,1260000.0,2125000.0,25500000.0,831
2007,16500.0,280000.0,810000.0,1129000.0,2360000.0,217
2008,260000.0,630000.0,855000.0,1350000.0,21800000.0,205
2009,22000.0,763125.0,1229500.0,2200000.0,16150000.0,286
2010,6700.0,774250.0,1141500.0,1829750.0,31000000.0,758
```

`csv/property.residential.nsw.suburb.2023.csv`

```csv
suburb,0p,25p,50p,75p,100p,count
ABBOTSBURY,445000.0,1305000.0,1480000.0,1755000.0,2661000.0,33
ABBOTSFORD,425000.0,1188750.0,1754744.5,3072500.0,9100000.0,98
ABERCROMBIE,470000.0,631000.0,675000.0,785000.0,1100000.0,17
ABERDARE,70000.0,442500.0,540000.0,600000.0,905000.0,43
ABERDEEN,2674.0,327500.0,435000.0,566875.0,1250000.0,38
```

## License

This project is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

The data used in this project is derived from the [Bulk property sales information](https://valuation.property.nsw.gov.au/embed/propertySalesInformation) provided by the [Crown in right of NSW through the Valuer General](https://www.valuergeneral.nsw.gov.au/copyright) 2024.

## How to use

To analyse the data for a specific year, use the generate.sh script followed by the year as an argument. For example, `./generate.sh 2023` will analyze the data for the year 2023. The wget statement in the script can be uncommented to download the ZIP file directly from the Valuer General's website.

The `parse-by.py` script is a Python script that calculates the percentiles and counts for each suburb and postcode using Python, pandas, and numpy.

To run the analysis for all years from 1990 to 2023, use the following command:

```bash
for year in {1990..2023}; do bash generate.sh $year; done
```
