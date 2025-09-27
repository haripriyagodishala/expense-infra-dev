#!/bin/bash
# Wait until network is ready


# # Get public IP
# PUB_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# # Set OpenVPN to use public IP in client config
# /usr/local/openvpn_as/scripts/sacli --key "host.name" --value "$PUB_IP" ConfigPut

# # Restart OpenVPN AS to apply changes
# /usr/local/openvpn_as/scripts/sacli start

exec > /var/log/user-data.log 2>&1
set -eux

SCRIPTS="/usr/local/openvpn_as/scripts"
USERNAME="openvpn"
PASSWORD='Priya@123' 

sleep 10

$SCRIPTS/sacli --user "$USERNAME" --new_pass "$PASSWORD" SetLocalPassword

echo "Starting OpenVPN public IP config script..."

PUB_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Public IP is $PUB_IP"

/usr/local/openvpn_as/scripts/sacli --key "host.name" --value "$PUB_IP" ConfigPut
/usr/local/openvpn_as/scripts/sacli start