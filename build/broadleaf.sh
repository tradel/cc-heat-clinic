#!/bin/bash -e

# Install JRE and Maven
apt-get -y install default-jdk maven

# Clone the Broadleaf Commerce code from GitHub
if [ ! -d /opt/DemoSite ]; then
  git clone https://github.com/tradel/DemoSite.git /opt/DemoSite
fi

# Compile and package everything for quick startup
cd /opt/DemoSite
mvn install 

# Install unit files for systemd
install -c -m 0644 /tmp/systemd/broadleaf-site.service /etc/systemd/system
install -c -m 0644 /tmp/systemd/broadleaf-admin.service /etc/systemd/system
