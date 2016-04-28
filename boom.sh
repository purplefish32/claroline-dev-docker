#!/usr/bin/env bash

docker stop claroline-mysql && docker rm claroline-mysql
docker stop claroline-web && docker rm claroline-web

docker run --name claroline-mysql -e MYSQL_ROOT_PASSWORD=toor -d mysql/mysql-server:5.7
docker build -t claroline/distribution . && docker run -p 88:80 --name claroline-web --link claroline-mysql:mysql -d claroline/distribution && docker exec -it claroline-web bash