#!/bin/bash
# CrossEye Homeassistant Update Script

HASS_INSTALLED_VERSION=$(/srv/homeassistant/bin/hass --version)
HASS_AVAILABLE_VERSION=$(curl --silent "https://api.github.com/repos/home-assistant/core/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
HASS_VIRTUALENV_USER="homeassistant"

cat << EOF
[INFO] Version check...
Currently version installed: $HASS_INSTALLED_VERSION
Available version in repos: $HASS_AVAILABLE_VERSION
EOF

if (( $(awk 'BEGIN {print ("'$HASS_AVAILABLE_VERSION'" > "'$HASS_INSTALLED_VERSION'")}') )); then
    printf "[INFO] Newer version available, beginning upgrade...\n"
    sudo service homeassistant stop
    sudo -u $HASS_VIRTUALENV_USER -H -s << 'EOF'
        source /srv/homeassistant/bin/activate
        pip3 install --upgrade homeassistant
        exit
EOF
    sudo service homeassistant start
else
    printf "[INFO] Latest version installed, skipping upgrade...\n"
fi

exit
