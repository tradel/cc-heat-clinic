#!/bin/bash -e 

apt-get -y install nginx
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled

install -d -m 0755 /etc/nginx/ssl
install -c -m 0644 /tmp/ssl/* /etc/nginx/ssl
install -c -m 0644 /tmp/nginx/* /etc/nginx/sites-available

systemctl stop nginx
systemctl disable nginx