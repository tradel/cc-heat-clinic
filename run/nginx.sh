#!/bin/bash -e

cd /etc/consul.d 
mv available/client.json . 
mv available/service-web.json . 

systemctl enable consul
systemctl start consul

ln -sf /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled 

systemctl enable nginx
systemctl start nginx
