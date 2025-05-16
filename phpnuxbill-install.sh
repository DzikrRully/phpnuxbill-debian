#!/bin/bash

set -e

echo "Downloading PHPNuxBill..."
curl -L -o phpnuxbill.zip https://github.com/DzikrRully/phpnuxbill/archive/refs/heads/master.zip

echo "Extracting PHPNuxBill..."
unzip phpnuxbill.zip
mv phpnuxbill-master/* /var/www/html/

echo "Cleaning up installation files..."
rm -rf phpnuxbill.zip phpnuxbill-master

echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "PHPNuxBill installation complete."
