#!/bin/bash

DIR=/var/lib/mysql/backup
if [ ! -e $DIR ]
then
/bin/mkdir -p $DIR
fi
NOWDATE=$(date +%Y%m%d%H%M%S)
/usr/bin/mysqldump --all-databases --quick --user=root --password=123456 --host=localhost --port=3306 | gzip > "/var/lib/mysql/backup/data_$NOWDATE.sql.gz"

/usr/bin/find $DIR -mtime +7 -name "data_[1-9]*.sql.gz" -exec rm -rf {} \;
