#!/bin/bash -e

BASE_URL=https://releases.hashicorp.com
PROD_NAME=consul-template
PROD_ARCH=linux_amd64 
PROD_VERSION=${CONSUL_TEMPLATE_VERSION:-0.19.5}
PROD_ZIP=${PROD_NAME}_${PROD_VERSION}_${PROD_ARCH}.zip 
PROD_URL=${BASE_URL}/${PROD_NAME}/${PROD_VERSION}/${PROD_ZIP}

# Fetch the binary and unzip
cd /tmp
curl -fsSL -O ${PROD_URL}
unzip ${PROD_ZIP}

# Install the binary in /usr/local/bin
install -c -m 0755 -o consul -g consul /tmp/consul-template /usr/local/bin 

# Create config directory
install -d -m 0755 /etc/consul-template 

# Copy config files into /etc/consul-templates
install -c -m 0644 /tmp/consul-templates/* /etc/consul-template 
