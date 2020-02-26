#!/bin/bash

. /etc/profile

DIR=/var/lib/mysql/backup
if [ ! -e $DIR ]
then
/bin/mkdir -p $DIR
fi
NOWDATE=$(date +%Y%m%d%H%M%S)
#mysql_config_editor set --login-path=mysqldump --host=localhost --user=root --password
/usr/bin/mysqldump --login-path=mysqldump --all-databases > "/var/lib/mysql/backup/data_$NOWDATE.sql"

/usr/bin/find $DIR -mtime +7 -name "data_[1-9]*.sql.gz" -exec rm -rf {} \;
