# claroline-dev-docker

This is a script to run the Claroline Docker Dev environment
You need to have docker and docker-compose installed and properly configured
You also need port 99 to be free on the host server

# building the image
sudo docker build -t claroline .

#running the container
sudo docker run -i --rm -e "BUILD=pr-352-1463998021" -p 99:80 -t claroline
