#!/bin/bash

# Create temporary file with current crontab
crontab -l > /tmp/current_cron
# Add task for mysql backup
cat >> /tmp/current_cron << EOF
7 2 * * *   /root/replica/mysqlbackup.sh
EOF
crontab < /tmp/current_cron
# Delete tamporary file
rm -f /tmp/current_cron
