#!/bin/bash -e

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

# Start the application and populate the MySQL database
cd /opt/DemoSite/site 
mvn spring-boot:start 

# Stop the app. We should be able to do "mvn spring-boot:stop" here, but it
# complains and I haven't figured it out.
pkill java 
