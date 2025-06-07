#!/bin/bash
apt-get update
apt-get install -y docker.io git

systemctl start docker
systemctl enable docker

usermod -aG docker ubuntu

cd /home/ubuntu
git clone https://github.com/farisalic/ISO.git app
cd app

cat <<EOF > /home/ubuntu/app/.env
POSTGRES_DB=notesdb
POSTGRES_USER=user
POSTGRES_PASSWORD=password
EOF

# Mount EBS for DB
mkfs.ext4 /dev/sdf
mkdir /mnt/notes-db
mount /dev/sdf /mnt/notes-db
chown -R ubuntu:ubuntu /mnt/notes-db

# Update docker-compose volume mapping (if needed)
# You can mount /mnt/notes-db in the compose file or link it via symlink

docker-compose up -d
