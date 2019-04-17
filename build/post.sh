#!/bin/bash -e

# Set up environment variables for shells
install -c -m 0644 /tmp/profile.d/*.sh /etc/profile.d

# Clean up packages and APT database. Saves about 100MB from the finished image.
apt-get clean
rm -rf /var/lib/apt/lists/*

# Create a general user account 
useradd -c "Interactive Login Account" -m -r -s /bin/bash demo 
usermod -a -G google-sudoers demo 

# Copy SSH authorized keys to demo user
install -d -m 0700 -o demo -g demo /home/demo/.ssh
install -c -m 0600 -o demo -g demo /tmp/ssh/id_ecdsa.pub /home/demo/.ssh/authorized_keys
install -c -m 0600 -o demo -g demo /tmp/ssh/id_ecdsa /home/demo/.ssh/id_ecdsa
install -c -m 0644 -o demo -g demo /tmp/ssh/id_ecdsa.pub /home/demo/.ssh/id_ecdsa.pub

# Stop MySQL before we shut down the box
systemctl stop mysql 
systemctl disable mysql 

# Stop Solr index server
systemctl stop solr 
systemctl disable solr 

# Clean out cruft in /tmp
rm -rf /tmp/*
