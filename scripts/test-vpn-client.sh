#!/usr/bin/env bash
set -u

CONN="VPN-REMOTE-2174"
SERVER="10.21.74.130"

echo "== Levantar VPN =="
sudo ipsec up "$CONN"

echo
echo "== Estado resumido =="
sudo ipsec statusall | tail -n 25

echo
echo "== Ruta instalada para el servidor =="
ip route get "$SERVER"

echo
echo "== Prueba SSH por VPN =="
ssh "ariel@${SERVER}"
