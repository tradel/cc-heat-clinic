#!/bin/bash -e

# Install some useful tools
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y apt-transport-https ca-certificates curl unzip software-properties-common git jq
