# github.com/tiredofit/docker-mariadb

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-mariadb?style=flat-square)](https://github.com/tiredofit/docker-mariadb/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-mariadb/main.yml?branch=10.6&style=flat-square)](https://github.com/tiredofit/docker-mariadb/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/mariadb.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/mariadb/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/mariadb.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/mariadb/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker image for [MariaDB](https://mariadb.org). A relational database forked from MySQL.

* Configuration tweaked to use all around settings for general usage - Can be changed
* Can use official Mysql/MariaDB environment variables (MYSQL_USER, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD)
* Allows for automatically creating multiple databases on container initialization and subsequent reboots
* Automatic Table/DB Upgrade support if MariaDB version has changed
* Includes MySQL Tuner inside image to optimize your configuration
* Logging with automatic rotation
* Zabbix Monitoring for metrics

Also has the capability of backing up embedded in the container based on the [tiredofit/dbbackup](https://github.com/tiredofit/docker-db-backup) image which includes the following features:

* dump to local filesystem
* Backup all databases
* choose to have an MD5?SHA sum after backup for verification
* delete old backups after specific amount of time
* choose compression type (none, gz, bz, xz,zstd)
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
    - [Container Options](#container-options)
    - [MariaDB Options](#mariadb-options)
    - [Database Options](#database-options)
    - [Logging Options](#logging-options)
    - [Backup Options](#backup-options)
      - [Database Options](#database-options-1)
      - [Scheduling Options](#scheduling-options)
      - [Other Backup Options](#other-backup-options)
    - [Backing Up to S3 Compatible Services](#backing-up-to-s3-compatible-services)
    - [Upload to a Azure storage account by `blobxfer`](#upload-to-a-azure-storage-account-by-blobxfer)
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
docker pull ghcr.io/tiredofit/docker-mariadb:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Version   | Container OS | Tag       |
| --------- | ------------ | --------- |
| latest    | Alpine       | `:latest` |
| `10.11.x` | Alpine       | `:10.11`  |
| `10.10.x` | Alpine       | `:10.10`  |
| `10.9.x`  | Alpine       | `:10.9`   |
| `10.8.x`  | Alpine       | `:10.8`   |
| `10.6.x`  | Alpine       | `:10.6`   |
| `10.5.x`  | Alpine       | `:10.5`   |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

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

#### Container Options
| Parameter            | Description                                       | Default                 |
| -------------------- | ------------------------------------------------- | ----------------------- |
| `CERT_PATH`          | Certs Path                                        |                         |
| `CONFIG_FILE`        | Configuration File to load - Not needed to be set | `my.cnf`                |
| `CONFIG_PATH`        | Configuration Path                                | `/etc/mysql/`           |
| `CONFIG_CUSTOM_PATH` | Configuration Override Path                       | `${CONFIG_PATH}/conf.d` |
| `DATA_PATH`          | Data Files Path                                   | `/var/lib/mysql/`       |
| `LOG_PATH`           | Log Files Path                                    | `/logs/`                |
| `SOCKET_FILE`        | Socket Name                                       | `mysqld.sock`           |
| `SOCKET_PATH`        | Socket Path                                       | `/run/mysqld/`          |

#### MariaDB Options

| Parameter          | Description                                                                                                                            | Default              | `_FILE` |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------- | -------------------- | ------- |
| `CHARACTER_SET`    | Set Default Character Set                                                                                                              | `utf8mb4`            |         |
| `COLLATION`        | Set Default Collation                                                                                                                  | `utf8mb4_general_ci` |         |
| `DB_AUTO_UPGRADE`  | If MariaDB has changed from first time image has been used, automatically upgrade DBs and tables to latest versions - `TRUE` / `FALSE` | `TRUE`               |         |
| `DB_CONFIGURATION` | Type of Configuration - `standard`, or `default`                                                                                       | `standard`           |         |
| `LISTEN_PORT`      | Listening Port                                                                                                                         | `3306`               |         |
| `ROOT_PASS`        | Root Password for Instance (e.g. password)                                                                                             |                      | x       |
| `MYSQLD_ARGS`      | Add extra arguments to the mariadb execution                                                                                           |                      |         |

* With regards to `DB_CONFIGURATION`
  - `default` - Means the default my.cnf file from MariaDB
  - `standard` - My own settings that I find work for my own DB servers.

#### Database Options

Automatically create user databases on startup. This can be done on each container start, and then removed on subsequent starts if desired.

| Parameter   | Description                               | Default | `_FILE` |
| ----------- | ----------------------------------------- | ------- | ------- |
| `CREATE_DB` | Automatically create databases on startup | `TRUE`  |         |
| `DB_NAME`   | Database Name e.g. `database`             |         | x       |
| `DB_USER`   | Database User e.g. `user`                 |         | x       |
| `DB_PASS`   | Database Pass e.g. `password`             |         | x       |

**OR**

Create multiple databases and different usernames and passwords to access. You can share usernames and passwords for multiple databases by using the same user and password in each entry.

| Parameter   | Description                                        | Default | `_FILE` |
| ----------- | -------------------------------------------------- | ------- | ------- |
| `DB01_NAME` | First Database Name e.g. `database1`               |         | x       |
| `DB01_USER` | First Database User e.g. `user1`                   |         | x       |
| `DB01_PASS` | First Database Pass e.g. `password1`               |         | x       |
| `DB02_NAME` | Second Database Name e.g. `database1`              |         | x       |
| `DB02_USER` | Second Database User e.g. `user2`                  |         | x       |
| `DB02_PASS` | Second Database Pass e.g. `password2`              |         | x       |
| `DBXX_...`  | As above, should be able to go all the way to `99` |         |         |


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
The backup functionality is a subset of the [tiredofit/db-backup](https://github.com/tiredofit/docker-db-backup) image. Please have a peek at the README to understand ways to use. All features have been carried over with the exception of being able to backup remote systems - It is hardcoded to connect to the MariaDB socket not requiring DB_HOST/DB_PORT variables.


| Parameter                         | Description                                                                                                                      | Default         |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `DB_BACKUP`                       | Activate backup scheduler by setting to `TRUE`                                                                                   | `FALSE`         |
| `DB_BACKUP_BACKUP_LOCATION`       | Backup to `FILESYSTEM` or `S3` compatible services like S3, Minio, Wasabi                                                        | `FILESYSTEM`    |
| `DB_BACKUP_MODE`                  | `AUTO` mode to use internal scheduling routines or `MANUAL` to simply use this as manual backups only executed by your own means | `AUTO`          |
| `DB_BACKUP_MANUAL_RUN_FOREVER`    | `TRUE` or `FALSE` if you wish to try to make the container exit after the backup                                                 | `TRUE`          |
| `DB_BACKUP_TEMP_LOCATION`         | Perform Backups and Compression in this temporary directory                                                                      | `/tmp/backups/` |
| `DB_BACKUP_CREATE_LATEST_SYMLINK` | Create a symbolic link pointing to last backup in this format: `latest-(DB_TYPE)-(DB_NAME)-(DB_HOST)`                            | `TRUE`          |
| `DEBUG_MODE`                      | If set to `true`, print copious shell script messages to the container log. Otherwise only basic messages are printed.           | `FALSE`         |
| `DB_BACKUP_PRE_SCRIPT`            | Fill this variable in with a command to execute pre backing up                                                                   |                 |
| `DB_BACKUP_POST_SCRIPT`           | Fill this variable in with a command to execute post backing up                                                                  |                 |
| `DB_BACKUP_SPLIT_DB`              | For each backup, create a new archive. `TRUE` or `FALSE` (MySQL and Postgresql Only)                                             | `TRUE`          |

##### Database Options
| Parameter                | Description                                                                                                                                 | Default | `_FILE` |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------- |
| `DB_BACKUP_NAME`         | Schema Name e.g. `database` or `ALL` to backup all databases the user has access to. Backup multiple by seperating with commas eg `db1,db2` |         |  |
| `DB_BACKUP_NAME_EXCLUDE` | If using `ALL` - use this as to exclude databases seperated via commas from being backed up                                                 |         |  |
| `DB_BACKUP_USER`         | username for the database(s) - Can use `root`                                                                                               |         | x|
| `DB_BACKUP_PASS`         | (optional if DB doesn't require it) password for the database                                                                               |         | x|

##### Scheduling Options
| Parameter                       | Description                                                                                                                                                                                        | Default   |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `DB_BACKUP_DUMP_FREQ`           | How often to do a dump, in minutes after the first backup. Defaults to 1440 minutes, or once per day.                                                                                              | `1440`    |
| `DB_BACKUP_DUMP_BEGIN`          | What time to do the first dump. Defaults to immediate. Must be in one of two formats                                                                                                               |           |
|                                 | Absolute HHMM, e.g. `2330` or `0415`                                                                                                                                                               |           |
|                                 | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half                                                     |           |
| `DB_BACKUP_DUMP_TARGET`         | Directory where the database dumps are kept.                                                                                                                                                       | `/backup` |
| `DB_BACKUP_DUMP_TARGET_ARCHIVE` | Optional Directory where the database dumps archives are kept.                                                                                                                                     |
| `DB_BACKUP_CLEANUP_TIME`        | Value in minutes to delete old backups (only fired when dump freqency fires). 1440 would delete anything above 1 day old. You don't need to set this variable if you want to hold onto everything. | `FALSE`   |
| `DB_ARCHIVE_TIME`               | Value in minutes to move all files files older than (x) from `DB_BACKUP_DUMP_TARGET` to `DB_BACKUP_DUMP_TARGET_ARCHIVE` - which is useful when pairing against an external backup system.          |

##### Other Backup Options
| Parameter                                | Description                                                                                                                  | Default        |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `DB_BACKUP_COMPRESSION`                  | Use either Gzip `GZ`, Bzip2 `BZ`, XZip `XZ`, ZSTD `ZSTD` or none `NONE`                                                      | `ZSTD`         |
| `DB_BACKUP_COMPRESSION_LEVEL`            | Numberical value of what level of compression to use, most allow `1` to `9` except for `ZSTD` which allows for `1` to `19` - | `3`            |
| `DB_BACKUP_ENABLE_PARALLEL_COMPRESSION`  | Use multiple cores when compressing backups `TRUE` or `FALSE`                                                                | `TRUE`         |
| `DB_BACKUP_PARALLEL_COMPRESSION_THREADS` | Maximum amount of threads to use when compressing - Integer value e.g. `8`                                                   | `autodetected` |
| `DB_BACKUP_GZ_RSYNCABLE`                 | Use `--rsyncable` (gzip only) for faster rsync transfers and incremental backup deduplication. e.g. `TRUE`                   | `FALSE`        |
| `DB_BACKUP_ENABLE_CHECKSUM`              | Generate either a MD5 or SHA1 in Directory, `TRUE` or `FALSE`                                                                | `TRUE`         |
| `DB_BACKUP_CHECKSUM`                     | Either `MD5` or `SHA1`                                                                                                       | `MD5`          |
| `DB_BACKUP_EXTRA_OPTS`                   | If you need to pass extra arguments to the backup command, add them here e.g. `--extra-command`                              |                |

#### Backing Up to S3 Compatible Services

If `DB_BACKUP_LOCATION` = `S3` then the following options are used.

| Parameter                       | Description                                                                               | Default | `_FILE` |
| ------------------------------- | ----------------------------------------------------------------------------------------- | ------- | ---- |
| `DB_BACKUP_S3_BUCKET`           | S3 Bucket name e.g. `mybucket`                                                            |         | x |
| `DB_BACKUP_S3_KEY_ID`           | S3 Key ID (Optional)                                                                      |         | x |
| `DB_BACKUP_S3_KEY_SECRET`       | S3 Key Secret (Optional)                                                                  |         | x |
| `DB_BACKUP_S3_PATH`             | S3 Pathname to save to (must NOT end in a trailing slash e.g. '`backup`')                 |         | x |
| `DB_BACKUP_S3_REGION`           | Define region in which bucket is defined. Example: `ap-northeast-2`                       |         | x |
| `DB_BACKUP_S3_HOST`             | Hostname (and port) of S3-compatible service, e.g. `minio:8080`. Defaults to AWS.         |         | x |
| `DB_BACKUP_S3_PROTOCOL`         | Protocol to connect to `S3_HOST`. Either `http` or `https`. Defaults to `https`.          | `https` | x |
| `DB_BACKUP_S3_EXTRA_OPTS`       | Add any extra options to the end of the `aws-cli` process execution                       |         | x |
| `DB_BACKUP_S3_CERT_CA_FILE`     | Map a volume and point to your custom CA Bundle for verification e.g. `/certs/bundle.pem` |         | x |
| _*OR*_                          |                                                                                           |         |  |
| `DB_BACKUP_S3_CERT_SKIP_VERIFY` | Skip verifying self signed certificates when connecting                                   | `TRUE`  |  |

- When `DB_BACKUP_S3_KEY_ID` and/or `DB_BACKUP_S3_KEY_SECRET` is not set, will try to use IAM role assigned (if any) for uploading the backup files to S3 bucket.

#### Upload to a Azure storage account by `blobxfer`

Support to upload backup files with [blobxfer](https://github.com/Azure/blobxfer) to the Azure fileshare storage.


If `DB_BACKUP_BACKUP_LOCATION` = `blobxfer` then the following options are used.

| Parameter                                | Description                                 | Default             | `_FILE` |
| ---------------------------------------- | ------------------------------------------- | ------------------- | ------- |
| `DB_BACKUP_BLOBXFER_STORAGE_ACCOUNT`     | Microsoft Azure Cloud storage account name. |                     | x|
| `DB_BACKUP_BLOBXFER_STORAGE_ACCOUNT_KEY` | Microsoft Azure Cloud storage account key.  |                     | x|
| `DB_BACKUP_BLOBXFER_REMOTE_PATH`         | Remote Azure path                           | `/docker-db-backup` |  |

> This service uploads files from backup targed directory `DB_BACKUP_DUMP_TARGET`.
> If the a cleanup configuration in `DB_BACKUP_CLEANUP_TIME` is defined, the remote directory on Azure storage will also be cleaned automatically.


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
