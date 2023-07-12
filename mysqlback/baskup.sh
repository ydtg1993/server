#!/bin/bash

DIR=/var/lib/mysql/backup
if [ ! -e $DIR ]
then
/bin/mkdir -p $DIR
fi
NOWDATE=$(date +%Y%m%d%H%M%S)
/usr/bin/mysqldump --defaults-file=/etc/mysql/conf.d/mysqldump.cnf --all-databases --quick | gzip > "/var/lib/mysql/backup/data_$NOWDATE.sql.gz"

/usr/bin/find $DIR -mtime +7 -name "data_[1-9]*.sql.gz" -exec rm -rf {} \;
