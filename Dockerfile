FROM php:8.1-cli

RUN apt-get update && apt-get -y install cron

RUN mkdir /cron_scripts
WORKDIR /cron_scripts

COPY script /cron_scripts/twitch.php
RUN touch twitch.log

COPY ./crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab && /usr/bin/crontab /etc/cron.d/crontab