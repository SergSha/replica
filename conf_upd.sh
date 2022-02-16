#!/bin/bash

# Update from GitHub
cd /root/replica/
git pull origin main

# Update index.html in /var/www/html/
cp -rf /root/replica/html/* /var/www/html/

# Reload httpd configs
systemctl reload httpd
