#!/bin/sh
echo "SHELL=/bin/sh" > /etc/cron.d/crontab
echo "PATH=$PATH" >> /etc/cron.d/crontab
if [ -n "$DOCKER_HOST" ]; then
    # include Docker connection if set
    echo "DOCKER_HOST=$DOCKER_HOST" >> /etc/cron.d/crontab
fi
echo "" >> /etc/cron.d/crontab

php /crontab_builder.php /cron_scripts/ >> /etc/cron.d/crontab
chmod 0644 /etc/cron.d/crontab && /usr/bin/crontab /etc/cron.d/crontab

exec cron -f 