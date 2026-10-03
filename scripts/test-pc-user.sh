#!/usr/bin/env bash
set -u

PUBLIC_HTTPS="21.74.4.2"
PRIVATE_SERVER="10.21.74.130"

echo "== HTTPS debe funcionar SIN VPN =="
curl -k -I --connect-timeout 5 "https://${PUBLIC_HTTPS}" || true

echo
echo "== SSH directo debe quedar bloqueado =="
ssh -o BatchMode=yes -o ConnectTimeout=5 "ariel@${PRIVATE_SERVER}" true || true
