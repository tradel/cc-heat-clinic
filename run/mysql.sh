#!/bin/bash -e

cd /etc/consul.d 
mv available/client.json .
mv available/service-db.json .

systemctl enable consul
systemctl start consul

systemctl enable mysql 
systemctl start mysql 
