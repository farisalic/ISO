#!/bin/bash

# Logovanje svih izlaza
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting user data script..."

# Update sistema
yum update -y

# Instalacija Docker-a
yum install -y docker git
systemctl start docker
systemctl enable docker

# Instalacija docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Dodavanje ec2-user u docker grupu
usermod -aG docker ec2-user

# Kreiranje direktorijuma za aplikaciju
mkdir -p /home/ec2-user/app
cd /home/ec2-user

# Kloniranje repozitorijuma
echo "Cloning repository..."
git clone ${git_repo_url} app
cd app

# Kreiranje .env fajla
cat <<EOF > .env
POSTGRES_DB=notesdb
POSTGRES_USER=user
POSTGRES_PASSWORD=password
EOF

# Čekanje da se EBS volumen priključi
echo "Waiting for EBS volume..."
while [ ! -e /dev/xvdf ]; do
  sleep 5
done

# Formatiranje i montiranje EBS volumena
echo "Setting up EBS volume..."
file -s /dev/xvdf | grep -q "/dev/xvdf: data" && mkfs.ext4 /dev/xvdf

mkdir -p /mnt/notes-db
mount /dev/xvdf /mnt/notes-db

# Dodavanje u fstab za automatsko montiranje
echo '/dev/xvdf /mnt/notes-db ext4 defaults,nofail 0 2' >> /etc/fstab

# Postavljanje dozvola
chown -R ec2-user:ec2-user /mnt/notes-db
chown -R ec2-user:ec2-user /home/ec2-user/app

# Kreiranje potrebnih direktorijuma
mkdir -p /mnt/notes-db/postgresql/data

# Ažuriranje docker-compose.yml fajla da koristi EBS mount
# Ovo možete prilagoditi prema vašoj strukturi

echo "Starting Docker Compose..."
cd /home/ec2-user/app

# Pokretanje docker-compose kao ec2-user
sudo -u ec2-user docker-compose up -d

echo "User data script completed successfully"