#! /bin/bash

 TIMESTAMP=$(date +"%F-%T")
 BACKUP_DIR="/var/backups/files/$TIMESTAMP"
 AWS=/usr/local/bin/aws
 TAR=/bin/tar
 
 ARCHIEVE_NAME="uploads.tar.gz"
 SRC_DIR="/var/www/cabinet/web/uploads"

 mkdir -p "$BACKUP_DIR"

 $TAR -zcvf $BACKUP_DIR/$ARCHIEVE_NAME $SRC_DIR

# $AWS s3 cp $BACKUP_DIR s3://yumapos-php-dev-backup/files/$TIMESTAMP --recursive
 sshpass -f "/opt/pwd" scp -P 22 -r $BACKUP_DIR bcp@111.222.333.444:/var/bcp/php-dev/files/$TIMESTAMP
 rm -rf /var/backups/files/*
