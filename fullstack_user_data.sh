#!/bin/bash
yum update -y
yum install -y git docker

systemctl start docker
systemctl enable docker

# Kloniraj GitHub repozitorij
cd /home/ec2-user
git clone ${git_repo_url} app

cd app

# Postavi ENV varijable (za backend)
echo "DB_HOST=${db_host}" >> .env
echo "DB_NAME=${db_name}" >> .env
echo "DB_USER=${db_username}" >> .env
echo "DB_PASS=${db_password}" >> .env

# Pokreni Docker
docker compose up -d
