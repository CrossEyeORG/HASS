#!/bin/bash
################################################################
#Script Name    : hass_updater.sh
#Description    : Auto updates Home Assistant (HASS) Python virtual environment.
#Author         : Gabriel Zellmer (CrossEye)
#Repository     : https://github.com/CrossEyeORG/HASS
#Version        : 1.0
#Notes          : Needs the globals configured to your local environment and added to a cron job.
################################################################


# Global variables
HASS_VIRTUALENV_BASE="/srv/homeassistant"
HASS_VIRTUALENV_USER="homeassistant"
HASS_SERVICE_NAME="homeassistant.service"
HASS_INSTALLED_VERSION=$($HASS_VIRTUALENV_BASE/bin/hass --version)
HASS_AVAILABLE_VERSION=$(/usr/bin/curl --silent "https://api.github.com/repos/home-assistant/core/releases/latest" | /usr/bin/grep -Po '"tag_name": "\K.*?(?=")')

# Emitting logs to Syslog
exec 1> >(logger -s -t $(basename $0)) 2>&1

cat << EOF
[INFO] Version check...
Current version installed: $HASS_INSTALLED_VERSION
Available version in repos: $HASS_AVAILABLE_VERSION
EOF

if (( $(awk 'BEGIN {print ("'$HASS_AVAILABLE_VERSION'" > "'$HASS_INSTALLED_VERSION'")}') )); then
    printf "[INFO] Newer version available, beginning upgrade...\n"
    /usr/bin/systemctl stop $HASS_SERVICE_NAME
    sudo -u $HASS_VIRTUALENV_USER -H -s << EOF
        cd $HASS_VIRTUALENV_BASE
        . bin/activate
        bin/pip3 install --upgrade homeassistant
        exit
EOF
    /usr/bin/systemctl start $HASS_SERVICE_NAME
else
    printf "[INFO] Latest version installed, skipping upgrade...\n"
fi

exit
