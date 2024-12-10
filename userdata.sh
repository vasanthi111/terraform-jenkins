#!/bin/bash
# Update all packages
yum update -y 

sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

yum install -y docker git MySQL curl
systemctl start docker
systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo usermod -aG docker ec2-user
sudo chmod 666 /var/run/docker.sock
mkdir -p /opt/docker-wordpress
cat <<EOL > /opt/docker-wordpress/docker-compose.yml
version: '3.3'
services:
  db:
    image: mysql:8.0.19
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=wordpress
      - MYSQL_DATABASE=databaseword
      - MYSQL_USER=admin
      - MYSQL_PASSWORD=admin123
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    restart: always
    environment:
      - WORDPRESS_DB_HOST=db:3306  # Explicitly specifying port 3306
      - WORDPRESS_DB_USER=admin
      - WORDPRESS_DB_PASSWORD=admin123
      - WORDPRESS_DB_NAME=databaseword
volumes:
  db_data:
EOL
cd /opt/docker-wordpress
docker-compose up -d
