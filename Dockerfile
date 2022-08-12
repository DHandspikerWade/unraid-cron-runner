# UnRAID is based on Slackware, but Slackware containers are a pain. So I'm pretending Debian is close enough for most scripts 
FROM php:8.1-cli

# Keeping apt cache to make dependency install by scripts easier
RUN apt-get update -q && apt-get -y install cron

COPY crontab_builder.php /
RUN mkdir /cron_scripts /tmp/cron_scripts
VOLUME /cron_scripts
WORKDIR /cron_scripts

# Default UnRAID pool storage
VOLUME [ "/mnt/user" ]

COPY run.sh /run.sh
CMD ["sh", "/run.sh"]

