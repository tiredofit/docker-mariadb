# github.com/tiredofit/docker-mariadb

[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/mariadb.svg)](https://hub.docker.com/r/tiredofit/mariadb)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/mariadb.svg)](https://hub.docker.com/r/tiredofit/mariadb)
[![Docker
Layers](https://images.microbadger.com/badges/image/tiredofit/mariadb.svg)](https://microbadger.com/images/tiredofit/mariadb)

## Introduction

Dockerfile to build a [MariaDB Server](https://mariadb.org) Image.

* Configuration tweaked to use all around settings for general usage - Can be changed
* Can use official Mysql/MariaDB environment variables (MYSQL_USER, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD)
* Allows for automatically creating multiple databases on container initialization
* Automatic Table/DB Upgrade support if MariaDB version has changed
* Includes MySQL Tuner inside image to optimize your configuration
* Zabbix Monitoring for metrics

Also has the capability of backing up embedded in the container based on the [tiredofit/dbbackup](https://github.com/tiredofit/docker-db-backup) image which includes the following features:

* dump to local filesystem
* Backup all databases
* choose to have an MD5 sum after backup for verification
* delete old backups after specific amount of time
* choose compression type (none, gz, bz, xz)
* select how often to run a dump
* select when to start the first dump, whether time of day or relative to container start time

* This Container uses a [customized Alpine Linux base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, mariadb-client, nano, vim) for easier management. It also supports sending to external SMTP servers..


[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data-Volumes](#data-volumes)
  - [Environment Variables](#environment-variables)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
    - [Mysql Tuner](#mysql-tuner)
- [References](#references)

## Prerequisites


## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/mariadb) and is the recommended method of installation.

```bash
docker pull tiredofit/mariadb
```

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](/examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

## Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory           | Description                                                    |
| ------------------- | -------------------------------------------------------------- |
| `/var/lib/mysql`    | MySQL Data Directory                                           |
| `/etc/mysql/conf.d` | Optional directory to put .cnf files for additional directives |
| `/backup`           | Optional directory for backups                                 |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of available options that can be used to customize your installation.


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

This image can also backup databases on a scheduled basis as well. These environment variables are:


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
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. mariadb) bash
```

#### Mysql Tuner

This image comes with [Mysql Tuner](https://github.com/major/MySQLTuner-perl). Simply enter inside the container and execute `mysql-tuner` along with your arguments.

Manual Backups can be perforemd by entering the container and typing `backup-now`

## References

* https://mariadb.org
