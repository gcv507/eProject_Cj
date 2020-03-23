#...............................................................
# Backup Domain Script
#
# This script will backup the PowerCenter Domain to
# $INFA_SHARED/Backup folder
#
# Created by: Chiranjeevulu GORAKALA
# Created on: March 24, 2020
# Modified by: -
# Modified on: -
#...............................................................
RUN_USER=`whoami`
if [ $RUN_USER = 'infaadmn' ] ; then
temp_var=1
else
echo "Warning!! You cannot execute this script with the current user. Please login as infa951 and execute this script"
exit -1
fi

BACKUP_DIR=$INFA_SHARED/Backup/da_backups
timestamp=`date +%m%d%Y`
BACKUP_FILE=$INFA_DOMAIN.$timestamp
find $BACKUP_DIR -name "$INFA_DOMAIN.*.mrep.gz" -mtime \+14 -exec rm -f {} \;
clear
echo "
...............................................................
PowerCenter Domain Backup Process
...............................................................

     Domain Name: $INFA_DOMAIN
     Backup Dir: $BACKUP_DIR
...............................................................

Please wait...

"
infasetup.sh backupdomain -f -da $REP_DATABASE_HOST_NAME:$REP_DATABASE_PORT_NUMBER -du $INFA_DEFAULT_DATABASE_USER -dt $REP_DATABASE_TYPE -bf $BACKUP_DIR/$BACKUP_FILE -dn $INFA_DOMAIN -ds $REP_DATABASE_SERVICE_NAME
RC=$?
if [ $RC != 0 ] ; then
echo "$INFA_DOMAIN backup failed" | mailx -s "Alert! Informatica Development Domain backup failed" TWDAINFSupport@timewarner.com
fi
gzip $BACKUP_DIR/$BACKUP_FILE.mrep
exit 0
~
