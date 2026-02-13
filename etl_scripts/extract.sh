#!/bin/bash

set -e 

SOURCE_URL="https://gist.githubusercontent.com/kevin336/acbb2271e66c10a5b73aacf82ca82784/raw/e38afe62e088394d61ed30884dd50a6826eee0a8/employees.csv"
DATA_DIR="./data"
RAW_FILE="$DATA_DIR/raw_employee.csv"


echo " ETL Pipeline - Extract Phase"
echo "======================================"

echo "Extracting data from source: $SOURCE_URL"

# create data directory
mkdir -p $DATA_DIR

# Download the data
curl -o "$RAW_FILE" "$SOURCE_URL"

# Check if download was successful
if [ $? -eq 0 ] && [ -f "$RAW_FILE" ]; then
    echo "✅ Data successfully extracted to $RAW_FILE"
    echo "Records extracted: $(tail -n +2 "$RAW_FILE" | wc -l)"
else
    echo "❌ Failed to extract data from source"
    exit 1
fi


