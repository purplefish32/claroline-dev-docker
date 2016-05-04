#!/bin/bash
echo "Waiting for MySQL"
until [ mysql --host=claroline-db --user=claroline --password=claroline &> /dev/null ]; do
  printf "."
  sleep 1
done
echo -e "\nMySQL ready"

echo "Installing Claroline"
cd /var/www/html
git clone https://github.com/claroline/Claroline.git claroline
cd /var/www/html/claroline
git checkout monolithic-build
chown -R www-data:www-data app/cache app/logs app/sessions files web/uploads
chmod -R 777 app/cache app/logs app/sessions files web/uploads
cd /var/www/html/claroline/web
rm app_dev.php
wget https://raw.githubusercontent.com/purplefish32/claroline-dev-docker/master/config/app_dev.php
cd /var/www/html/claroline/app/config/
rm parameters.yml
wget https://raw.githubusercontent.com/purplefish32/claroline-dev-docker/master/config/parameters.yml
echo "Running composer"
composer update
composer sync-dev
echo "Creating default user"
php app/console claroline:user:create -a John Doe admin admin jhon.doe@test.com
echo "Done"
npm run webpack
npm run watch
