###################################################
if [ $# -ne 1 ]
then
echo "'dbname' parameter is expected"
exit
fi
DBNAME=$1
###################################################

export TURBO_REPO_NAME=turbo-backup
export TURBO_BACKUP_FOLDER=~/git/$TURBO_REPO_NAME
export TURBO_BACKUP_FILEPATH=$TURBO_BACKUP_FOLDER/backup-$DBNAME.sql
export LAST_TURBO_BACKUP_FILEPATH=~/last-$TURBO_REPO_NAME-$DBNAME.sql
