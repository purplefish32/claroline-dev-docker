#!/bin/bash
supervisord -c /etc/supervisor/conf.d/supervisord.conf > /dev/null 2>&1 &

phpenmod mcrypt
phpenmod mbstring
systemctl restart apache2

echo "Waiting for MySQL"
service mysql start
until [ mysql ]; do
  printf "."
  sleep 1
done
echo -e "\nMySQL ready"

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
php -r "if (hash_file('SHA384', 'composer-setup.php') === '92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
echo "Installing Claroline Connect"
composer fast-install
echo "Creating admin user"
php app/console claroline:user:create -a Jhon Doe admin pass admin@test.com
echo "Setting permissions"
chmod -R 777 /var/www/html/claroline/app/cache /var/www/html/claroline/app/logs /var/www/html/claroline/app/config /var/www/html/claroline/app/sessions /var/www/html/claroline/files /var/www/html/claroline/web/uploads
#echo "Warming cache"
#php /var/www/html/claroline/app/console cache:warmup --env=prodphp /var/www/html/claroline/app/console cache:warmup --env=prod
echo "Done"

bash
