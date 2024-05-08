#!/bin/bash

# Wait until MySQL is up and accepting connections
until mysqladmin ping -h"mysql" -u"admin" -p"admin" -P"3306" --silent; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 5  # Wait for 5 seconds before retrying
done

>&2 echo "MySQL is up - continuing"
# Execute the FastAPI application command
exec "$@"
