#!/bin/bash -e

cd /etc/consul.d 
mv available/server.json .

systemctl enable consul
systemctl start consul
