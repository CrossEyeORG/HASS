#!/bin/bash
# CrossEye Home Assistant (HASS) Virtual Environment Update Script

# Global variables
HASS_INSTALLED_VERSION=$(/srv/homeassistant/bin/hass --version)
HASS_AVAILABLE_VERSION=$(/usr/bin/curl --silent "https://api.github.com/repos/home-assistant/core/releases/latest" | /usr/bin/grep -Po '"tag_name": "\K.*?(?=")')
HASS_VIRTUALENV_BASE="/srv/homeassistant"
HASS_VIRTUALENV_USER="homeassistant"
HASS_SERVICE_NAME="homeassistant.service"

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
    sudo -u $HASS_VIRTUALENV_USER -H -s << 'EOF'
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
