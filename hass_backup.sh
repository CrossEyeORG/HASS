#!/bin/bash
################################################################
#Script Name    : hass_backup.sh
#Description    : Auto backup for your Home Assistant (HASS) config.
#Author         : Gabriel Zellmer (CrossEye)
#Repository     : https://github.com/CrossEyeORG/HASS
#Version        : 1.0
#Notes          : Needs the globals configured to your local environment and added to a cron job.
################################################################


# Global variables
HASS_BACKUP_FROM="/etc/homeassistant"
HASS_BACKUP_TO="/mnt/backups"
HASS_INCLUDE_DB="true"
HASS_RETENTION_DAYS="90"
HASS_BACKUP_SYNTAX="${HASS_BACKUP_TO}/hass-config_$(date +"%Y%m%d_%H%M%S").tar.gz"

# Emitting logs to Syslog
exec 1> >(logger -s -t $(basename $0)) 2>&1

if [ -d ${HASS_BACKUP_FROM} ] && [ -d ${HASS_BACKUP_TO} ]; then
    if [ ${HASS_INCLUDE_DB} = true ] ; then
        printf "[INFO] Starting backup including database...\n"
        tar -cpzf ${HASS_BACKUP_SYNTAX} --exclude="temp/*" --exclude="deps/*" --exclude="*.log" --absolute-names ${HASS_BACKUP_FROM}
    else
        printf "[INFO] Starting backup excluding database...\n"
        tar -cpzf ${HASS_BACKUP_SYNTAX} --exclude="temp/*" --exclude="deps/*" --exclude="home-assistant*.db" --exclude="*.log" --absolute-names ${HASS_BACKUP_FROM}
    fi
    printf "[INFO] Backup complete, checking retention...\n"
    if [ ${HASS_RETENTION_DAYS} = 0 ] ; then
        printf "[INFO] Keeping all backups as retention is set to 0.\n"
    else
        printf "[INFO] Deleting backups older than ${HASS_RETENTION_DAYS} days...\n"
        OLDFILES=$(find ${HASS_BACKUP_TO} -mindepth 1 -mtime +${HASS_RETENTION_DAYS} -delete -print)
    fi
elif [ ! -d ${HASS_BACKUP_FROM} ]; then
    printf "[ERROR] Backup from location does not exist...\n"
elif [ ! -d ${HASS_BACKUP_TO} ]; then
    printf "[ERROR] Backup to location does not exist...\n"
elif [ ! -d ${HASS_BACKUP_FROM} ] && [ ! -d ${HASS_BACKUP_TO} ]; then
    printf "[ERROR] Backup from and to locations do not exist...\n"
fi

exit
