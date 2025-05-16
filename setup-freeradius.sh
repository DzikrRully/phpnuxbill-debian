#!/bin/bash

set -e

# Path variables
MODS_AVAILABLE=/etc/freeradius/3.0/mods-available
MODS_ENABLED=/etc/freeradius/3.0/mods-enabled
SITES_ENABLED=/etc/freeradius/3.0/sites-enabled/default

# Enable SQL module
ln -sf ${MODS_AVAILABLE}/sql ${MODS_ENABLED}/sql

# Configure SQL module for MySQL and PHPNuxBill DB
sed -i 's/^.*driver = "rlm_sql_.*"/driver = "rlm_sql_mysql"/' ${MODS_AVAILABLE}/sql
sed -i 's/^.*dialect = ".*"/dialect = "mysql"/' ${MODS_AVAILABLE}/sql

# Inject database settings
sed -i 's/^.*server = ".*"/        server = "mysql"/' ${MODS_AVAILABLE}/sql
sed -i 's/^.*login = ".*"/        login = "phpnuxbill"/' ${MODS_AVAILABLE}/sql
sed -i 's/^.*password = ".*"/        password = "phpnuxbillpass"/' ${MODS_AVAILABLE}/sql
sed -i 's/^.*radius_db = ".*"/        radius_db = "phpnuxbill_db"/' ${MODS_AVAILABLE}/sql

# Enable SQL in default site config
for section in authorize accounting session; do
  sed -i "/^${section}/,/^}/{s/^(\s*)#?(\s*)sql/\1sql/}" $SITES_ENABLED
done

# Restart FreeRADIUS (supervisor handles this if running)
echo "FreeRADIUS SQL setup completed."
