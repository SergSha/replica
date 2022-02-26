#!/bin/bash

# Create current folder for backup
date=$(date +'%F_%H-%M-%S')
mysqlbackuppath="/root/mysqlbackup/$date"
mkdir $mysqlbackuppath
MYSQL="/usr/bin/mysql --login-path=backup --skip-column-names"
MYSQLDUMP="/usr/bin/mysqldump --login-path=backup --single-transaction --source-data=2"
/usr/bin/mysql --login-path=backup -e "STOP REPLICA"
for db in $($MYSQL -e "SHOW DATABASES LIKE '%db'");
  do
  mkdir -p $mysqlbackuppath/$db;
  for tbl in $($MYSQL -e "SHOW TABLES FROM $db");
    do
    $MYSQLDUMP $db $tbl | /usr/bin/gzip -c > $mysqlbackuppath/$db/$tbl.sql.gz;
    done
  done
/usr/bin/mysql --login-path=backup -e "START REPLICA"
cd /root/mysqlbackup/
git add -A
git commit -m "Add mysql backup $date"
git push origin main
