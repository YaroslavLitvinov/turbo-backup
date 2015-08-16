#!/bin/bash

source `dirname $(readlink -f $0)`/source.sh

###################################################
echo "case 1: update repo is expected"
mysqldump -uroot -p1q2w3e --databases $DBNAME > /tmp/foo
mysql test -uroot -p1q2w3e --execute="create table if not exists temp (id int);"
mysql test -uroot -p1q2w3e --execute="insert into temp values(2);"
$TURBO_BACKUP_FOLDER/backup_run.sh $DBNAME

###################################################
echo "case 2: restore DB from repo is expected"
mysql $DBNAME_TEST -uroot -p1q2w3e < /tmp/foo
$TURBO_BACKUP_FOLDER/backup_run.sh $DBNAME
rm -f /tmp/foo

###################################################
echo "case 3: nothing"
$TURBO_BACKUP_FOLDER/backup_run.sh $DBNAME

