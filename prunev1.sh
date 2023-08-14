#!/bin/bash

# Stop and remove running containers
running_containers=$(docker ps -q)
if [ ! -z "$running_containers" ]; then
  docker stop $running_containers
  docker rm $running_containers
fi

# Remove all Docker images
docker rmi $(docker images -q) 2>/dev/null

# Perform Docker system prune
docker system prune -af

if [ $? -eq 0 ]; then
  echo "Docker system prune completed successfully."
else
  echo "Docker system prune encountered an error."
fi

# Remove unwanted files
echo "Removing unwanted files"
sudo rm -rf spring-boot-mysql-docker-compose docker-compose.yml
echo "Removal succeeded"

# List Docker images
docker images

# List Docker containres
docker ps -a

#Purge completed message
echo "All Docker containers stopped and purged all containers and Images"
