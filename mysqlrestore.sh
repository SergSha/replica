#!/bin/bash

# Select latest mysql backup directory
lastmysqlbackup=$(ls -l -t /root/mysqlbackup/ | grep ^d | head -1 | awk '{print $9}')
echo $lastmysqlbackup
lastmysqlbackuppath="/root/mysqlbackup/$lastmysqlbackup"
echo $lastmysqlbackuppath

for db in $(ls -1 $lastmysqlbackuppath);
  do
  /usr/bin/mysql --login-path=backup -e "CREATE DATABASE $db; use $db;"
  for tbl in $(ls -1 $lastmysqlbackuppath/$db);
    do
    echo "--> $db/$tbl restoring...";
    zcat $lastmysqlbackuppath/$db/$tbl | /usr/bin/mysql --login-path=backup $db;
    done
  done

