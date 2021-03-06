# libzbxpgsql-build

Build and test scripts for [libzbxpgsql](https://github.com/cavaliercoder/libzbxpgsql).

## Setup (based on Centos 7)

* Install OS development packages
```
sudo yum -y groupinstall development
```
* Install docker repository (https://docs.docker.com/engine/installation/linux/centos/):
```
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```
* Install docker
```
sudo yum -y install docker-engine
```
* Enable and start docker daemon:
```
sudo systemctl enable docker.service && sudo systemctl start docker.service
```
* Allow your userid to connect to docker daemon:
```
sudo usermod -G docker -a <userid>
```
__Note: you'll need to logout/login to enable the new group permission__

* Install docker-compose (https://docs.docker.com/compose/install/):
```
sudo curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
* Clone this repo
* Clone `libzbxpgsql` sources into `./libzbxpgsql`
* Ensure `PACKAGE_VERSION` in `Makefile` matches the `AC_INIT` version in
   `./libzbxpgsql/configure.ac`
* Unzip Zabbix sources into `./zabbix-X.X.X` (2.2.0, 3.0.0, & 3.2.0)
* Build the Docker images with `make docker-images`
    * Take a nap, this will run a while...

## Docker images

This repo uses Docker to create immutable build and test environments so that:

* Build and tests run in a known state
* Developer workstation is left alone
* Multiple operating systems can be tested quickly

All Dockerfiles are stored and built in `./docker`.

## Build targets
  
* `make docker-images`:
  
  Builds all Docker images required to build, package and test `libzbxpgsql`
  * Note: This will take a while to run initially

* `make libzbxpgsql.so`:

  Compiles the main module in place (`./libzbxpgsql/src/libs/libzbxpgsql.so`)

* `make dist`:
  
  Builds a source distribution archive, used as input for packaging systems

* `make package [OPTION=VALUE, ...]`:
  
  Builds a package for the desired target. Supports the following options:

  * `ZABBIX_VERSION=n.n.n`
  * `TARGET_MANAGER=apt|yum`
  * `TARGET_OS=rhel|debian|ubuntu`
  * `TARGET_OS_MAJOR=6|7|wheezy|jessie|precise|trusty`
  * `TARGET_ARCH=amd64|x86_64`

* `./package-all.sh`:

  Performs the above builds for all supported versions of the package

* `make package-tests`:
  
  Test the installation and configuration of built packages on all supported
  operating systems

* `make key-tests`:

  Run tests using a live agent against all supported versions of PostgreSQL.
  This requires `make testenv` to be running in another terminal.

* `make testenv`:
  
  Use `docker-compose` to run all supported versions of PostgreSQL and a Zabbix
  agent loaded with `libzbxpgsql` (if `make libzbxpgsql.so` has been run)

* `make agent`:
  
  Start the Zabbix v3 agent on the build container

* `make shell-<OS>`:
  
  Run an interactive shell in a new instance of the `libzbxpgsql/build`
  container on specified OS.  Supported OS's are:
  * wheezy
  * jessie
  * precise
  * trusty
  * centos-6
  * centos-7

* `sudo make clean`:
  
  Destroy all build and package output, including the `./release` directory

* `make docker-clean-all`:
  
  Destroy all docker containers and images
