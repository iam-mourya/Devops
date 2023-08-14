#!/bin/bash

# Store the result of variable
DOCKER_COMPOSE_PATH="/home/ubuntu/docker/dockercompose"
REPO_PATH="$DOCKER_COMPOSE_PATH/spring-boot-mysql-docker-compose"
TARGET_DIR="$REPO_PATH/target"

# Create the Docker-Compose directory if it doesn't exist and navigate to it
mkdir -p $DOCKER_COMPOSE_PATH
cd $DOCKER_COMPOSE_PATH || exit

# Clone the GitHub repository if it doesn't exist
if [ ! -d "$REPO_PATH" ]; then
  git clone https://github.com/ashokitschool/spring-boot-mysql-docker-compose.git "$REPO_PATH"
fi

chmod -R 755 spring-boot-mysql-docker-compose

# Navigate to the cloned repository and build the Maven project
cd "$REPO_PATH" || exit
mvn clean package

# Navigate to the target directory and build the Docker image
#cd "$REPO_PATH" || exit

sudo docker build -t spring-boot-mysql-app .

# Wait for a while before proceeding
sleep 40s

echo "Proceeding to create docker-compose.yml file"

# Change directory back to script path
cd "$DOCKER_COMPOSE_PATH" || exit

# Create a Docker Compose file
cat <<EOT >> docker-compose.yml
version: "3"
services:
  application:
    image: spring-boot-mysql-app
    ports:
      - "8080:8080"
    networks:
      - springboot-db-net
    depends_on:
      - mysqldb
    volumes:
      - /data/springboot-app
  mysqldb:
    image: mysql:5.7
    networks:
      - springboot-db-net
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=sbms
    volumes:
      - /data/mysql
networks:
  springboot-db-net:
EOT

# Make the Docker Compose file executable
chmod +x docker-compose.yml

# Start the Docker Compose setup in detached mode
sudo docker-compose up -d

# Display the result of "docker-compose ps"
docker-compose ps
