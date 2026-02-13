#!/bin/bash

set -e

RAW_FILE="./data/raw_employee.csv"
TRANSFORM_FILE="./data/transform_employee.csv"

echo ""
echo "======================================"
echo " ETL Pipeline - Transform Phase"
echo "======================================"

# Check if raw file exists
if [ ! -f "$RAW_FILE" ]; then
    echo "❌ Raw data file not found: $RAW_FILE"
    echo "   Please run extract phase first"
    exit 1
fi

echo "Transforming data..."
echo "Original columns: $(head -1 "$RAW_FILE" | tr ',' '\n' | wc -l)"

# Select specific columns (1,2,3,4,5,6,7,8,10,11 - skipping commission_pct column 9)
cut -d, -f1,2,3,4,5,6,7,8,10,11 "$RAW_FILE" > "./data/transform_employee.csv"

# Clean up data - remove any extra spaces or quotes
sed -i 's/ //g' "$TRANSFORM_FILE"
sed -i 's/-//g' "$TRANSFORM_FILE"


# Convert date format from JAN to 01, FEB to 02 ...
sed -i 's/-JAN-/-01-/g' "$TRANSFORM_FILE"
sed -i 's/-FEB-/-02-/g' "$TRANSFORM_FILE"
sed -i 's/-MAR-/-03-/g' "$TRANSFORM_FILE"
sed -i 's/-APR-/-04-/g' "$TRANSFORM_FILE"
sed -i 's/-MAY-/-05-/g' "$TRANSFORM_FILE"
sed -i 's/-JUN-/-06-/g' "$TRANSFORM_FILE"
sed -i 's/-JUL-/-07-/g' "$TRANSFORM_FILE"
sed -i 's/-AUG-/-08-/g' "$TRANSFORM_FILE"
sed -i 's/-SEP-/-09-/g' "$TRANSFORM_FILE"
sed -i 's/-OCT-/-10-/g' "$TRANSFORM_FILE"
sed -i 's/-NOV-/-11-/g' "$TRANSFORM_FILE"
sed -i 's/-DEC-/-12-/g' "$TRANSFORM_FILE"

# Add 20 to year (convert 02 to 2002, 07 to 2007, etc.)
sed -i 's/,\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\),/,\1-\2-20\3,/g' "$TRANSFORM_FILE"

# Transform to YYYY-MM-DD format 
sed -i 's/,\([0-9]\{2\}\)-\([0-9]\{2\}\)-\(20[0-9]\{2\}\),/,\3-\2-\1,/g' "$TRANSFORM_FILE"

echo "✅ Data transformation completed"
echo "Transformed file: $TRANSFORM_FILE"
echo "Records transformed: $(tail -n +2 "$TRANSFORM_FILE" | wc -l)"