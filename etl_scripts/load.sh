#!/bin/bash

set -e

DB_NAME="employeedb"                            # Database name
DB_USER="root"                                  # PostgreSQL user
DB_PASSWORD="root"                              # PostgreSQL password
DB_HOST="postgres"                              # database service name
DB_PORT="5432"                                  # The mapped port
CONTAINER_NAME="pg_database"                    # Container name
TRANSFORM_FILE="./data/transform_employee.csv"  # transformed data

echo ""
echo "======================================"
echo " ETL Pipeline - Load Phase"
echo "======================================"

# Check if transform file exists
if [ ! -f "$TRANSFORM_FILE" ]; then
    echo "❌ Transformed data file not found: $TRANSFORM_FILE"
    echo "   Please run transform phase first"
    exit 1
fi


echo ""
echo "PostgreSQL is ready!"


echo "Creating employee table..."

PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" <<EOF
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
    EMPLOYEE_ID INT,
    FIRST_NAME VARCHAR(255),
    LAST_NAME VARCHAR(255),
    EMAIL VARCHAR(255),
    PHONE_NUMBER VARCHAR(20),
    HIRE_DATE DATE,
    JOB_ID VARCHAR(255),
    SALARY INT,
    MANAGER_ID INT,
    DEPARTMENT_ID INT
);
EOF

if [ $? -eq 0 ]; then
    echo "✅ Employee table created successfully"
else
    echo "❌ Failed to create employee table"
    exit 1
fi

echo "Loading CSV data into the table..."

# Load data using \copy command
PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" <<EOF
\copy employee(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,MANAGER_ID,DEPARTMENT_ID) FROM './data/transform_employee.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
EOF


if [ $? -eq 0 ]; then
    echo "✅ Data loaded successfully into employee table"
    
    # Display summary
    echo ""
    echo "Data Summary:"
    echo "-------------"
    PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "
        SELECT 
            COUNT(*) as total_employees,
            COUNT(DISTINCT department_id) as departments,
            AVG(salary) as average_salary,
            MIN(salary) as min_salary,
            MAX(salary) as max_salary
        FROM employee;"
else
    echo "❌ Failed to load data into the table"
    exit 1
fi