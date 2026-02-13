#!/bin/bash

set -e

echo "🚀 Starting ETL Pipeline"
echo "======================================"

# Execute extract phase
./extract.sh

# Execute transform phase
./transform.sh

# Execute load phase
./load.sh

echo ""
echo "🎉 ETL Pipeline completed successfully!"
echo "======================================"