#!/bin/bash
echo "Waiting for MySQL"
until [ mysql --host=claroline-db --user=claroline --password=claroline &> /dev/null ]; do
  printf "."
  sleep 1
done
echo -e "\nMySQL ready"
echo "Installing Claroline"
composer fast-install
echo "Creating default user"
php app/console claroline:user:create -a John Doe admin admin jhon.doe@test.com
echo "Done"
