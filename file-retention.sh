#!/bin/bash

#### Flag
while test $# -gt 0; do
  case "$1" in
    -h|--help)
        echo "file-retention.sh - script cleanup backup file"
        echo " "
        echo "file-retention.sh [options] application [arguments]"
        echo " "
        echo "options:"
        echo "-h, --help                        show brief help"
        echo "-db, --db-backup-path=DIR         specify a directory to store database backup file path"
        echo "-logs, --logs-backup-path=DIR     specify a directory to store transaction logs backup file path"
        echo "-hana, --hana-backup-path=DIR     specify a directory to store hana backup file path"
        echo "--days=DIR                        specify day retention period expires.(default=3)"
        exit 0
        ;;
    -db|--db-backup-path)
        shift
        if test $# -gt 0; then
            export db_path=$1
        else
            echo "no database backup dir specified"
            exit 1
        fi
        shift
        ;;
    --db-backup-path*)
        export db_path=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
    -logs|--logs-backup-path)
        shift
        if test $# -gt 0; then
            export logs_path=$1
        else
            echo "no transaction logs backup dir specified"
            exit 1
        fi
        shift
        ;;
    --logs-backup-path*)
        export logs_path=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
    -hana|--hana-backup-path)
        shift
        if test $# -gt 0; then
            export hana_path=$1
        else
            echo "no transaction logs backup dir specified"
            exit 1
        fi
        shift
        ;;
    --hana-backup-path*)
        export hana_path=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
    --days)
        shift
        if test $# -gt 0; then
            export days=$1
        else
            echo "no transaction logs backup dir specified"
            exit 1
        fi
        shift
        ;;
    --days*)
        export days=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
    *)
        break
        ;;
  esac
done

### main script

if [[ $days == '' ]]
then
    days="3"
fi

if [ -z "$db_path" ] || [ ! -d "$db_path" ]
then
    echo "database backup file path is not specify or path $db_path does not exists." | sed "s/  / /"
else
    echo "database backup file path is $db_path."
    find "$db_path" -maxdepth 3 -name "*.DB.*"  -type f -mmin +$(($days*24*60)) -print -delete
    echo "delete database backup file successfully."
fi

if [ -z "$logs_path" ] || [ ! -d "$logs_path" ]
then
    echo "transaction logs backup file path is not specify or path $logs_path does not exists." | sed "s/  / /"
else
    echo "transaction logs backup file path is $logs_path."
    find "$logs_path" -maxdepth 3 -name "*.TRAN.*"  -type f -mmin +$(($days*24*60)) -print -delete
    echo "delete transaction logs backup file successfully."
fi

if [ -z "$hana_path" ] || [ ! -d "$hana_path" ]
then
    echo "hana backup file path is not specify or path $hana_path does not exists." | sed "s/  / /"
else
    echo "hana backup file path is $hana_path."
    find "$hana_path" -maxdepth 3 -name "*_databackup_*"  -type f -mmin +$(($days*24*60)) -print -delete
    echo "delete hana backup file successfully."
fi

if [ -z "$db_path" ] && [ -z "$logs_path" ] && [ -z "$hana_path" ]
then
    exit 1
fi