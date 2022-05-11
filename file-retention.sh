#!/bin/bash

#### Flag
while test $# -gt 0; do
  case "$1" in
    -h|--help)
        echo "file-retention.sh - script cleanup file retention with in 3 days"
        echo " "
        echo "file-retention.sh [options] application [arguments]"
        echo " "
        echo "options:"
        echo "-h, --help                        show brief help"
        echo "-d, --db-backup-path=DIR          specify a directory to store database backup file path"
        echo "-l, --logs-backup-path=DIR        specify a directory to store transaction logs backup file path"
        exit 0
        ;;
    -d|--db-backup-path)
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
    -l|--logs-backup-path)
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
    *)
        break
        ;;
  esac
done

### main script

in_date=$(date  --date="3 days ago" +"%Y%m%d")

if [ -z "$db_path" ] || [ ! -d "$db_path" ]
then
    echo "database backup file path is not specify or path $db_path does not exists." | sed "s/  / /"
else
    echo "database backup file path is $db_path."
    for list_file in "$db_path"/*
    do
        if [[ $list_file == *".DB.$in_date"* ]]; then
            rm "$list_file"
            echo "$list_file has deleted."
        fi
    done
    echo "delete database backup file successfully."
fi

if [ -z "$logs_path" ] || [ ! -d "$logs_path" ]
then
    echo "transaction logs backup file path is not specify or path $logs_path does not exists." | sed "s/  / /"
else
    echo "transaction logs backup file path is $logs_path."
    for list_file in "$logs_path"/*
    do
        if [[ $list_file == *".TRAN.$in_date"* ]]; then
            rm "$list_file"
            echo "$list_file has deleted."
        fi
    done
    echo "delete transaction logs backup file successfully."
fi

if [ -z "$db_path" ] && [ -z "$logs_path" ]
then
    exit 1
fi