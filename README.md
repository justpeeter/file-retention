# file-retention.sh - script cleanup backup file
 
### ***file-retention.sh [options] application [arguments]***
 
### options:
    -h, --help                            show brief help
    -db, --db-backup-path=DIR             specify a directory to store database backup file path
    -logs, --logs-backup-path=DIR         specify a directory to store transaction logs backup file path
    -hana, --hana-backup-path=DIR         specify a directory to store hana backup file path
    --days=DIR                            specify day retention period expires.(default=3)
    -display, --display-logs-path=DIR     specify a directory to store script log file path(default=/otp/DB_Retention)

