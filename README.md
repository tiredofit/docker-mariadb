# github.com/tiredofit/docker-mariadb

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-mariadb?style=flat-square)](https://github.com/tiredofit/docker-mariadb/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-mariadb/main.yml?branch=10.10&style=flat-square)](https://github.com/tiredofit/docker-mariadb/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/mariadb.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/mariadb/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/mariadb.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/mariadb/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker image for [MariaDB](https://mariadb.org). A relational database forked from MySQL.

* Configuration tweaked to use all around settings for general usage - Can be changed
* Can use official Mysql/MariaDB environment variables (MYSQL_USER, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD)
* Allows for automatically creating multiple databases on container initialization
* Automatic Table/DB Upgrade support if MariaDB version has changed
* Includes MySQL Tuner inside image to optimize your configuration
* Logging with automatic rotation
* Zabbix Monitoring for metrics

Also has the capability of backing up embedded in the container based on the [tiredofit/dbbackup](https://github.com/tiredofit/docker-db-backup) image which includes the following features:

* dump to local filesystem
* Backup all databases
* choose to have an MD5 sum after backup for verification
* delete old backups after specific amount of time
* choose compression type (none, gz, bz, xz)
* select how often to run a dump
* select when to start the first dump, whether time of day or relative to container start time

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Logging Options](#logging-options)
    - [Backup Options](#backup-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  - [Mysql Tuner](#mysql-tuner)
  - [Manual Backups](#manual-backups)
- [Contributions](#contributions)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`
### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/mariadb)

```bash
docker pull docker.io/tiredofdit/mariadb:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-mariadb/pkgs/container/docker-mariadb) 
 
```
docker pull ghcr.io/tiredofit/docker-mariadb/pkgs/container/docker-mariadb):(imagetag)
``` 

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Version  | Container OS | Tag            |
| -------- | ------------ | -------------- |
| latest   | Alpine       | `:latest`      |
| `10.8.x` | Alpine       | `:10.8-latest` |
| `10.7.x` | Alpine       | `:10.7-latest` |
| `10.6.x` | Alpine       | `:10.6-latest` |
| `10.5.x` | Alpine       | `:10.5-latest` |
| `10.4.x` | Alpine       | `:10.4-latest` |
| `10.3.x` | Alpine       | `:10.3-latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory           | Description                                                    |
| ------------------- | -------------------------------------------------------------- |
| `/var/lib/mysql`    | MySQL Data Directory                                           |
| `/etc/mysql/conf.d` | Optional directory to put .cnf files for additional directives |
| `/backup`           | Optional directory for backups                                 |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


| Parameter          | Description                                                                                                                            | Default              |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `CHARACTER_SET`    | Set Default Character Set                                                                                                              | `utf8mb4`            |
| `COLLATION`        | Set Default Collation                                                                                                                  | `utf8mb4_general_ci` |
| `ROOT_PASS`        | Root Password for Instance (e.g. password)                                                                                             |                      |  |
| `DB_AUTO_UPGRADE`  | If MariaDB has changed from first time image has been used, automatically upgrade DBs and tables to latest versions - `TRUE` / `FALSE` | `TRUE`               |
| `DB_CONFIGURATION` | Type of Configuration - `standard`, or `default`                                                                                       | `standard`           |
| `DB_NAME`          | Optional - Automatically Create Database - Seperate with commas for multiple databases                                                 |                      |
| `DB_USER`          | Optional - Automatically Assign Username Priveleges to Database (e.g. `mysqluser`)                                                     |                      |
| `DB_PASS`          | Password for authentication to above database (e.g.  `password`)                                                                       |                      |

* With regards to `DB_CONFIGURATION`
  - `default` - Means the default my.cnf file from MariaDB
  - `standard` - My own settings that I find work for my own DB servers.

#### Logging Options

| Parameter                  | Description                                                  | Default          |
| -------------------------- | ------------------------------------------------------------ | ---------------- |
| `ENABLE_LOG_ERROR`         | Enable Error Logging                                         | `TRUE`           |
| `ENABLE_LOG_GENERAL_QUERY` | Log all connections and queries to server (performance hit!) | `FALSE`          |
| `ENABLE_SLOW_QUERY_LOG`    | Log all slow queries                                         | `FALSE`          |
| `LOG_PATH`                 | Path where logs are stored                                   | `/logs/`         |
| `LOG_FILE_ERROR`           | Error Log File Name                                          | `error.log`      |
| `LOG_FILE_GENERAL_QUERY`   | General Query Log File name                                  | `general.log`    |
| `LOG_FILE_SLOW_QUERY`      | Slow Query Log File Name                                     | `slow_query.log` |
| `LOG_LEVEL`                | Log Level for warnings `0` to `9`                            | `3`              |


#### Backup Options

| Parameter                        | Description                                                                                                                                                                                        | Default |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `DB_BACKUP`                      | Enable `TRUE` or disable `FALSE` embedded backup routines                                                                                                                                          | `FALSE` |
| `DB_BACKUP_COMPRESSION`          | Use either Gzip `GZ`, Bzip2 `BZ`, XZip `XZ`, or none `NONE`                                                                                                                                        | `GZ`    |
| `DB_BACKUP_DUMP_FREQ`            | How often to do a dump, in minutes. Defaults to 1440 minutes, or once per day.                                                                                                                     |
| `DB_BACKUP_DUMP_BEGIN`           | What time to do the first dump. Defaults to immediate. Must be in one of two formats                                                                                                               |
|                                  | Absolute HHMM, e.g. `2330` or `0415`                                                                                                                                                               |
|                                  | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half                                                     |
| `DB_BACKUP_CLEANUP_TIME`         | Value in minutes to delete old backups (only fired when dump freqency fires). 1440 would delete anything above 1 day old. You don't need to set this variable if you want to hold onto everything. |
| `DB_BACKUP_MD5`                  | Generate MD5 Sum in Directory, `TRUE` or `FALSE`                                                                                                                                                   | `TRUE`  |
| `DB_BACKUP_PARALLEL_COMPRESSION` | Use multiple cores when compressing backups `TRUE` or `FALSE`                                                                                                                                      | `TRUE`  |
| `DB_BACKUP_SPLIT_DB`             | If using root as username and multiple DBs on system, set to TRUE to create Seperate DB Backups instead of all in one.                                                                             | `FALSE` |

### Networking

The following ports are exposed.

| Port   | Description    |
| ------ | -------------- |
| `3306` | MariaDB Server |

## Maintenance
Inside the image are tools to perform modification on how the image runs.

### Shell Access
For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```

### Mysql Tuner

This image comes with [Mysql Tuner](https://github.com/major/MySQLTuner-perl). Simply enter inside the container and execute `mysql-tuner` along with your arguments.

### Manual Backups

Manual Backups can be perforemd by entering the container and typing `backup-now`
## Contributions
Welcomed. Please fork the repository and submit a [pull request](../../pulls) for any bug fixes, features or additions you propose to be included in the image. If it does not impact my intended usage case, it will be merged into the tree, tagged as a release and credit to the contributor in the [CHANGELOG](CHANGELOG).

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.


## References

* https://mariadb.org
