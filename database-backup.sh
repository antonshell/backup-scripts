#! /bin/bash

 TIMESTAMP=$(date +"%F-%T")
 BACKUP_DIR="/var/backups/databases/$TIMESTAMP"
 MYSQL_USER="backup"
 MYSQL=/usr/bin/mysql
 MYSQL_PASSWORD="your_password"
 MYSQL_HOST="localhost"
 AWS=/usr/local/bin/aws

 MYSQLDUMP=/usr/bin/mysqldump databases=`$MYSQL --user=$MYSQL_USER -h$MYSQL_HOST -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
 mkdir -p "$BACKUP_DIR"

 for db in $databases; do
   echo $db
   time $MYSQLDUMP -Qc --add-drop-table --single-transaction --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/$db.gz"
 done

# $AWS s3 cp $BACKUP_DIR s3://yumapos-php-dev-backup/databases/$TIMESTAMP --recursive
 /usr/bin/sshpass -f "/opt/pwd" scp -P 22 -r $BACKUP_DIR bcp@111.222.333.444:/var/bcp/php-dev/databases/$TIMESTAMP
 rm -rf /var/backups/databases/*
