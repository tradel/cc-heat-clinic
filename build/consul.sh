#!/bin/bash -e

BASE_URL=https://releases.hashicorp.com
PROD_NAME=consul
PROD_ARCH=linux_amd64 
PROD_VERSION=${CONSUL_VERSION:-1.4.4}
PROD_ZIP=${PROD_NAME}_${PROD_VERSION}_${PROD_ARCH}.zip 
PROD_URL=${BASE_URL}/${PROD_NAME}/${PROD_VERSION}/${PROD_ZIP}

# Create a user account to own files
useradd -c "Consul Service Account" -m -r -s /bin/bash consul 

# Fetch the binary and unzip
cd /tmp
curl -fsSL -O ${PROD_URL}
unzip ${PROD_ZIP}

# Install the binary in /usr/local/bin
install -c -m 0755 -o consul -g consul /tmp/consul /usr/local/bin 

# Create config and data directories
install -d -m 0755 -o consul -g consul /data/consul /etc/consul.d

# Install a unit file for systemd
install -c -m 0644 /tmp/systemd/consul.service /etc/systemd/system

# Generate a gossip encryption key
jq -n ".encrypt = \"$(consul keygen)\"" > /tmp/consul.d/gossip.json

# Copy config files into /etc/consul.d
cd /tmp/consul.d
find . -type d -exec install -d -D -m 0755 -o consul -g consul {} /etc/consul.d/{} \;
find . -type f -exec install -c -D -m 0644 -o consul -g consul {} /etc/consul.d/{} \;
