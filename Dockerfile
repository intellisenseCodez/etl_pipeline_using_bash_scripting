# Use the official debian image as the base
FROM debian

# Set the working directory inside the container
WORKDIR /etl

# Update the package list and install a sample package (e.g., curl)
RUN apt-get update && apt-get install -y \
    curl \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy ETL scripts
COPY ./etl_scripts/extract.sh /etl/
COPY ./etl_scripts/transform.sh /etl/
COPY ./etl_scripts/load.sh /etl/
COPY ./etl_scripts/run_etl.sh /etl/

# Make scripts executable
RUN chmod +x /etl/*.sh

# run the ETL pipeline
CMD ["./run_etl.sh"]