#!/bin/bash
set -e

echo "Installing PHPNuxBill..."

cd /var/www/html

# Only install if not already installed
if [ ! -f index.php ]; then
  curl -L -o phpnuxbill.zip https://github.com/DzikrRully/phpnuxbill/archive/refs/heads/master.zip
  unzip phpnuxbill.zip
  mv phpnuxbill-master/* .
  rm -rf phpnuxbill.zip phpnuxbill-master

  chown -R www-data:www-data /var/www/html
  chmod -R 755 /var/www/html

  echo "PHPNuxBill installed."
else
  echo "PHPNuxBill already installed, skipping."
fi
