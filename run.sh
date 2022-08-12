#!/bin/sh
php /crontab_builder.php /cron_scripts/ > /etc/cron.d/crontab
chmod 0644 /etc/cron.d/crontab && /usr/bin/crontab /etc/cron.d/crontab

exec cron -f 