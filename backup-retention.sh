#!/bin/sh

#### Flag
while test $# -gt 0; do
  case "$1" in
    -h|--help)
        echo "$package - backup file retention with in 3 days"
        echo " "
        echo "$package [options] application [arguments]"
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
if [ -z "$db_path" ] || [ ! -d "$db_path" ]
then
    echo "database backup file path is not specify or path $db_path does not exists." | sed "s/  / /"
else
    echo "database backup file path is $db_path"
fi

if [ -z "$logs_path" ] || [ ! -d "$logs_path" ]
then
    echo "transaction logs backup file path is not specify or path $logs_path does not exists." | sed "s/  / /"
else
    echo "transaction logs backup file path is $logs_path"
    cmd="find $logs_path -name '*.log' -type f -mtime +60" 
    #cmd="ls"
    echo $cmd
    /bin/bash $cmd
    echo "delete file successfully"
fi

if [ -z "$db_path" ] && [ -z "$logs_path" ]
then
    exit 1
fi