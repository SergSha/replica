#!/bin/bash

# Run as root?
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
else

# Firewalld stop
systemctl disable firewalld
systemctl stop firewalld

# Install apache
yum -y install httpd

# Add index.html to path /var/www/html/
cp -f /root/replica/index.html /var/www/html/

# Add conf_upd.sh to cron.daily
cp -f /root/replica/conf_upd.sh /etc/cron.daily/

# Start httpd
systemctl start httpd

# Autorun httpd
systemctl enable httpd

# httpd status
systemctl status httpd

# Install MySQL
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-5.noarch.rpm
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
yum -y --enablerepo=mysql80-community install mysql-community-server

# Set server_id = 2
mv -f /etc/my.cnf{,.old}
cp -f /root/replica/my.cnf /etc/

# Start mysqld
systemctl start mysqld

# Autorun mysqld
systemctl enable mysqld

# mysqld status
systemctl status mysqld

# Port 3306
ss -ntlp | grep 3306

# Get a temporary root password 
grep "A temporary password" /var/log/mysqld.log

# Start mysql secure installation
mysql_secure_installation

fi
