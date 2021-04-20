<a href="https://www.home-assistant.io/"><img src="https://raw.githubusercontent.com/home-assistant/assets/master/logo/logo-small.png" title="Home Assistant" alt="HomeAssistant"></a>

<!-- [![Home Assistant](https://raw.githubusercontent.com/home-assistant/assets/master/logo/logo-small.png)](https://www.home-assistant.io/) -->

# Home Assistant (HASS) Tools
Random Home Assistant tools that CrossEye has created.

## HASS Updater
- This bash script will automatically update your HASS Python virtual environment.
- Script will only stop/start HASS when an update is available.
- Script also emits each run to the local syslog.

#### Considerations
- If hass_updater.sh is being used, it's highly recommended to have regular config backups.

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

## HASS Backup
- This bash script will automatically backup your HASS instance.
- Script will delete older backups than what is defined in `HASS_RETENTION_DAYS`
- Script also emits each run to the local syslog.

#### Configuration

> Globals need to be updated to your local environment
```shell
HASS_BACKUP_FROM="/etc/homeassistant"       # Location to create backup from?
HASS_BACKUP_TO="/mnt/backups"               # Location to send compressed backups to?
HASS_INCLUDE_DB="true"                      # Include database in compressed backup?
HASS_RETENTION_DAYS="90"                    # Number of days to retain backups, set to 0 for indefinite.
```

> Add to a cron job using your homeassistant user
```shell
$ sudo crontab -u homeassistant -e
0 0 * * * /etc/homeassistant/hass_backup.sh
```