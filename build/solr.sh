#!/bin/bash

# Download Apache Solr and Broadleaf Starter Kit
cd /tmp
curl -fsSL -O https://archive.apache.org/dist/lucene/solr/5.3.1/solr-5.3.1.zip
curl -fsSL -O http://nexus.broadleafcommerce.org/nexus/content/groups/community-releases/com/broadleafcommerce/broadleaf-boot-starter-solr/1.0.2-GA/broadleaf-boot-starter-solr-1.0.2-GA.jar

cd /opt 
unzip -q /tmp/solr-5.3.1.zip
ln -sf solr-5.3.1 solr

cd /tmp
jar xf broadleaf-boot-starter-solr-1.0.2-GA.jar

cd /tmp/solr/standalone/solrhome
find . -type d -exec install -d -D -m 0755 -o consul -g consul {} /opt/solr/server/solr/{} \;
find . -type f -exec install -c -D -m 0644 -o consul -g consul {} /opt/solr/server/solr/{} \;

cd /tmp
rm solr-5.3.1.zip broadleaf-boot-starter-solr-1.0.2-GA.jar

# Install unit files for systemd
install -c -m 0644 /tmp/systemd/solr.service /etc/systemd/system

systemctl daemon-reload 
systemctl start solr 
