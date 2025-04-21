#!/bin/bash

echo "Pokretanje aplikacije..."

docker compose up -d --build

echo "Aplikacija je pokrenuta!"
echo "Otvori u browseru: http://localhost:8080"
