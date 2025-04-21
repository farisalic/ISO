#!/bin/bash

echo "Brišem aplikaciju i sve njene resurse..."

docker compose down --volumes --rmi all --remove-orphans

echo "✅ Sve je obrisano."
