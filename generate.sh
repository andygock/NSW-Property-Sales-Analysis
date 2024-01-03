# check argument $1 exist, if not, quit
if [ -z "$1" ]; then
  echo "No year argument supplied"
  exit 1
fi

# if 'data/' does not exist, create it
if [ ! -d "data" ]; then
  mkdir data
fi

# same with 'csv/'
if [ ! -d "csv" ]; then
  mkdir csv
fi

# get year
year=$1

# check year is a 4 digit number
if ! [[ $year =~ ^[0-9]{4}$ ]]; then
  echo "Year must be a 4 digit number"
  exit 1
fi

# download zip file if needed from Valuer General
# wget https://www.valuergeneral.nsw.gov.au/__psi/yearly/{year}.zip

# if ${year}.residence.txt does not already exist, create it
if [ ! -f "data/${year}.residence.txt" ]; then
  # extract to subdir $year and enter it
  unzip ${year}.zip -d $year
  cd $year

  # unzip all zip files, if any
  for z in *.zip; do unzip -o "$z"; done

  # concatenate all DAT files into one, strip all double quotes
  find . -name "*.DAT" -exec cat {} \; | tr -d '"' >"../data/${year}.concat.txt"

  # extract only the residence data, only for 2001 and later
  if [ "$year" -ge 2001 ]; then
    cat "../data/${year}.concat.txt" | grep "^B;" | grep "RESIDENCE" >"../data/${year}.residence.txt"
  fi

  # for year 2000 and earlier, concat as-is
  if [ "$year" -le 2000 ]; then
    # filter only lines starting with "B;" and ending with "A;;;;"
    cat "../data/${year}.concat.txt" | grep "^B;" | grep "A;;;;" >"../data/${year}.residence.txt"
  fi

  # remove files no longer needed
  find . \( -name "*.zip" -or -name "*.DAT" -or -name "creative_commons.txt" \) -delete

  # delete all empty subdirs
  find . -type d -empty -delete

  cd ..

  # remove the year subdir
  rm -rf "$year"
fi

# analyse the statistics and generate csv file(s)
python3 ./parse-by.py postcode "./data/${year}.residence.txt" "./csv/property.residential.nsw.postcode.${year}.csv"
python3 ./parse-by.py suburb "./data/${year}.residence.txt" "./csv/property.residential.nsw.suburb.${year}.csv"
