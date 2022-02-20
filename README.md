# replica
# Enter with root
sudo -i

# Rename host
hostnamectl set-hostname replica 

# Edit network setting (Warning: the network card make internal)
vi /etc/sysconfig/network-scripts/ifcfg-enp0s3

# comment line BOOTPROTO="dhcp"
#BOOTPROTO="dhcp"

# add next lines
BOOTPROTO="static"
IPADDR=10.0.1.12
NETMASK=255.255.255.0
GATEWAY=10.0.1.1
DNS1=10.0.1.1
DNS2=8.8.8.8

# Restart host
shutdown -r now

# Enter with root
sudo -i

# Install git
yum -y install git

# Connect to GitHub repo for download to host
git clone https://github.com/SergSha/replica.git

#------- For to upload to GitHub -------------
# Make pair keys
#ssh-keygen #Enter-Enter-Enter
# Copy text of pub key and paste into GitHub:
cat /root/.ssh/id_rsa.pub
#https://github.com/settings/keys
# Connect to GitHub repo (nginx)
#git clone git@github.com:SergSha/replica.git
------------------------------------------------

# Make the file inst_set.sh execute
chmod u+x /root/replica/inst_set.sh

# Start inst_set.sh
/root/replica/inst_set.sh

# Add login for backup MySQL database
mysql_config_editor set --login-path=backup -uroot -p

# Download backup copy databases MySQL
mysql -uroot -p < /root/mydb_all.sql

# Start MySQL command console
mysql -uroot -p

# Stop replica
STOP REPLICA;

# Get public key Attention: BINLOG & MASTER_LOG_POS !!!
CHANGE MASTER TO MASTER_HOST='10.0.1.11', MASTER_USER='repl', MASTER_PASSWORD='Tn91Uk57@', MASTER_LOG_FILE='binlog.000002', MASTER_LOG_POS=688, GET_MASTER_PUBLIC_KEY = 1;

# Start replica
START REPLICA;

# Get replica status
SHOW REPLICA STATUS\G

# Go to source host to make new databeses for test replication
----------------------------------------------------
# After source host test replication
SHOW DATABASES;
SHOW TABLES FROM cars_db;
SELECT * FROM cars_db.new_cars;
exit;

---------RECOMENDATIONS---------
# Add user for replication MASTER-MASTER
CREATE USER repl@'10.0.1.11' IDENTIFIED WITH 'caching_sha2_password' BY 'Tn91Uk57@';

# Даю пользователю repl права на репликацию
GRANT REPLICATION SLAVE ON *.* TO repl@'10.0.1.11';

В replica в случае клонирования хоста удалить файл
/var/lib/mysql/auto.cnf
затем перезапустить mysqld

# vi /etc/my.cnf
добавляю строки
server_id = 2

и рекомендуется включать для replica, чтобы запретить вносить изменения
innodb_read_only = 1
