FROM centos:6

RUN \
  rpm -iv http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm \
  && yum install -y zabbix-agent zabbix-get postgresql-libs libconfig \
  && yum clean all

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
