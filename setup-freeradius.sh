#!/bin/bash
set -e

# Environment vars (should be passed via Docker or Compose)
DB_HOST=${MYSQL_HOST:-mysql}
DB_USER=${MYSQL_USER:-root}
DB_PASS=${MYSQL_PASSWORD:-Dz1kr48791}
DB_NAME=${MYSQL_DATABASE:-phpnuxbill}

echo "Setting up FreeRADIUS to use MySQL..."

MOD_SQL_DIR="/etc/freeradius/3.0/mods-available/sql"

if [ -f "$MOD_SQL_DIR" ]; then
    # Enable sql module
    ln -sf $MOD_SQL_DIR /etc/freeradius/3.0/mods-enabled/sql

    # Replace default config
    sed -i "s|^#.*server = .*|        server = \"$DB_HOST\"|g" $MOD_SQL_DIR
    sed -i "s|^#.*login = .*|        login = \"$DB_USER\"|g" $MOD_SQL_DIR
    sed -i "s|^#.*password = .*|        password = \"$DB_PASS\"|g" $MOD_SQL_DIR
    sed -i "s|^#.*radius_db = .*|        radius_db = \"$DB_NAME\"|g" $MOD_SQL_DIR

    echo "SQL configuration updated for FreeRADIUS."
else
    echo "SQL config file not found: $MOD_SQL_DIR"
    exit 1
fi
