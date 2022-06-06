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
        echo "-hana, --hana-backup-path=DIR     specify a directory to store transaction hana backup file path"
        echo "--days=DIR                        specify day retention period expires.(default=3)"
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

in_date=$(date -d "${days} days ago" +"%Y%m%d")
db_regex=".*\.DB\.(([12][0-9]{3})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01]))\..*"
log_regex=".*\.TRAN\.(([12][0-9]{3})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01]))\..*"
hana_regex="(([12][0-9]{3})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))_.*_databackup_.*"

if [ -z "$db_path" ] || [ ! -d "$db_path" ]
then
    echo "database backup file path is not specify or path $db_path does not exists." | sed "s/  / /"
else
    echo "database backup file path is $db_path."
    for list_file in "$db_path"/*
    do
        if [[ $list_file =~ $db_regex ]]; then
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
        if [[ $list_file =~ $log_regex ]]; then
            rm "$list_file"
            echo "$list_file has deleted."
        fi
    done
    echo "delete transaction logs backup file successfully."
fi

if [ -z "$hana_path" ] || [ ! -d "$hana_path" ]
then
    echo "hana backup file path is not specify or path $hana_path does not exists." | sed "s/  / /"
else
    echo "hana backup file path is $hana_path."
    for list_file in "$hana_path"/*
    do
        if [[ $list_file =~ $hana_path ]]; then
            rm "$list_file"
            echo "$list_file has deleted."
        fi
    done
    echo "delete hana backup file successfully."
fi

if [ -z "$db_path" ] && [ -z "$logs_path" ] && [ -z "$hana_path" ]
then
    exit 1
fi