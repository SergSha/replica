#!/bin/bash

# Update from GitHub
cd /root/replica/
git pull origin main

# Update index.html in /var/www/html/
cp -f /root/replica/index.html /var/www/html/

# Reload httpd configs
systemctl reload httpd
