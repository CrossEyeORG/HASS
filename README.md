<a href="https://www.home-assistant.io/"><img src="https://raw.githubusercontent.com/home-assistant/assets/master/logo-round-192x192.png" title="Home Assistant" alt="HomeAssistant"></a>

<!-- [![Home Assistant](https://raw.githubusercontent.com/home-assistant/assets/master/logo-round-192x192.png)](https://www.home-assistant.io/) -->

# Home Assistant (HASS) Tools
Random Home Assistant tools that CrossEye has created.

## HASS Updater
- This bash script will automatically update your HASS Python virtual environment.
- Script will only stop/start HASS when an update is available.
- Script also emits each run to the local syslog.

#### Configuration

> Globals need to be updated to your local environment
```shell
HASS_VIRTUALENV_BASE="/srv/homeassistant"   # Where is HASS currently installed?
HASS_VIRTUALENV_USER="homeassistant"        # What user is HASS running under?
HASS_SERVICE_NAME="homeassistant.service"   # What is the HASS systemd service named?
```

> Add to a cron job using a user with sudo access
```shell
$ sudo crontab -u root -e
0 * * * * /etc/homeassistant/hass_updater.sh
```
