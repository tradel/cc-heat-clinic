#!/bin/bash -e

cd /etc/consul.d 
mv available/server.json .

systemctl enable consul
systemctl start consul

echo "Waiting for Consul to start..."
while [[ -z $(curl -fsSL localhost:8500/v1/status/leader) ]]
do
    sleep 1
done 

sleep 3
consul intention create -deny '*' '*'
consul intention create -allow app db
consul intention create -allow admin db
consul intention create -allow web app
consul intention create -allow web admin 
