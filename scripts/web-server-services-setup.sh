#!/usr/bin/env bash
set -euo pipefail

# Script de apoyo para WEB-SV-2174.
# Instala y habilita los servicios utilizados en la práctica.
sudo apt update
sudo apt install -y apache2 openssh-server openssl
sudo ssh-keygen -A
sudo systemctl enable --now ssh
sudo a2enmod ssl
sudo a2ensite default-ssl
sudo apache2ctl configtest
sudo systemctl enable --now apache2
sudo systemctl restart apache2

echo "SSH: $(systemctl is-active ssh)"
echo "Apache: $(systemctl is-active apache2)"
sudo ss -lntp | grep -E ':22|:443' || true
