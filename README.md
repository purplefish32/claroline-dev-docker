# claroline-dev-docker

This is a script to run the Claroline Docker Dev environment
You need to have docker and docker-compose installed and properly configured
You allso need port 88 to be free on the host server

## Build and run environment then execute bash on claroline-web
```` bash
docker-compose build && docker-compose up -d && docker exec -it claroline-web /bin/bash
````

## Once you are in claroline-web, run claroline install script
```` bash
cd claroline
./install.sh
````

WARNING install.sh is currently buggy/not working, you are better off runing the commands manualy for now.
If you want to exit the claroline-web bash the shortcut is 'ctrl-p,q'

## Destroy environment
```` bash
docker-compose stop claroline-web claroline-db && docker-compose rm -v claroline-web claroline-db
````
