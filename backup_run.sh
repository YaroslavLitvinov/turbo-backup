#!/bin/bash

ping github.com -c1 > /dev/null
if [ "$?" != "0" ]
then
echo "Bad internet connection, exiting..."
fi

source `dirname $(readlink -f $0)`/source.sh

###################################################
####LAST_TURBO_BACKUP_FILEPATH defined in ~/.bashrc
###################################################

DBNAME=test

###################################################
####save DB to backup file and then compare it with
####backup file from repository
###################################################

mysqldump -uroot -p1q2w3e --databases $DBNAME > $LAST_TURBO_BACKUP_FILEPATH
#mysqldump -uroot -p1q2w3e --all-databases > $LAST_TURBO_BACKUP_FILEPATH

echo "Saved "`du -bh $LAST_TURBO_BACKUP_FILEPATH`

if [ ! -f $TURBO_BACKUP_FILEPATH ]
then
touch $TURBO_BACKUP_FILEPATH
fi

LAST_FSIZE=`stat -c%s $LAST_TURBO_BACKUP_FILEPATH`
REPO_FSIZE=`stat -c%s $TURBO_BACKUP_FILEPATH`

echo $LAST_FSIZE,$REPO_FSIZE

if [ $LAST_FSIZE -lt $REPO_FSIZE ]
then
echo "restore DB from repo..."
mysql $DBNAME -uroot -p1q2w3e < $TURBO_BACKUP_FILEPATH
cp -fv $TURBO_BACKUP_FILEPATH $LAST_TURBO_BACKUP_FILEPATH

elif [ $REPO_FSIZE -lt $LAST_FSIZE ]
then
echo "save last DB backup into repo..."
let BYTES_ADDED=$LAST_FSIZE-$REPO_FSIZE
COMMIT_MESSAGE="`date \"+%Y-%m-%d %T\"` added $BYTES_ADDED bytes"
echo $COMMIT_MESSAGE
cp -fv $LAST_TURBO_BACKUP_FILEPATH $TURBO_BACKUP_FILEPATH
cd $TURBO_BACKUP_FOLDER

git config --global user.name "Yaroslav Litvinov"
git config --global user.email "yaroslav.litvinov@gmail.com"
git add $TURBO_BACKUP_FILEPATH
git commit -m "$COMMIT_MESSAGE"
git push origin master

elif [ $REPO_FSIZE -eq $LAST_FSIZE ]
then
echo "backup not changed"
fi
