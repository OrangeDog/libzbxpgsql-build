ARCH = $(shell uname -m)

PACKAGE_NAME = libzbxpgsql
PACKAGE_VERSION = 0.2.1

ZABBIX_VERSION = 3.0.2

# args common to all 'docker run' commands
DOCKER_RUNARGS = -it --rm \
		-e "WORKDIR=/root/$(PACKAGE_NAME)" \
		-e "PACKAGE_NAME=$(PACKAGE_NAME)" \
		-e "PACKAGE_VERSION=$(PACKAGE_VERSION)" \
		-e "ZABBIX_VERSION=$(ZABBIX_VERSION)" \
		-v $(shell pwd):/root/$(PACKAGE_NAME)

DOCKER_RUN = docker run $(DOCKER_RUNARGS)

all:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build all

dist:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build dist

deb:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build deb

rpm:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build rpm

clean:
	rm -vf \
		$(PACKAGE_NAME)-$(PACKAGE_VERSION)*.tar.gz \
		$(PACKAGE_NAME)_$(PACKAGE_VERSION)*.deb \
		$(PACKAGE_NAME)-$(PACKAGE_VERSION)*.rpm