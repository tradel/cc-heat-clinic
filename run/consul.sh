#!/bin/bash -e

cd /etc/consul.d 
mv available/server.json .

systemctl enable consul
systemctl start consul

consul intention create -deny '*' '*'
consul intention create -allow app db
consul intention create -allow admin db
consul intention create -allow web app
consul intention create -allow web admin 
