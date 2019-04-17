#!/bin/bash -e

cd /etc/consul.d 
mv available/client.json . 
mv available/service-app.json . 

systemctl enable consul
systemctl start consul

src=/etc/consul-template/common-shared.properties.ctmpl
dest=/opt/DemoSite/core/src/main/resources/runtime-properties/common-shared.properties

consul-template -once \
    -consul-addr=http://localhost:8500 \
    -vault-addr=http://${VAULT_IP}:8200 \
    -vault-token=${VAULT_TOKEN} \
    -vault-renew-token=false \
    -template=${src}:${dest}

systemctl enable solr 
systemctl start solr

systemctl enable broadleaf-site
systemctl start broadleaf-site
