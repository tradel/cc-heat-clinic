#!/bin/bash -e

cd /etc/consul.d 
mv available/client.json . 
mv available/service-admin.json . 

systemctl enable consul
systemctl start consul

echo "Waiting for Consul to start..."
while [[ -z $(curl -fsSL localhost:8500/v1/status/leader) ]]
do
    sleep 1
done 

echo "Waiting for Connect proxy to register..."
host=$(hostname)
while [[ -z $(consul catalog services -node=$host | grep proxy) ]]
do
    sleep 1 
done

export VAULT_ADDR=http://${VAULT_IP}:8200
json=$(vault kv get -format=json kv/bcl/database)
dbname=$(echo $json | jq -r .data.data.database)
username=$(echo $json | jq -r .data.data.username)
password=$(echo $json | jq -r .data.data.password)

echo "Waiting for MySQL to respond..."
while [[ ! $(/usr/lib/nagios/plugins/check_mysql -H 127.0.0.1 -P 3306 -u ${username} -p ${password}) ]]
do
    sleep 1
done

src=/etc/consul-template/common-shared.properties.ctmpl
dest=/opt/DemoSite/core/src/main/resources/runtime-properties/common-shared.properties

consul-template -once \
    -consul-addr=http://localhost:8500 \
    -vault-addr=http://${VAULT_IP}:8200 \
    -vault-token=${VAULT_TOKEN} \
    -vault-renew-token=false \
    -template=${src}:${dest}

cd /opt/DemoSite 
mvn install

systemctl enable solr 
systemctl start solr

systemctl enable broadleaf-admin
systemctl start broadleaf-admin
