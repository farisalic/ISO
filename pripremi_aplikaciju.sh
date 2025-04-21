#!/bin/bash

echo "Priprema aplikacije..."

# Kreiraj db/init.sql ako ne postoji
if [ ! -f "./db/init.sql" ]; then
  echo "⚠️  Kreira se db/init.sql..."
  mkdir -p db
  cat <<EOL > ./db/init.sql
CREATE TABLE IF NOT EXISTS notes (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL
);
EOL
fi

# Provjera .env fajla
if [ ! -f ".env" ]; then
  echo ".env fajl ne postoji. Kreira se..."
  cat <<EOL > .env
POSTGRES_DB=notesdb
POSTGRES_USER=user
POSTGRES_PASSWORD=password
EOL
fi

echo "Priprema završena!"
