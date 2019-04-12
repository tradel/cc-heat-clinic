#!/bin/bash -e

BASE_URL=https://releases.hashicorp.com
PROD_NAME=vault
PROD_ARCH=linux_amd64 
PROD_VERSION=${VAULT_VERSION:-1.1.0}
PROD_ZIP=${PROD_NAME}_${PROD_VERSION}_${PROD_ARCH}.zip 
PROD_URL=${BASE_URL}/${PROD_NAME}/${PROD_VERSION}/${PROD_ZIP}

# Create a user account to own files
useradd -c "Vault Service Account" -m -r -s /bin/bash vault 

# Fetch the binary and unzip
cd /tmp
curl -fsSL -O ${PROD_URL}
unzip ${PROD_ZIP}

# Install the binary in /usr/local/bin
install -c -m 0755 -o vault -g vault /tmp/vault /usr/local/bin 

# Create config and data directories
install -d -m 0755 -o vault -g vault /data/vault /etc/vault.d /etc/vault

# Install a unit file for systemd
install -c -m 0644 /tmp/systemd/vault.service /etc/systemd/system

# Copy config files into /etc/vault.d
cd /tmp/vault.d
find . -type d -exec install -d -D -m 0755 -o vault -g vault {} /etc/vault.d/{} \;
find . -type f -exec install -c -D -m 0644 -o vault -g vault {} /etc/vault.d/{} \;
