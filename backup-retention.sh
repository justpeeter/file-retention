#!/bin/bash

#### Flag
while test $# -gt 0; do
  case "$1" in
    -h|--help)
        echo "$package - bcakup file retention with in 3 days"
        echo " "
        echo "$package [options] application [arguments]"
        echo " "
        echo "options:"
        echo "-h, --help                        show brief help"
        echo "-d, --db-backup-path=DIR          specify a directory to store database backup file path"
        echo "-l, --logs-backup-path=DIR        specify a directory to store transaction logs file path"
        exit 0
        ;;
    -d|--db-backup-path)
        shift
        if test $# -gt 0; then
            export db_path=$1
        else
            echo "no process specified"
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
            echo "no output dir specified"
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
if [ -z "$db_path" ]
then
    echo "database backup file path is not specify"
else
    echo "database backup file path is $db_path"
fi

if [ -z "$logs_path" ]
then
    echo "transaction logs file path is not specify"
else
    echo "transaction logs file path is $logs_path"
fi