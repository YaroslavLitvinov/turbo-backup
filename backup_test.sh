#!/bin/bash

source `dirname $(readlink -f $0)`/source.sh

mysqldump -uroot -p1q2w3e --databases $DBNAME_TEST > /tmp/foo

mysql test -uroot -p1q2w3e --execute="create table if not exists temp (id int);"
mysql test -uroot -p1q2w3e --execute="insert into temp values(2);"

echo "case 1: update repo is expected"
$TURBO_BACKUP_FOLDER/backup_run.sh

mysql $DBNAME_TEST -uroot -p1q2w3e < /tmp/foo

echo "case 2: restore DB from repo is expected"
$TURBO_BACKUP_FOLDER/backup_run.sh

echo "case 3: nothing"
$TURBO_BACKUP_FOLDER/backup_run.sh

