FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update -y \
  && apt-get -y install wget libpq5 libconfig9 \
  && wget -nv http://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+stretch_all.deb \
  && dpkg -i zabbix-release_4.0-2+stretch_all.deb \
  && apt-get -q update \
  && apt-get -y install zabbix-agent zabbix-get \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
