#!/bin/bash

MYSQL="/usr/bin/mysql --login-path=backup --skip-column-names"
MYSQLDUMP="/usr/bin/mysqldump --login-path=backup --single-transaction --source-data=2"
mysqlbackuppath=/root/mysqlbackup

for db in $($MYSQL -e "SHOW DATABASES LIKE '%_db'");
  do
  mkdir -p /$mysqlbackuppath/$db;
  for tbl in $($MYSQL -e "SHOW TABLES FROM $db");
    do
    $MYSQLDUMP $db $tbl > /$mysqlbackuppath/$db/$tbl.sql;
    done
done
