#!/bin/bash
################################################################
#Script Name    : hass_ca_sync.sh
#Description    : Copies Host CA Trust Store Certs to Home Assistant (HASS) Python virtual environment (Core) at startup.
#Author         : Gabriel Zellmer (CrossEye)
#Repository     : https://github.com/CrossEyeORG/HASS
#Version        : 1.0
#Notes          : Needs the globals configured to your local environment and added to a systemd timer.
#                 Additionally, update your Home Assistant systemd service with "ExecStartPre=/etc/homeassistant/hass_ca_sync.sh"
################################################################


# Global variables
HASS_SERVICE_NAME="homeassistant.service"
HASS_HOST_CA_PATH="/etc/ssl/certs/ca-certificates.crt"
HASS_VIRTUALENV_BASE="/srv/homeassistant"

# Emitting logs to Syslog
exec 1> >(logger -s -t $(basename $0)) 2>&1

printf "[INFO] Setting HASS python venv Certifi path...\n" >&2
cd $HASS_VIRTUALENV_BASE
. bin/activate
HASS_CERTIFI_PATH=$(bin/python -m certifi)

printf "[INFO] Comparing local CA trust store to Certifi CA trust store...\n" >&2
if cmp -s "$HASS_HOST_CA_PATH" "$HASS_CERTIFI_PATH"; then
    printf "[INFO] Certifi has already been updated with the host CA trust store. No action needed." >&2
    exit 0
else
    printf "[INFO] Certifi has not been updated with host CA trust store. Performing action..." >&2
    cat $HASS_HOST_CA_PATH > $HASS_CERTIFI_PATH 2>&1 | tee -a ${LOGFILE}
    /usr/bin/systemctl restart $HASS_SERVICE_NAME
    exit 1
fi
