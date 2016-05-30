#!/bin/bash
supervisord -c /etc/supervisor/conf.d/supervisord.conf > /dev/null 2>&1 &

phpenmod mcrypt
phpenmod mbstring

echo "Waiting for MySQL"
service mysql start
until [ mysql ]; do
  printf "."
  sleep 1
done
echo -e "\nMySQL ready"
mysql --user=root --password=root -v -e "set global sql_mode=''"
echo "Downloading Claroline Connect"
mkdir -p /var/www/html/claroline
cd /var/www/html/claroline
wget http://travis.claroline.net/preview/$BUILD.tar.gz
echo "Decompressing Claroline Connect"
tar -xzf $BUILD.tar.gz
rm $BUILD.tar.gz
echo "Setting up parameters.yml"
sed -i "s/database_password: ~/database_password: root/g" /var/www/html/claroline/app/config/parameters.yml
echo "Installing composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
echo "Installing Claroline Connect"
composer fast-install
echo "Creating admin user"
php app/console claroline:user:create -a John Doe admin pass admin@test.com
echo "Setting permissions"
chmod -R 777 /var/www/html/claroline/app/cache /var/www/html/claroline/app/logs /var/www/html/claroline/app/config /var/www/html/claroline/app/sessions /var/www/html/claroline/files /var/www/html/claroline/web/uploads
#echo "Warming cache"
#php /var/www/html/claroline/app/console cache:warmup --env=prodphp /var/www/html/claroline/app/console cache:warmup --env=prod
rm /var/www/html/claroline/web/app_dev.php
mv /tmp/app_dev.php /var/www/html/claroline/web
a2ensite claroline.conf
service apache2 restart
echo "Done"

bash
