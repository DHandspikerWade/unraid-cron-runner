# UnRAID is based on Slackware, but Slackware containers are a pain. So I'm pretending Debian is close enough for most scripts 
FROM php:8.1-cli

# Keeping apt cache to make dependency install by scripts easier
RUN apt-get update -q && apt-get -y install cron

# Include a docker client as UnRAID script make heavy of containers. (Server itself sold seperately)
ARG DOCKER_VERSION=20.10.9
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
  && tar -xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKER_VERSION}.tgz

COPY crontab_builder.php /
RUN mkdir /cron_scripts /tmp/cron_scripts
VOLUME /cron_scripts
WORKDIR /cron_scripts

# Default UnRAID pool storage
VOLUME [ "/mnt/user" ]

COPY run.sh /run.sh
CMD ["sh", "/run.sh"]

