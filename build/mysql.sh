#!/bin/bash -e

# Pre-set the MySQL password so apt doesn't pop up a password dialog
export MYSQL_PWD="abc123"
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_PWD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_PWD}"

# Install MySQL and the Nagios check script
apt-get -y install mysql-server monitoring-plugins
install -c -m 0644 /tmp/mariadb.conf.d/* /etc/mysql/mariadb.conf.d

systemctl restart mysql

mysql -u root -e "create user if not exists root@'%' identified by 'abc123'"
mysql -u root -e "grant all privileges on *.* to root@'%' with grant option"
mysql -u root -e "grant proxy on '@' to root@'%'"

mysql -u root -e "create database if not exists broadleaf"
mysql -u root -e "create user if not exists broadleaf@'%' identified by 'ech9Weith4Phei7W'"
mysql -u root -e "grant all privileges on broadleaf.* to broadleaf@'%'"

mysql -u root -e "flush privileges"

systemctl stop mysql 
systemctl disable mysql 
